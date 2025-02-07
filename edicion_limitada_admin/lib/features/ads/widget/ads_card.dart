import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/features/ads/model/ads_model.dart';
import 'package:edicion_limitada_admin/features/ads/view/edit_ads_screen.dart';
import 'package:edicion_limitada_admin/features/ads/bloc/ads_bloc.dart';

class AdsCard extends StatelessWidget {
  final AdsModel ads;

  const AdsCard({super.key, required this.ads});

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
          title: SizedBox(
            height: 150,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                base64Decode(ads.imageUrl),
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
          trailing: PopupMenuButton<String>(
            onSelected: (String value) async {
              if (value == 'Edit') {
                await customNavigator(
                  context,   
                  EditAdsScreen(ad: ads),
                );
                if (context.mounted) {
                  context.read<AdsBloc>().add(FetchAdsEvent());
                }
              } else if (value == 'Delete') {
                _showDeleteConfirmation(context);
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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ad'),
          content: const Text(
              'Are you sure you want to delete this ad? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AdsBloc>().add(DeleteAdsEvent(
                      id: ads.id!,
                    ));
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
