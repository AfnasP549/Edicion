  // ignore_for_file: public_member_api_docs, sort_constructors_first
  part of 'product_bloc.dart';

  sealed class ProductEvent extends Equatable {
    const ProductEvent();

    @override
    List<Object> get props => [];

  }

  class LoadProductEvent extends ProductEvent{}

  class AddProductEvent extends ProductEvent {
    final ProductModel productModel;
    final List<String> imagePaths;

    const AddProductEvent({
      required this.productModel,
      required this.imagePaths,
    });
    @override
    List<Object> get props => [productModel];
  }

  class PickImageProductEvent extends ProductEvent{
    @override
    List<Object> get props => [];
  }


  class FetchProductEvent extends ProductEvent{
    @override
    List<Object> get props =>[];
  }

  class UpdateProductEvent extends ProductEvent {
    final String productId;
    final ProductModel product;

    const UpdateProductEvent({
      required this.productId,
      required this.product,
    });
    @override
    List<Object> get props => [productId, product];
  }

  class LoadProductDetailEvent extends ProductEvent {
    final ProductModel product;
    
    const LoadProductDetailEvent({required this.product});
    
    @override
    List<Object> get props => [product];
  }

  class DeleteProductEvent extends ProductEvent{
    final String id;
    final String productName;

    const DeleteProductEvent({required this.id, required this.productName});
  }

  class AddProductImageEvent extends ProductEvent{
    final String imagePath;
    final String productId;

  const AddProductImageEvent({required this.imagePath, required this.productId});

  @override
  List<Object> get props => [imagePath, productId];
  }

  class RemoveProductImageEvent extends ProductEvent{
    final int imageIndex;
    final String productId;

  const RemoveProductImageEvent({required this.imageIndex, required this.productId});

   @override
  List<Object> get props => [imageIndex, productId];
  }






