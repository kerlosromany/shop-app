import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/cubit.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/states.dart';
import 'package:shop_app/shared_preferences.dart';

import 'Login/login_screen.dart';
import 'OnBoarding/onboarding_screen.dart';
import 'bloc_observer.dart';
import 'dio.dart';
import 'home_layout/screens/home_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () async {
      DioHelper.init();
      await CacheHelper.init();

      bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
      print(onBoarding);
      late Widget widget;
      token = CacheHelper.getData(key: 'token');
      print("------------------------------");
      print(token);
      if (onBoarding != null) {
        if (token != null) {
          widget = HomeLayout();
        }else{
          widget = LoginScreen();
        }
      }else{
        widget = OnBoarding();
      }

      runApp(MyApp(widget));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  late final Widget startWidget;

  MyApp(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavoritesData()..getUserData(),
        ),
      ],
      child: BlocConsumer<ShopCubit , ShopStates>(
        listener: (context , state) => ShopCubit(),
        builder: (context , state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: startWidget,
        ),
      ),
    );
  }
}
