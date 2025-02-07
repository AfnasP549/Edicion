import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/core/widget/custom_textformfield.dart';
import 'package:edicion_limitada_admin/features/brands/bloc/brands_bloc.dart';
import 'package:edicion_limitada_admin/features/product/bloc/product_bloc.dart';
import 'package:edicion_limitada_admin/features/product/product_model/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ramController = TextEditingController();
  final _romController = TextEditingController();
  final _offerController = TextEditingController();
  final _processorController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();
  String? selectedBrand;
  List<String>? _imagePaths;
  List<String>? _imageBases;

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _ramController.dispose();
    _romController.dispose();
    _offerController.dispose();
    _processorController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<BrandsBloc>().add(FetchBrandsEvent());
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductAddSuccessState) {
          context.read<ProductBloc>().add(FetchProductEvent());
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
          Navigator.pop(context, true);
        } else if (state is ProductErrorState) {
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
        } else if (state is ProductImageLoadedState) {
          _imagePaths = state.imagePaths;
          _imageBases = state.imageBases;
        }
      },
      builder: (context, state) {
        if (state is ProductLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: const CustomAppbar(title: 'ADD PRODUCT'),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputLabel('Product Name', true),
                    CustomTextFormField(
                      controller: _productNameController,
                      hint: 'Enter Product Name',
                      validator: (value) =>
                          _validateNotEmpty(value, 'Product Name'),
                    ),
                    const SizedBox(height: 16),
                    buildInputLabel('Brand', true),
                    buildDropdownField(),
                    const SizedBox(height: 16),
                    buildImagesSection(),
                    const SizedBox(height: 16),
                    buildInputLabel('Product Description', true),
                    CustomTextFormField(
                      controller: _descriptionController,
                      hint: 'Add Description Here...',
                      maxLines: 4,
                      validator: (value) =>
                          _validateNotEmpty(value, 'Description'),
                    ),
                    const SizedBox(height: 16),
                    buildSpecificationsSection(),
                    const SizedBox(height: 24),
                    buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

//!image
  Widget buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputLabel('Product Images', true),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: GestureDetector(
            onTap: () {
              context.read<ProductBloc>().add(PickImageProductEvent());
            },
            child: _imagePaths != null && _imagePaths!.isNotEmpty
                ? buildImageList()
                : buildAddImagePlaceholder(),
          ),
        ),
        if (_imagePaths != null && _imagePaths!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${_imagePaths!.length} images selected',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Widget buildImageList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _imagePaths!.length + 1,
      itemBuilder: (context, index) {
        if (index == _imagePaths!.length) {
          return buildAddMoreImagesButton();
        }
        return buildImageTile(index);
      },
    );
  }

  Widget buildImageTile(int index) {
    return Stack(
      children: [
        Container(
          width: 150,
          margin: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(_imagePaths![index]),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              setState(() {
                _imagePaths!.removeAt(index);
                _imageBases!.removeAt(index);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildAddMoreImagesButton() {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: const Icon(Icons.add_a_photo, size: 50),
    );
  }

  Widget buildAddImagePlaceholder() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, size: 50),
          SizedBox(height: 8),
          Text('Tap to add images'),
        ],
      ),
    );
  }

  // customized custom textform fueld

  Widget buildSpecificationsSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildSpecificationField(
                  'RAM',
                  _ramController,
                  'in GB',
                  (value) => _validateNumber(value, 'RAM'),
                  TextInputType.number),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildSpecificationField(
                  'ROM',
                  _romController,
                  'in GB',
                  (value) => _validateNumber(value, 'ROM'),
                  TextInputType.number),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildSpecificationField(
                  'Offer',
                  _offerController,
                  'in percentage',
                  (value) => _validateNumber(value, 'Offer'),
                  TextInputType.number),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildSpecificationField(
                'Processor',
                _processorController,
                'Processor Name',
                (value) => _validateNotEmpty(value, 'Processor'),
                TextInputType.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: buildSpecificationField(
                'Stock',
                _stockController,
                'Enter Stock count',
                (value) => _validateNumber(value, 'Stock'),
                TextInputType.number
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: buildSpecificationField(
                'Price',
                _priceController,
                'Product Price',
                (value) => _validateNumber(value, 'Price'),
                TextInputType.number
              ),
            ),
          ],
        ),
      ],
    );
  }

  //here the passing parameters for customized custom textform field

  Widget buildSpecificationField(
    String label,
    TextEditingController controller,
    String hint,
    String? Function(String?) validator,
    TextInputType keyboardType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildInputLabel(label, true),
        CustomTextFormField(
          controller: controller,
          hint: hint,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.grey[200],
            ),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
            ),
            child: const Text('ADD'),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField() {
    return BlocBuilder<BrandsBloc, BrandsState>(
      builder: (context, state) {
        if (state is FetchBrandsSuccessState) {
          final brands = state.brands;
          if (selectedBrand != null &&
              !brands.any((brand) => brand.name == selectedBrand)) {
            selectedBrand = null;
          }
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: InputBorder.none,
              ),
              hint: Text(
                'Choose the Brand',
                style: TextStyle(color: Colors.grey[400]),
              ),
              value: selectedBrand,
              items: brands.map((brand) {
                return DropdownMenuItem(
                  value: brand.name,
                  child: Text(brand.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBrand = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a brand';
                }
                return null;
              },
            ),
          );
        }
        if (state is BrandsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BrandsError) {
          return Center(child: Text(state.error));
        }
        return const SizedBox();
      },
    );
  }

  Widget buildInputLabel(String label, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? _validateNumber(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  if (fieldName == 'Stock') {
    if (int.tryParse(value) == null) {
      return '$fieldName must be an integer value';
    }
  } else {
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }
  }
  return null;
}


  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imagePaths == null || _imagePaths!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one image')),
        );
        return;
      }

      try {
        final productModel = ProductModel(
          id: '',
          name: _productNameController.text.trim(),
          brand: selectedBrand!,
          imageUrls: _imageBases!,
          description: _descriptionController.text.trim(),
          ram: int.parse(_ramController.text.trim()),
          rom: int.parse(_romController.text.trim()),
          offer: double.parse(_offerController.text.trim()),
          processor: _processorController.text.trim(),
          stock: int.parse(_stockController.text.trim()),
          price: double.parse(_priceController.text.trim()),
        );

        context.read<ProductBloc>().add(
              AddProductEvent(
                productModel: productModel,
                imagePaths: _imagePaths!,
              ),
            );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
