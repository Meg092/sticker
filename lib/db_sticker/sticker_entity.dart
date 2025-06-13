import 'dart:typed_data';

class StickerEntity {
  final int id;
  final DateTime createdTime;
  final Uint8List image;

  StickerEntity({
    required this.id,
    required this.createdTime,
    required this.image,
  });

  factory StickerEntity.fromJson(Map<String, dynamic> json) {
    return StickerEntity(
      id: json['id'],
      createdTime: DateTime.parse(json['createdTime']),
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdTime': createdTime.toIso8601String(),
      'image': image,
    };
  }
}