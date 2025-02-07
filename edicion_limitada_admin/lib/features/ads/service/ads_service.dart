import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada_admin/core/utils/compress_image.dart';
import 'package:edicion_limitada_admin/features/ads/model/ads_model.dart';

class AdsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addAds(AdsModel ads) async {
    try {
      final docRef = _firestore.collection('ads').doc();
      final brandsWithId = ads.copyWith(id: docRef.id);

      await docRef.set(brandsWithId.toMap());
    } catch (e) {
      throw Exception('Failed to add Ads: $e');
    }
  }

  Future<void> addAdsImage(AdsModel ads, String imagePath) async {
    try {
      final compressedImage = await compressImage(imagePath);
      final updateModel = ads.copyWith(imageUrl: compressedImage);

      await addAds(updateModel);
    } catch (e) {
      throw Exception('Failed to add ads image: $e');
    }
  }

  Future<List<AdsModel>> fetchAds() async {
    try {
      final fetch = await _firestore.collection('ads').get();
      return fetch.docs.map((doc) {
        return AdsModel.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch ads : $e');
    }
  }

  Future<void> editAds(String id, AdsModel ads, String? newImagePath) async {
    try {
      final docRef = _firestore.collection('ads').doc(id);

      // If there's a new image, compress it
      if (newImagePath != null) {
        final compressedImageBase64 = await compressImage(newImagePath);
        // Update model with new compressed image
        final updatedModel = ads.copyWith(
          imageUrl: compressedImageBase64,
          id: id,
        );
        await docRef.update(updatedModel.toMap());
      } else {
        // If no new image, just update the other fields
        final updatedModel = ads.copyWith(id: id);
        await docRef.update(updatedModel.toMap());
      }
    } catch (e) {
      throw Exception('Failed to edit ads Image : $e');
    }
  }

//!delete
  Future<void> deleteAds(String id) async {
    try {
      final docRef = _firestore.collection('ads').doc(id);
      await docRef.delete();
    } catch (e) {
      throw Exception('Failed to delete Ads :$e');
    }
  }
}
