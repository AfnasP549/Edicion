part of 'ads_bloc.dart';

sealed class AdsState extends Equatable {
  const AdsState();
  
  @override
  List<Object> get props => [];
}

final class AdsInitial extends AdsState {}

class AdsLoadingState extends AdsState{}

class AdsErrorState extends AdsState{
  final String error;

  const AdsErrorState(this.error);
}


class ImageLoadedAdsState extends AdsState{
  final String imagePath;
  final String imageBase;

  const ImageLoadedAdsState({required this.imagePath, required this.imageBase});

 
}

class AddAdsState extends AdsState{
  final String message;

  const AddAdsState(this.message);
}

class FetchAdsSuccessState extends AdsState{
  final List<AdsModel> ads;

  const FetchAdsSuccessState({required this.ads});
}


class UpdateAdsSuccessState extends AdsState{
  final String message;

  const UpdateAdsSuccessState({required this.message});
} 


class DeleteAdsSuccessState extends AdsState{
  final String message;

  const DeleteAdsSuccessState({required this.message});
   @override
  List<Object> get props => [message];
}


