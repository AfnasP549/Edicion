import 'package:edicion_limitada_admin/features/ads/bloc/ads_bloc.dart';
import 'package:edicion_limitada_admin/features/ads/service/ads_service.dart';
import 'package:edicion_limitada_admin/features/brands/bloc/brands_bloc.dart';
import 'package:edicion_limitada_admin/features/product/bloc/product_bloc.dart';
import 'package:edicion_limitada_admin/features/screen/splash_screen.dart';
import 'package:edicion_limitada_admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //BlocProvider<BrandBloc>(create: (context)=>BrandBloc()),
        BlocProvider<BrandsBloc>(create: (context)=>BrandsBloc()),
        BlocProvider<ProductBloc>(create: (context)=>ProductBloc()..add(FetchProductEvent())),
        BlocProvider(create: (context) => AdsBloc(AdsService())..add(FetchAdsEvent()))
        
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(  
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
