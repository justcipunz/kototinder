import 'package:flutter/material.dart';
import '../models/cat_model.dart';
import '../services/cat_service.dart';
import 'details_screen.dart';

class BreedsScreen extends StatefulWidget {
  const BreedsScreen({super.key});

  @override
  State<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends State<BreedsScreen> {
  final CatService _catService = CatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Породы котиков')),
      body: FutureBuilder<List<Breed>>(
        future: _catService.getBreeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Породы не найдены'));
          }

          final breeds = snapshot.data!;
          return ListView.builder(
            itemCount: breeds.length,
            itemBuilder: (context, index) {
              final breed = breeds[index];
              return ListTile(
                title: Text(breed.name),
                subtitle: Text(
                  breed.temperament,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(breed: breed),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
