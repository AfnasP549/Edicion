import 'package:edicion_limitada_admin/features/product/bloc/product_bloc.dart';
import 'package:edicion_limitada_admin/features/product/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


   showDeleteConfirmationDialog(
    BuildContext context, ProductModel product) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Product'),
      content: Text('Are you sure you want to delete "${product.name}"?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            // Optionally restore product or reload
          //  context.read<ProductBloc>().add(FetchProductEvent());
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            // Proceed with deletion
            context.read<ProductBloc>().add(
              DeleteProductEvent(
                id: product.id,
                productName: product.name,
              ),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}


