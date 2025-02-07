import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/features/product/bloc/product_bloc.dart';
import 'package:edicion_limitada_admin/features/product/utils/product_delete_confirmation.dart';
import 'package:edicion_limitada_admin/features/product/view/add_product_screen.dart';
import 'package:edicion_limitada_admin/features/product/view/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(title: 'Product'),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          if (state is DeleteProductSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductFetchSuccesState) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products found'));
            }
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return Dismissible(
                  key: Key(product.id.toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    final result = await showDeleteConfirmationDialog(
                      context,
                      product,
                    );
                    return result ?? false;
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.border,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        title: Text(
                          '${index + 1} : ${product.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        trailing: const Icon(
                          FontAwesomeIcons.deleteLeft,
                          color: Color.fromARGB(255, 201, 100, 93),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No Products Found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await customNavigator(
            context,
            const AddProductScreen(),
          );
          if (result == true) {
            if (context.mounted) {
              context.read<ProductBloc>().add(FetchProductEvent());
            }
          }
        },
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.add),
      ),
    );
  }
}