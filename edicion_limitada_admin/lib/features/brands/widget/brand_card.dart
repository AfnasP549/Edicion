import 'dart:convert';
import 'package:edicion_limitada_admin/features/brands/widget/delete_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/features/brands/model/brands_model.dart';
import 'package:edicion_limitada_admin/features/brands/view/edit_brands_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada_admin/features/brands/bloc/brands_bloc.dart';

class BrandCard extends StatelessWidget {
  final BrandsModel brand;  

  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: ListTile(
          leading: SizedBox(
            height: 150,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(brand.imageUrl),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
          ),
          title: Text(brand.name),
          subtitle: Text(
            brand.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'Edit') {
                await customNavigator(
                  context,
                  EditBrandsScreen(brand: brand),
                );
                if (context.mounted) {
                  context.read<BrandsBloc>().add(FetchBrandsEvent());
                }
              } else if (value == 'Delete') {
                DeleteDialogue().showDeleteConfirmation(context, brand);
              
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'Delete',
                  child: Text('Delete'),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}
