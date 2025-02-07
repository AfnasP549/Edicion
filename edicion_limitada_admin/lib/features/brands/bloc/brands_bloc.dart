import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:edicion_limitada_admin/features/brands/model/brands_model.dart';
import 'package:edicion_limitada_admin/features/brands/service/brands_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'brands_event.dart';
part 'brands_state.dart';

class BrandsBloc extends Bloc<BrandsEvent, BrandsState> {
  BrandsBloc() : super(BrandsInitial()) {

    
//!image
    on<PickImageBrandsEvent>((event, emit) async {
  try {
    emit(BrandsLoading());
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    
    // Ensure the file is picked before proceeding
    if (pickedFile != null) {
      final unit = await pickedFile.readAsBytes();
      final base = base64Encode(unit);
      emit(ImageLoadedBrandsState(
        imageBase: base,
        imagePath: pickedFile.path,
      ));
    } else {
      emit(BrandsError(error: 'No image selected.'));
    }
  } catch (e) {
    emit(BrandsError(error: 'Error: ${e.toString()}'));
  }
});

    //!add Brands
  on<AddBrandsEvent>((event, emit) async {
      try {
        emit(BrandsLoading());
        await BrandsService().addBrandWithImage(
          event.brandsModel,
          event.imagePath,
        );
        emit(AddedBrandsState(message: 'Brand Added Successfully'));
      } catch (e) {
        emit(BrandsError(error: 'Error: ${e.toString()}'));
      }
    });

//!Fetch Brands
  on<FetchBrandsEvent>((event, emit) async {
      try {
        emit(BrandsLoading());
        final brands = await BrandsService().fetchBrands();
        emit(FetchBrandsSuccessState(brands: brands));
      } catch (e) {
        emit(BrandsError(error: e.toString()));
      }
    });


//!Update
   
// Add this to your BrandsBloc class
String? getImagePathFromState() {
  if (state is ImageLoadedBrandsState) {
    return (state as ImageLoadedBrandsState).imagePath;
  }
  return null;
}

on<UpdateBrandsEvent>((event, emit) async {
  try {
    emit(BrandsLoading());
    await BrandsService().editBrand(
      event.id,
      event.updatedBrand,
      getImagePathFromState(), // You'll need to track the current image path in the bloc
    );
    emit(UpdateBrandsSuccessState(message: 'Brand Updated Successfully'));
  } catch (e) {
    emit(BrandsError(error: e.toString()));
  }
});

//!delete
on<DeleteBrandsEvent>((event, emit)async{
  try{
    emit(BrandsLoading());
    await BrandsService().deleteBrands(event.id);

    emit(DeleteBrandsSuccessState(message: '${event.brandsname} deleted SuccessFully'));
  }catch(e){
    emit(BrandsError(error: e.toString()));
  }

});

  }
}
