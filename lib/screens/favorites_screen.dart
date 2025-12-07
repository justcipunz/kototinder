import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat_model.dart';
import 'details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<CatModel> likedCats;
  final Function(CatModel) onRemove;

  const FavoritesScreen({
    super.key,
    required this.likedCats,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (likedCats.isEmpty) {
      return const Center(child: Text('Вы пока никого не лайкнули'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Любимые котики')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: likedCats.length,
        itemBuilder: (context, index) {
          final cat = likedCats[index];
          return GestureDetector(
            onTap: () {
              if (cat.breed != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailsScreen(breed: cat.breed!, imageUrl: cat.url),
                  ),
                );
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: cat.url,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onRemove(cat),
                    ),
                  ),
                ),
                if (cat.breed != null)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        cat.breed!.name,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
