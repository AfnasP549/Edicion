import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/features/ads/bloc/ads_bloc.dart';
import 'package:edicion_limitada_admin/features/ads/view/add_ads_screen.dart';
import 'package:edicion_limitada_admin/features/ads/widget/ads_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsScreen extends StatelessWidget {
  const AdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdsBloc, AdsState>(
      listener: (context, state) {
        if (state is AddAdsState || state is DeleteAdsSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(
            state is AddAdsState ? state.message :
            state is DeleteAdsSuccessState ? state.message : 'Action Completed')),
          );
          context.read<AdsBloc>().add(FetchAdsEvent());
        }
      },
      child: BlocBuilder<AdsBloc, AdsState>(builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppbar(title: 'Ads'),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: _buildBody(state),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              customNavigator(context, AddAdsScreen());
              if (context.mounted) {
                  context.read<AdsBloc>().add(FetchAdsEvent());
                }
    
            },
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }

  Widget _buildBody(AdsState state){
    if(state is  AdsLoadingState){
        return const Center(child: CircularProgressIndicator());
    }
    if (state is AdsErrorState) {
      return Center(child: Text(state.error));
    }
    if(state is FetchAdsSuccessState){
      if(state.ads.isEmpty){
         return const Center(child: Text('No ads found'));
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: state.ads.length,
        itemBuilder: (context, index) {
          final ads = state.ads[index];
          return AdsCard(ads: ads,);
        },
      );
    }
 return const Center(child: Text('Something went wrong'));

  }
}
