// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/features/ads/bloc/ads_bloc.dart';
import 'package:edicion_limitada_admin/features/ads/model/ads_model.dart';

class EditAdsScreen extends StatelessWidget {
  final AdsModel ad;

  EditAdsScreen({super.key, required this.ad});

  String? _imageFile;
  String? base;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is UpdateAdsSuccessState) {
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
          Navigator.pop(context);
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
          appBar: const CustomAppbar(title: 'Edit Ad'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImagePicker(context),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleSubmit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                    child: const Text('Update Ad'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Image picker widget
  Widget _buildImagePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<AdsBloc>().add(PickImageAdsEvent()),
      child: _imageFile != null
          ? _buildImageFileWidget()
          : _buildImageFromMemoryWidget(),
    );
  }

  Widget _buildImageFileWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(_imageFile!),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageFromMemoryWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        base64Decode(ad.imageUrl),
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 150,
            width: 250,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          );
        },
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    final updatedAd = AdsModel(
      id: ad.id,
      imageUrl: base ?? ad.imageUrl,
    );

    context.read<AdsBloc>().add(UpdateAdsEvent(
      adsModel: updatedAd,
      id: ad.id!,
    ));
  }
}