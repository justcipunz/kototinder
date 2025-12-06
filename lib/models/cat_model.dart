class Breed {
  final String id;
  final String name;
  final String description;
  final String temperament;

  Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Неизвестная порода',
      description: json['description'] ?? 'Описание отсутствует',
      temperament: json['temperament'] ?? '',
    );
  }
}

class CatModel {
  final String id;
  final String url;
  final Breed? breed;

  CatModel({required this.id, required this.url, this.breed});

  factory CatModel.fromJson(Map<String, dynamic> json) {
    Breed? extractedBreed;

    if (json['breeds'] != null && (json['breeds'] as List).isNotEmpty) {
      extractedBreed = Breed.fromJson(json['breeds'][0]);
    }

    return CatModel(id: json['id'], url: json['url'], breed: extractedBreed);
  }
}
