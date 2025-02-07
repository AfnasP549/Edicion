// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/core/widget/custom_textformfield.dart';
import 'package:edicion_limitada_admin/features/brands/bloc/brands_bloc.dart';
import 'package:edicion_limitada_admin/features/brands/model/brands_model.dart';
import 'package:edicion_limitada_admin/features/brands/view/brands_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBrandsScreen extends StatelessWidget {
  AddBrandsScreen({super.key});

  final _brandController = TextEditingController();
  final _desController = TextEditingController();

  String? _imageFile;
  String? base;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrandsBloc, BrandsState>(
      listener: (context, state) {
        if (state is AddedBrandsState) {
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
          customNavigator(context, const BrandsScreen());
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
          appBar: const CustomAppbar(title: 'Add Brands'),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.read<BrandsBloc>().add(PickImageBrandsEvent());
                    },
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_imageFile!),
                              height: 150,
                              width: 250,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 150,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Icon(Icons.add_a_photo, size: 50),
                          ),
                  ),
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
                    child: const Text('Add Brand'),
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
    if (_brandController.text.isEmpty) {
      _showError(context, 'Please enter brand name');
      return;
    }
    if (_desController.text.isEmpty) {
      _showError(context, 'Please enter brand description');
      return;
    }
    if (base == null) {
      _showError(context, 'Please select an image');
      return;
    }
    

    final brandModel = BrandsModel(
      id: null,
      name: _brandController.text.trim(),
      description: _desController.text.trim(),
      imageUrl: base!,
    );

    context.read<BrandsBloc>().add(AddBrandsEvent(
          brandsModel: brandModel,
          imagePath: _imageFile!,
        ));
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _clearFormAndNavigate(BuildContext context) {
    _brandController.clear();
    _desController.clear();
    _imageFile = null;
    base = null;
    Navigator.pop(context);
  }
}
