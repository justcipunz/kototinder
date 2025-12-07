import 'package:flutter/widgets.dart';

class Breed {
  final String id;
  final String name;
  final String description;
  final String temperament;
  final String origin;
  final String lifeSpan;
  final String weightMetric;
  final String? imageUrl;

  Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    required this.weightMetric,
    this.imageUrl,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    String weight = 'Unknown';
    if (json['weight'] != null && json['weight'] is Map) {
      weight = json['weight']['metric'] ?? 'Unknown';
    }

    String? imgUrl;
    if (json['image'] != null && json['image']['url'] != null) {
      imgUrl = json['image']['url'];
    }

    return Breed(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Неизвестная порода',
      description: json['description'] ?? 'Описание отсутствует',
      temperament: json['temperament'] ?? 'Характер не указан',
      origin: json['origin'] ?? 'Неизвестно',
      lifeSpan: json['life_span'] ?? '?',
      weightMetric: weight,
      imageUrl: imgUrl,
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

    if (json['breeds'] != null &&
        json['breeds'] is List &&
        (json['breeds'] as List).isNotEmpty) {
      try {
        extractedBreed = Breed.fromJson(json['breeds'][0]);
      } catch (e) {
        debugPrint("Ошибка парсинга породы: $e");
      }
    }

    return CatModel(
      id: json['id'] ?? 'unknown_id',
      url: json['url'] ?? '',
      breed: extractedBreed,
    );
  }
}
