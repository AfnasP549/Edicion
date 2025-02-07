part of 'ads_bloc.dart';

sealed class AdsEvent extends Equatable {
  const AdsEvent();

  @override
  List<Object> get props => [];
}


class PickImageAdsEvent extends AdsEvent{}

class AddAdsEvent extends AdsEvent{
  final AdsModel ads;
  final String imagePath;

  const AddAdsEvent({required this.ads, required this.imagePath});
}

class FetchAdsEvent extends AdsEvent{

}


class UpdateAdsEvent extends AdsEvent{
  final AdsModel adsModel;
  final String id;

  const UpdateAdsEvent({required this.adsModel, required this.id});
  
}

class DeleteAdsEvent extends AdsEvent{
  final String id;

  const DeleteAdsEvent({required this.id});
}