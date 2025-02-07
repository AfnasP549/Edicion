part of 'brands_bloc.dart';

@immutable
sealed class BrandsEvent {}

class PickImageBrandsEvent extends BrandsEvent{}

class AddBrandsEvent extends BrandsEvent {
  final BrandsModel brandsModel;
  final String imagePath;

  AddBrandsEvent({
    required this.brandsModel,
    required this.imagePath,
  });
}

class FetchBrandsEvent extends BrandsEvent{}

class UpdateBrandsEvent extends BrandsEvent{
  final BrandsModel updatedBrand;
  final String id;

  UpdateBrandsEvent({required this.updatedBrand, required this.id});
}

class DeleteBrandsEvent extends BrandsEvent{
  final String id;
  final String brandsname;

  DeleteBrandsEvent({required this.id, required this.brandsname});
}


