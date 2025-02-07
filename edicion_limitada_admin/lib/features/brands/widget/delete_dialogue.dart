import 'package:edicion_limitada_admin/features/brands/view/brands_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada_admin/features/brands/bloc/brands_bloc.dart';
import 'package:edicion_limitada_admin/features/brands/model/brands_model.dart';

class DeleteDialogue {
  void showDeleteConfirmation(BuildContext context, BrandsModel brand) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ${brand.name}?'),
          content: const Text(
            'Are you sure you want to delete this brand? This action cannot be undone.'
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
               
                context.read<BrandsBloc>().add(DeleteBrandsEvent(
                  id: brand.id!,
                  brandsname: brand.name
                ));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BrandsScreen()));
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}