// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:edicion_limitada_admin/core/widget/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/core/widget/widget.dart';
import 'package:edicion_limitada_admin/features/brands/bloc/brands_bloc.dart';
import 'package:edicion_limitada_admin/features/brands/model/brands_model.dart';

class EditBrandsScreen extends StatelessWidget {
  final BrandsModel brand;

  EditBrandsScreen({super.key, required this.brand});

  final _brandController = TextEditingController();
  final _desController = TextEditingController();

  String? _imageFile;
  String? base;

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with existing values
    _brandController.text = brand.name;
    _desController.text = brand.description;

    return BlocConsumer<BrandsBloc, BrandsState>(
      listener: (context, state) {
        if (state is UpdateBrandsSuccessState) {
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
          context.read<BrandsBloc>().add(FetchBrandsEvent());
        } else if (state is BrandsError) {
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
        } else if (state is ImageLoadedBrandsState) {
          _imageFile = state.imagePath;
          base = state.imageBase;
        }
      },
      builder: (context, state) {
        if (state is BrandsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: const CustomAppbar(title: 'Edit Brand'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImagePicker(context),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _brandController,
                    hint: 'Brand',
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _desController,
                    hint: 'Description',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleSubmit(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                    child: const Text('Update Brand'),
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
      onTap: () => context.read<BrandsBloc>().add(PickImageBrandsEvent()),
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
        height: 150,
        width: 250,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageFromMemoryWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        base64Decode(brand.imageUrl),
        height: 150,
        width: 250,
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
    if (_brandController.text.isEmpty) {
      _showError(context, 'Please enter brand name');
      return;
    }
    if (_desController.text.isEmpty) {
      _showError(context, 'Please enter brand description');
      return;
    }

    final updatedBrand = BrandsModel(
      id: brand.id,
      name: _brandController.text.trim(),
      description: _desController.text.trim(),
      imageUrl: base ?? brand.imageUrl,
    );

    context.read<BrandsBloc>().add(UpdateBrandsEvent(
      updatedBrand: updatedBrand,
      id: brand.id!,
    ));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}