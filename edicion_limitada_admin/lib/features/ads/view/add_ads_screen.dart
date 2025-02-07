// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/features/ads/bloc/ads_bloc.dart';
import 'package:edicion_limitada_admin/features/ads/model/ads_model.dart';
import 'package:edicion_limitada_admin/features/ads/view/ads_screen.dart';

class AddAdsScreen extends StatelessWidget {
  AddAdsScreen({super.key});

  String? _imageFile;
  String? base;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is AddAdsState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.message)),
                ],
              ),
            ),
          );
          _clearFormAndNavigate(context);
          Navigator.pop(context);
          customNavigator(context, const AdsScreen());
          context.read<AdsBloc>().add(FetchAdsEvent());
        } else if (state is AdsErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error, color: AppColors.error),
                  const SizedBox(width: 10),
                  Expanded(child: Text(state.error)),
                ],
              ),
            ),
          ); 
        } else if (state is ImageLoadedAdsState) {
          _imageFile = state.imagePath;
          base = state.imageBase;
        }
      },
      builder: (context, state) {
        if (state is AdsLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: const CustomAppbar(title: 'Add Ads'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<AdsBloc>().add(PickImageAdsEvent());
                    },
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_imageFile!),
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Icon(Icons.add_a_photo, size: 50),
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleSubmit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                    child: const Text('Add Ads'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSubmit(BuildContext context) {
    if (base == null) {
      _showError(context, 'Please select an image');
      return;
    }
    
    final adModel = AdsModel(
      id: null,
      imageUrl: base!,
    );

    context.read<AdsBloc>().add(AddAdsEvent(
          ads: adModel,
          imagePath: _imageFile!,
        ));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearFormAndNavigate(BuildContext context) {
    _imageFile = null;
    base = null;
    Navigator.pop(context);
  }
}