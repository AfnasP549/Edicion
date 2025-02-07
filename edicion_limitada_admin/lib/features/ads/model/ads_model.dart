// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AdsModel {
  String? id;
  String imageUrl;
  AdsModel({
    required this.id,
    required this.imageUrl,
  });

  AdsModel copyWith({
    String? id,
    String? imageUrl,
  }) {
    return AdsModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imageUrl': imageUrl,
    };
  }

  factory AdsModel.fromMap(Map<String, dynamic> map,  [String? id]) {
    return AdsModel(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdsModel.fromJson(String source) => AdsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AdsModel(id: $id, imageUrl: $imageUrl)';

  @override
  bool operator ==(covariant AdsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ imageUrl.hashCode;
}
