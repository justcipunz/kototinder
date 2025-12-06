import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/cat_service.dart';
import '../models/cat_model.dart';
import 'details_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final CatService _catService = CatService();
  CatModel? _currentCat;
  bool _isLoading = true;
  int _likeCount = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNewCat();
  }

  Future<void> _loadNewCat() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cat = await _catService.getRandomCat();
      if (mounted) {
        setState(() {
          _currentCat = cat;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
        _showErrorDialog(e.toString());
      }
    }
  }

  void _onLike() {
    setState(() {
      _likeCount++;
    });
    _loadNewCat();
  }

  void _onDislike() {
    _loadNewCat();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Лайков: $_likeCount',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : _errorMessage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Не удалось загрузить котика'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _loadNewCat,
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_currentCat != null) ...[
                        Text(
                          _currentCat!.breed?.name ?? 'Милый котик',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            if (_currentCat != null &&
                                _currentCat!.breed != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsScreen(
                                    breed: _currentCat!.breed!,
                                    imageUrl: _currentCat!.url,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Для этого котика нет подробного описания',
                                  ),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            height: 400,
                            width: 300,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),

                              elevation: 5,
                              child: CachedNetworkImage(
                                imageUrl: _currentCat!.url,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: IconButton(
                              iconSize: 40,
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: _onDislike,
                            ),
                          ),
                          const SizedBox(width: 50),

                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                            child: IconButton(
                              iconSize: 40,
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.green,
                              ),
                              onPressed: _onLike,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
