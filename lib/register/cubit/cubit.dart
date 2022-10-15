import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/dio.dart';
import 'package:shop_app/register/cubit/states.dart';

import '../../models/register.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  RegisterModel? registerModel;
  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterLoadingState());

    DioHelper.postData(
      url: 'register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      print(value.data);
      registerModel = RegisterModel.fromJson(value.data);
      emit(RegisterSuccessState(registerModel!));
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState());
    });
  }

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  void changePassword() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(RegisterChangePassswordVisibilityState());
  }
}
