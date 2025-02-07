
import 'package:edicion_limitada_admin/core/utils/app_colors.dart';
import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/features/brands/bloc/brands_bloc.dart';
import 'package:edicion_limitada_admin/features/brands/widget/brand_card.dart';
import 'package:edicion_limitada_admin/features/brands/view/add_brands_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrandsBloc()..add(FetchBrandsEvent()),
      child: BlocListener<BrandsBloc, BrandsState>(
        listener: (context, state) {
          if (state is AddedBrandsState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Refresh the list after adding
            context.read<BrandsBloc>().add(FetchBrandsEvent());
          }
        },
        child: BlocBuilder<BrandsBloc, BrandsState>(
          builder: (context, state) {
            return Scaffold(
              appBar: const CustomAppbar(title: 'Brands'),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildBody(state),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await customNavigator(context, AddBrandsScreen());
                  if (context.mounted) {
                    context.read<BrandsBloc>().add(FetchBrandsEvent());
                  }
                },
                backgroundColor: AppColors.secondary,
                child: const Icon(Icons.add),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BrandsState state) {
    if (state is BrandsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is BrandsError) {
      return Center(child: Text(state.error));
    }

    if (state is FetchBrandsSuccessState) {
      if (state.brands.isEmpty) {
        return const Center(child: Text('No brands found'));
      }

      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.brands.length,
        itemBuilder: (context, index) {
          final brand = state.brands[index];
          return BrandCard(brand: brand);
        },
      );
    }

    return const Center(child: Text('Something went wrong'));
  }

  
}
