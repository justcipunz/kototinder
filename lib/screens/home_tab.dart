import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/cat_service.dart';
import '../models/cat_model.dart';
import '../utils/error_handler.dart';
import 'details_screen.dart';

class HomeTab extends StatefulWidget {
  final Function(CatModel) onLike;

  const HomeTab({super.key, required this.onLike});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final CatService _catService = CatService();
  final AppinioSwiperController _swiperController = AppinioSwiperController();

  List<CatModel> _cats = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialCats();
  }

  Future<void> _loadInitialCats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newCats = await _catService.getCatBatch();
      if (mounted) {
        setState(() {
          _cats = newCats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = ErrorHandler.getErrorMessage(e);
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreCats() async {
    try {
      final newCats = await _catService.getCatBatch();
      if (mounted) {
        setState(() {
          _cats.addAll(newCats);
        });
      }
    } catch (_) {}
  }

  void _onSwipeEnd(
    int previousIndex,
    int targetIndex,
    SwiperActivity activity,
  ) {
    if (activity is Swipe) {
      if (activity.direction == AxisDirection.right) {
        if (previousIndex < _cats.length) {
          widget.onLike(_cats[previousIndex]);
        }
      }

      if (targetIndex >= _cats.length - 2) {
        _loadMoreCats();
      }
    }
  }

  void _onEnd() {
    _loadMoreCats();
  }

  void _onLikeButton() {
    _swiperController.swipeRight();
  }

  void _onDislikeButton() {
    _swiperController.swipeLeft();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Упс!', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadInitialCats,
                icon: const Icon(Icons.refresh),
                label: const Text('Попробовать снова'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_cats.isEmpty) {
      return const Center(child: Text('Котики закончились :('));
    }

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Kototinder',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
                fontFamily: 'Nunito',
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AppinioSwiper(
                controller: _swiperController,
                cardCount: _cats.length,
                onSwipeEnd: _onSwipeEnd,
                onEnd: _onEnd,
                swipeOptions: const SwipeOptions.only(left: true, right: true),
                backgroundCardScale: 0.9,
                cardBuilder: (context, index) {
                  final cat = _cats[index];
                  return GestureDetector(
                    onTap: () {
                      if (cat.breed != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(
                              breed: cat.breed!,
                              imageUrl: cat.url,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: cat.url,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  40,
                                  16,
                                  16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cat.breed?.name ?? 'Милый котик',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (cat.breed != null)
                                      Text(
                                        cat.breed!.origin,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(
                icon: Icons.close,
                color: Colors.red,
                onPressed: _onDislikeButton,
              ),
              const SizedBox(width: 32),
              _buildActionButton(
                icon: Icons.favorite,
                color: Colors.green,
                onPressed: _onLikeButton,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color),
        iconSize: 32,
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
