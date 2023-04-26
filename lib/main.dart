import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goli_soda/src/features/all_shops/all_shops_view.dart';
import 'package:goli_soda/src/features/all_shops/cubit/all_shop_cubit.dart';
import 'package:goli_soda/src/features/auth/sign_in/sign_in_cubit.dart';
import 'package:goli_soda/src/features/auth/sign_in/sign_in_screen.dart';
import 'package:goli_soda/src/features/auth/sign_up/sign_up_cubit.dart';
import 'package:goli_soda/src/features/create_vendor/create_vendor_cubit.dart';
import 'package:goli_soda/src/features/get_lines/cubit/get_lines_cubit.dart';
import 'package:goli_soda/src/features/home/home_cubit.dart';
import 'package:goli_soda/src/features/internet/internet_cubit.dart';
import 'package:goli_soda/src/features/line_details/cubits/line_details_cubit.dart';
import 'package:goli_soda/src/features/management_details/cubit/management_details_cubit.dart';
import 'package:goli_soda/src/features/manager/day_report_cubit/day_report_cubit.dart';
import 'package:goli_soda/src/features/manager/over_all/cubit/over_all_cubit.dart';
import 'package:goli_soda/src/features/navigator.dart';
import 'package:goli_soda/src/features/production_details/cubit/prodution_details_cubit.dart';
import 'package:goli_soda/src/features/production_details/detail_production.dart';
import 'package:goli_soda/src/features/shop_detail/shop_detail_cubit.dart';
import 'package:goli_soda/src/features/shop_history/shop_history_cubit.dart';
import 'package:goli_soda/src/features/total_history/total_collection/total_collection_cubit.dart';
import 'package:goli_soda/src/features/total_history/total_history_cubit/total_history_cubit.dart';
import 'package:goli_soda/src/local_storage/hive_store.dart';
import 'package:goli_soda/src/utils/custom_colors.dart';
import 'package:sizer/sizer.dart';

import 'src/features/blocked_user/cubit/blocked_user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().then((value) async {
    // final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   fetchTimeout: const Duration(seconds: 10),
    //   minimumFetchInterval: const Duration(hours: 1),
    // ));
    await HiveStore().initBox().then((value) =>
        runApp(MyApp(
          connectivity: Connectivity(),
        )));
  });
}

class MyApp extends StatelessWidget {
  final Connectivity? connectivity;

  const MyApp({
    Key? key,
    this.connectivity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (BuildContext, Orientation, DeviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<InternetCubit>(
              create: (internetCubitContext) =>
                  InternetCubit(connectivity: connectivity)),
          BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
          BlocProvider<CreateVendorCubit>(create: (context) => CreateVendorCubit()),
          BlocProvider<ShopDetailCubit>(create: (context) => ShopDetailCubit()),
          // BlocProvider<SignInCubit>(create: (context) => SignInCubit()),
          BlocProvider<SignUpCubit>(create: (context) => SignUpCubit()),
          BlocProvider<TotalHistoryCubit>(create: (context) => TotalHistoryCubit()),
          BlocProvider<TotalCollectionCubit>(create: (context) => TotalCollectionCubit()),
          BlocProvider<ShopHistoryCubit>(create: (context) => ShopHistoryCubit()),
          BlocProvider<GetLinesCubit>(create: (context) => GetLinesCubit()),
          BlocProvider<ProdutionDetailsCubit>(
              create: (context) => ProdutionDetailsCubit()),
          BlocProvider<ManagementDetailsCubit>(
              create: (context) => ManagementDetailsCubit()),
          BlocProvider<LineDetailsCubit>(create: (context) => LineDetailsCubit()),
          BlocProvider<DayReportCubit>(create: (context) => DayReportCubit()),
          BlocProvider<OverAllCubit>(create: (context) => OverAllCubit()),
          BlocProvider<AllShopCubit>(create: (context) => AllShopCubit()),
          BlocProvider<BlockedUserCubit>(create: (context) => BlockedUserCubit()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home:DataTablePage(),
          home:
              HiveStore().get(Keys.userId) != null ? NavigationScreen() : SignInScreen(),
        ),
      );
    });
  }
}



