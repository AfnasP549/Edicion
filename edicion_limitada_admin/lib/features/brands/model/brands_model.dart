// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BrandsModel {
  String? id;
  String name;
  String description;
  String imageUrl;
  BrandsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });


  BrandsModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
  }) {
    return BrandsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory BrandsModel.fromMap(Map<String, dynamic> map, [String? id]) {
    return BrandsModel(
      id: id,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BrandsModel.fromJson(String source) => BrandsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BrandsModel(id: $id, name: $name, description: $description, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant BrandsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      imageUrl.hashCode;
  }
}
