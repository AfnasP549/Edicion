// ignore_for_file: unnecessary_import

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:edicion_limitada_admin/features/ads/model/ads_model.dart';
import 'package:edicion_limitada_admin/features/ads/service/ads_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final AdsService _adsService;
  AdsBloc(this._adsService) : super(AdsInitial()) {
    //!image
    on<PickImageAdsEvent>((event, emit) async {
      try {
        emit(AdsLoadingState());
        final XFile? pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        // Ensure the file is picked before proceeding
        if (pickedFile != null) {
          final unit = await pickedFile.readAsBytes();
          final base = base64Encode(unit);
          emit(
              ImageLoadedAdsState(imageBase: base, imagePath: pickedFile.path));
        } else {
          emit(const AdsErrorState('No image Selected'));
        }
      } catch (e) {
        emit(AdsErrorState('Error: ${'Failed to pickimage${e.toString()}'}'));
      }
    });

   //!add
    on<AddAdsEvent>((event, emit) async {
      try {
        emit(AdsLoadingState());
        await _adsService.addAdsImage(event.ads, event.imagePath);
        emit(const AddAdsState('Ads Added Successfully'));
      } catch (e) {
        emit(AdsErrorState('error: ${'Failed to Add ads${e.toString()}'}'));
      }
    });

    //!fetch
    on<FetchAdsEvent>((event, emit) async {
      try {
        emit(AdsLoadingState());
        final ads = await _adsService.fetchAds();
        emit(FetchAdsSuccessState(ads: ads));
      } catch (e) {
        emit(AdsErrorState('fetching error ${'${e.toString}'}'));
      }
    });

    //!update
    String? getImagePathFromState() {
      if (state is ImageLoadedAdsState) {
        return (state as ImageLoadedAdsState).imagePath;
      }
      return null;
    }

    on<UpdateAdsEvent>((event, emit)async{
      try{
        emit(AdsLoadingState());
        await _adsService.editAds(event.id, event.adsModel,  getImagePathFromState());
        emit(const UpdateAdsSuccessState(message: 'Ads updated Successfully'));
      }catch(e){
        throw Exception('Failed to update ads${e.toString()}');
      }
    });


    //!delet
   on<DeleteAdsEvent>((event, emit) async {
  try {
    emit(AdsLoadingState());
    await _adsService.deleteAds(event.id);
    emit(const DeleteAdsSuccessState(message: 'Ads Deleted successfully'));
  } catch (e) {
    emit(AdsErrorState('Failed to delete ads: ${e.toString()}'));
  }
});



  }
}
