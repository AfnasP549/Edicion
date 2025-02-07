// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();
  
  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoadingState extends ProductState{}



class ProductErrorState extends ProductState{
  final String error;

  const ProductErrorState({required this.error});
}

class ProductAddSuccessState extends ProductState{
  final String message;

  const ProductAddSuccessState({required this.message});
}

class ProductImageLoadedState extends ProductState {
    final List<String> imagePaths;
  final List<String> imageBases;

  const ProductImageLoadedState({
    required this.imagePaths,
    required this.imageBases,
  });


  @override
  List<Object> get props => [imagePaths, imageBases];

}


class ProductFetchSuccesState extends ProductState{
  final List<ProductModel> products;

  const ProductFetchSuccesState({required this.products});

  
  @override
  List<Object> get props => [products];
}

class ProductUpdateSuccessState extends ProductState{}

class ProductDetailState extends ProductState {
  final ProductModel product;
  
  const ProductDetailState({required this.product});
  
  @override
  List<Object> get props => [product];
}

class DeleteProductSuccessState extends ProductState{
  final String message;

  DeleteProductSuccessState({required this.message});
}

class ProductImageUpdateState extends ProductState{
  final List<String> imageUrls;

  const ProductImageUpdateState({required this.imageUrls});

  @override
  List<Object> get props => [imageUrls];
}
