  import 'dart:convert';

  import 'package:bloc/bloc.dart';
import 'package:edicion_limitada_admin/core/utils/compress_image.dart';
  import 'package:edicion_limitada_admin/features/product/product_model/product_model.dart';
  import 'package:edicion_limitada_admin/features/product/service/product_service.dart.dart';
  import 'package:equatable/equatable.dart';
  import 'package:image_picker/image_picker.dart';

  part 'product_event.dart';
  part 'product_state.dart';

  class ProductBloc extends Bloc<ProductEvent, ProductState> {
    ProductBloc() : super(ProductInitial()) {

      final productService = ProductService();

      //!image
    on<PickImageProductEvent>((event, emit) async {
        try {
          emit(ProductLoadingState());
          
          final imagePicker = ImagePicker();
          final List<XFile> pickedFiles = await imagePicker.pickMultiImage();
          
          if (pickedFiles.isNotEmpty) {
            List<String> paths = [];
            List<String> bases = [];
            
            for (XFile file in pickedFiles) {
              final bytes = await file.readAsBytes();
              final base = base64Encode(bytes);
              paths.add(file.path);
              bases.add(base);
            }
            
            emit(ProductImageLoadedState(
              imagePaths: paths,
              imageBases: bases,
            ));
          } else {
            emit(const ProductErrorState(error: 'No images selected.'));
          }
        } catch (e) {
          emit(ProductErrorState(error: 'Error: ${e.toString()}'));
        }
      });
    
    
      //!add
      on<AddProductEvent>((event, emit) async{
        try{
          emit(ProductLoadingState());
          //product adding
          await productService.addProductWithImages(
            event.productModel,
            event.imagePaths

          );

          //fetch prroduct after adding
          final updateProducts = await productService.fetchProducts();

          emit(const ProductAddSuccessState(
            message: 'Product Added Successfully'
          ));
          emit(ProductFetchSuccesState(products: updateProducts));
        }catch(e){
          emit(ProductErrorState(error: 'Error: ${e.toString()}'));
        }     
      });


  //!get
      on<FetchProductEvent>((event, emit) async {
        try {
          emit(ProductLoadingState());
          
          final products = await productService.fetchProducts();
          
          emit(ProductFetchSuccesState(products: products));
        } catch (e) {
          emit(ProductErrorState(error: e.toString()));
        }
      });


      //!update
      on<UpdateProductEvent>((event, emit)async{
        try{
          emit(ProductLoadingState());
          await productService.updateProduct(event.productId, event.product);

          emit(ProductUpdateSuccessState());
        }catch(e){
          emit(ProductErrorState(error: e.toString()));
        }
      });

      on<LoadProductDetailEvent>((event, emit)async{
        try{
          emit(ProductDetailState(product: event.product));
        }catch(e){
          emit(ProductErrorState(error: e.toString()));
        }
      });



   on<DeleteProductEvent>((event, emit) async {
  try {
    emit(ProductLoadingState()); // Show loading state

    // Delete the product
    await productService.deleteProduct(event.id);

    // Fetch updated products after deletion
    final updatedProducts = await productService.fetchProducts();

    // Emit success and updated product list
    emit(ProductFetchSuccesState(products: updatedProducts));
  } catch (e) {
    emit(ProductErrorState(error: e.toString()));
  }
});




on<AddProductImageEvent>((event, emit) async {
  try {
    emit(ProductLoadingState());
    
    // Compress the new image
    final compressedImageBase64 = await compressImage(event.imagePath);
    
    // Get current product
    final products = await productService.fetchProducts();
    final currentProduct = products.firstWhere((p) => p.id == event.productId);
    
    // Add new image to the list
    final updatedImageUrls = List<String>.from(currentProduct.imageUrls)
      ..add(compressedImageBase64);
    
    // Update product with new image list
    final updatedProduct = currentProduct.copyWith(imageUrls: updatedImageUrls);
    await productService.updateProduct(event.productId, updatedProduct);
    
    emit(ProductImageUpdateState(imageUrls: updatedImageUrls));
  } catch (e) {
    emit(ProductErrorState(error: e.toString()));
  }
});

on<RemoveProductImageEvent>((event, emit) async {
  try {
    emit(ProductLoadingState());
    
    // Get current product
    final products = await productService.fetchProducts();
    final currentProduct = products.firstWhere((p) => p.id == event.productId);
    
    // Remove image from the list
    final updatedImageUrls = List<String>.from(currentProduct.imageUrls)
      ..removeAt(event.imageIndex);
    
    // Update product with new image list
    final updatedProduct = currentProduct.copyWith(imageUrls: updatedImageUrls);
    await productService.updateProduct(event.productId, updatedProduct);
    
    emit(ProductImageUpdateState(imageUrls: updatedImageUrls));
  } catch (e) {
    emit(ProductErrorState(error: e.toString()));
  }
});


    }
  }
