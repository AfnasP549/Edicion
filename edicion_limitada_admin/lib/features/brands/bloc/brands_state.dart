part of 'brands_bloc.dart';

@immutable
sealed class BrandsState {}

final class BrandsInitial extends BrandsState {}

class BrandsLoading extends BrandsState{}

class BrandsError extends BrandsState{
  final String error;

  BrandsError({required this.error});
}

class ImageLoadedBrandsState extends BrandsState {
  final String imagePath;
  final String imageBase;

  ImageLoadedBrandsState({
    required this.imagePath,
    required this.imageBase,
  });
}

class AddedBrandsState extends BrandsState{
  final String message;

  AddedBrandsState({required this.message});
}

class FetchBrandsSuccessState extends BrandsState{
  final List<BrandsModel> brands;

  FetchBrandsSuccessState({required this.brands});
}

class UpdateBrandsSuccessState extends BrandsState{
  final String message;

  UpdateBrandsSuccessState({required this.message});
} 

class DeleteBrandsSuccessState extends BrandsState{
  final String message;

  DeleteBrandsSuccessState({required this.message});
}
