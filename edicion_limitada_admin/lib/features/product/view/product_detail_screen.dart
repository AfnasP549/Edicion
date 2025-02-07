import 'dart:convert';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/features/product/bloc/product_bloc.dart';
import 'package:edicion_limitada_admin/features/product/product_model/product_model.dart';
import 'package:edicion_limitada_admin/features/product/view/product_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Product Details'),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductUpdateSuccessState) {
            context.read<ProductBloc>().add(FetchProductEvent());
          }
        },
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          // Get the current product data
          ProductModel currentProduct = product;
          if (state is ProductFetchSuccesState) {
            currentProduct = state.products.firstWhere(
              (p) => p.id == product.id,
              orElse: () => product,
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentProduct.imageUrls.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 380,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        autoPlay: true,
                      ),
                      items: currentProduct.imageUrls.map((imageUrl) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(
                                  base64Decode(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),

                  Text(
                    currentProduct.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  DetailRow(
                    label: 'Brand',
                    value: currentProduct.brand,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: DetailRow(
                          label: 'Price',
                          value: '₹${currentProduct.price.toStringAsFixed(2)}',
                        ),
                      ),
                      Expanded(
                        child: DetailRow(
                          label: 'Offer',
                          value: '${currentProduct.offer}%',
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: DetailRow(
                          label: 'RAM',
                          value: '${currentProduct.ram}GB',
                        ),
                      ),
                      Expanded(
                        child: DetailRow(
                          label: 'Storage',
                          value: '${currentProduct.rom}GB',
                        ),
                      ),
                    ],
                  ),

                  DetailRow(
                    label: 'Processor',
                    value: currentProduct.processor,
                  ),

                  DetailRow(
                    label: 'Stock',
                    value: '${currentProduct.stock} units',
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      currentProduct.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductUpdateScreen(
                              product: currentProduct,
                              productId: currentProduct.id,
                            ),
                          ),
                        );
                      },
                      child: const Text('Update Product'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}