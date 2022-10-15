import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Login/cubit/states.dart';
import 'package:shop_app/dio.dart';

import '../../models/shop_login_model.dart';

class ShopLoginCubit extends Cubit<ShopLoginStates> {
  ShopLoginCubit() : super(ShopLoginInitialState());

  static ShopLoginCubit get(context) => BlocProvider.of(context);

  late ShopLoginModel shopLoginModel;
  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: 'login',
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      print(value.data);
      shopLoginModel = ShopLoginModel.fromJson(value.data);
      emit(ShopLoginSuccessState(shopLoginModel));
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(ShopLoginChangePasswordState());
  }
}
