import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada_admin/core/utils/compress_image.dart';
import 'package:edicion_limitada_admin/features/product/product_model/product_model.dart';

class ProductService{
  final firestore = FirebaseFirestore.instance;

  //!Product add to firebase
  Future<void> addProduct(ProductModel productModel)async{
    try{
      final docRef = firestore.collection('product').doc();

      final productWithId = productModel.copyWith(id: docRef.id);

      await docRef.set(productWithId.toMap());
    }catch(e){
      throw 'Failed to add Product: $e';
    }
  }

  //!add image to firebase
 
  Future<void> addProductWithImages(ProductModel productModel, List<String> imagePaths) async {
    try {
      List<String> compressedImages = [];
      
      // Compress all images
      for (String imagePath in imagePaths) {
        final compressedImageBase64 = await compressImage(imagePath);
        compressedImages.add(compressedImageBase64);
      }
      
      // Create updated model with compressed images
      final updatedModel = productModel.copyWith(imageUrls: compressedImages);
      
      // Add to firebase
      await addProduct(updatedModel);
    } catch (e) {
      throw 'Failed to add product with images: $e';
    }
  }

  //!Fetch Product fromFirebase
  Future<List<ProductModel>> fetchProducts() async {
    try {
      final QuerySnapshot fetchProduct = await firestore.collection('product').get();
      
      return fetchProduct.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Ensure imageUrls is properly converted to List<String>
         if (data['imageUrls'] != null) {
          if (data['imageUrls'] is String) {
            // If it's a single string, convert to list
            data['imageUrls'] = [data['imageUrls']];
          } else if (data['imageUrls'] is List) {
            // If it's already a list, ensure all elements are strings
            data['imageUrls'] = List<String>.from(data['imageUrls']);
          }
        } else {
          data['imageUrls'] = <String>[];
        }
        return ProductModel.fromMap(data);
      }).toList();
    } catch (e) {
      throw 'Failed to fetch Products: $e';
    }
  }


  //!update Product
  Future<void> updateProduct(String productId, ProductModel product)async{
    try{
      await firestore.collection('product').doc(productId).update({
        'name' : product.name,
        'brand' : product.brand,
        'description' : product.description,
        'ram' : product.ram,
        'rom' : product.rom,
        'offer' : product.offer,
        'processor' : product.processor,
        'stock' : product.stock,
        'price' : product.price,
        'imageUrls' : product.imageUrls,
      });
    }catch(e){
      throw Exception('Failed to Update Product $e');
    }
  }


  //!Delte product
  Future<void> deleteProduct(String productId) async{
    try{
     await firestore.collection('product').doc(productId).delete();
    }catch(e){
      throw 'Failed to delete product $e';
    }
  }
}
