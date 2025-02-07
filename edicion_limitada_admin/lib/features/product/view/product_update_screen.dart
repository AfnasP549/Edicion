// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:edicion_limitada_admin/core/utils/compress_image.dart';
import 'package:edicion_limitada_admin/core/widget/custom_textformfield.dart';
import 'package:edicion_limitada_admin/features/product/bloc/product_bloc.dart';
import 'package:edicion_limitada_admin/features/product/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProductUpdateScreen extends StatelessWidget {
  final ProductModel product;
  final String productId;

  ProductUpdateScreen({
    super.key,
    required this.product,
    required this.productId,
  }) {
    // Initialize controllers with product data
    _nameController = TextEditingController(text: product.name);
    _brandController = TextEditingController(text: product.brand);
    _descriptionController = TextEditingController(text: product.description);
    _ramController = TextEditingController(text: product.ram.toString());
    _romController = TextEditingController(text: product.rom.toString());
    _offerController = TextEditingController(text: product.offer.toString());
    _processorController = TextEditingController(text: product.processor);
    _stockController = TextEditingController(text: product.stock.toString());
    _priceController = TextEditingController(text: product.price.toString());
    _imagesNotifier = ValueNotifier<List<String>>(List.from(product.imageUrls));
  }

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _ramController;
  late final TextEditingController _romController;
  late final TextEditingController _offerController;
  late final TextEditingController _processorController;
  late final TextEditingController _stockController;
  late final TextEditingController _priceController;
  late final ValueNotifier<List<String>> _imagesNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Product')),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductUpdateSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product updated successfully')),
            );
            Navigator.pop(context);
            context.read<ProductBloc>().add(FetchProductEvent());
          } else if (state is ProductErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImageSection(context),
                  const SizedBox(height: 16),
                  _buildFormFields(),
                  const SizedBox(height: 24),
                  if (state is! ProductLoadingState)
                    _buildUpdateButton(context)
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<List<String>>(
          valueListenable: _imagesNotifier,
          builder: (context, images, _) {
            if (images.isEmpty) return const SizedBox.shrink();

            return CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: false,
              ),
              items: List.generate(images.length, (index) {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(
                              base64Decode(images[index]),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white, size: 18),
                              onPressed: () {
                                final newImages = List<String>.from(images);
                                newImages.removeAt(index);
                                _imagesNotifier.value = newImages;
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () => _addImage(context),
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Image'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
         //!product
        CustomTextFormField(
          controller: _nameController,
          hint: 'Product Name',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter product name' : null,
        ),

        const SizedBox(height: 10),
         //!brand

        CustomTextFormField(
          controller: _brandController,
          hint: 'Brand',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter product brand' : null,
        ),
       
        const SizedBox(height: 10),
         //!des

        CustomTextFormField(
          controller: _descriptionController,
          hint: 'Product Description',
          validator: (value) => value?.isEmpty ?? true
              ? 'Please enter product description'
              : null,
        ),
      

        const SizedBox(height: 10),
        //!ram
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: _ramController,
                hint: 'Ram',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter Ram' : null,
              ),

          
            ),
            const SizedBox(width: 16),
            //!rom
            Expanded(
              child: CustomTextFormField(
                controller: _romController,
                hint: 'Rom',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter Rom' : null,
              ),

            ),
          ],
        ),

        const SizedBox(height: 10),
//! processor
        CustomTextFormField(
          controller: _processorController,
          hint: 'Processor',
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter processor' : null,
        ),

        const SizedBox(height: 10),
        //!price and offer
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: _priceController,
                hint: 'Price',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter Price' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextFormField(
                controller: _offerController,
                hint: 'Offer (%)',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter offer' : null,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        CustomTextFormField(
          controller: _stockController,
          hint: 'Stock',
          keyboardType: TextInputType.number,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter stock' : null,
        ),
      ],
    );
  }

  Future<void> _addImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final compressedImage = await compressImage(image.path);
        final currentImages = List<String>.from(_imagesNotifier.value);
        currentImages.add(compressedImage);
        _imagesNotifier.value = currentImages;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add image: $e')),
      );
    }
  }

  Widget _buildUpdateButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          final updatedProduct = ProductModel(
            id: product.id,
            name: _nameController.text,
            brand: _brandController.text,
            imageUrls: _imagesNotifier.value,
            description: _descriptionController.text,
            ram: int.parse(_ramController.text),
            rom: int.parse(_romController.text),
            offer: double.parse(_offerController.text),
            processor: _processorController.text,
            stock: int.parse(_stockController.text),
            price: double.parse(_priceController.text),
          );

          context.read<ProductBloc>().add(
                UpdateProductEvent(
                  productId: productId,
                  product: updatedProduct,
                ),
              );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('Update Product'),
    );
  }
}
