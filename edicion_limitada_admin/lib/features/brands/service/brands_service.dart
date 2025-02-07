import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada_admin/core/utils/compress_image.dart';
import 'package:edicion_limitada_admin/features/brands/model/brands_model.dart';

class BrandsService {
  final firestore = FirebaseFirestore.instance;
  //!Brands add to firebase
  Future<void> addBrands(BrandsModel brandsModel) async {
    try {
      
      final docRef = firestore.collection('brands').doc();

      //generated id to model
      final brandsWithId = brandsModel.copyWith(id: docRef.id);
      
      //then add to firebase
      await docRef.set(brandsWithId.toMap());
    } catch (e) {
      throw 'Failed to add Brand: $e';
    }
  }



//!add image to firebase
  // Helper method to add a brand with compressed image
  Future<void> addBrandWithImage(BrandsModel brandModel, String imagePath) async {
    try {
      // First compress the image
      final compressedImageBase64 = await compressImage(imagePath);
      
      // Create updated model with compressed image
      final updatedModel = brandModel.copyWith(imageUrl: compressedImageBase64);
      
      // Add to firebase
      await addBrands(updatedModel);
    } catch (e) {
      throw 'Failed to add brand with image: $e';
    }


  }

  
    //!Fetch brand from firebase
    Future<List<BrandsModel>> fetchBrands() async{
      try{
        final fetchAsList = await firestore.collection('brands').get();
      return fetchAsList.docs.map((doc){
        return BrandsModel.fromMap(doc.data(), doc.id);
      }).toList();

      }catch(e){
        throw 'Failed to fetch Brand $e';
      }
    }


//!edit
Future<void> editBrand(String id, BrandsModel brandModel, String? newImagePath) async {
  try {
    final docRef = firestore.collection('brands').doc(id);
    
    // If there's a new image, compress it
    if (newImagePath != null) {
      final compressedImageBase64 = await compressImage(newImagePath);
      // Update model with new compressed image
      final updatedModel = brandModel.copyWith(
        imageUrl: compressedImageBase64,
        id: id,
      );
      await docRef.update(updatedModel.toMap());
    } else {
      // If no new image, just update the other fields
      final updatedModel = brandModel.copyWith(id: id);
      await docRef.update(updatedModel.toMap());
    }
  } catch (e) {
    throw 'Failed to edit Brand: $e';
  }
}


//!delete
Future<void> deleteBrands(String id) async{
  try{
    final docRef = firestore.collection('brands').doc(id);
     await docRef.delete();
  }catch(e){
    throw 'failed to delete Brand $e';
  }
}

}