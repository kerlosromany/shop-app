import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/dio.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/states.dart';
import 'package:shop_app/home_layout/screens/categories.dart';
import 'package:shop_app/home_layout/screens/favourites.dart';
import 'package:shop_app/home_layout/screens/products.dart';
import 'package:shop_app/home_layout/screens/settings.dart';

import '../../../components.dart';
import '../../../models/categories_model.dart';
import '../../../models/change_favorites.dart';
import '../../../models/get_favorites.dart';
import '../../../models/home_data.dart';
import '../../../models/shop_login_model.dart';
import '../../../models/user_data.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialStates());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen(),
  ];

  void changeNavBar(index) {
    currentIndex = index;
    emit(ShopChangeNavBarStates());
  }

  HomeDataModel? homeDataModel;
  Map<int, bool> favorites = {};
  void getHomeData() {
    emit(ShopLoadingHomeDataStates());

    DioHelper.getData(
      url: 'home',
      token: token,
    ).then((value) {
      homeDataModel = HomeDataModel.fromJson(value.data);
      for (var element in homeDataModel!.data!.products) {
        favorites.addAll({
          element.id: element.inFavourites,
        });
      }
      print(favorites);
      emit(ShopSuccessHomeDataStates());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataStates());
    });
  }

  CategoriesModel? categoriesModel;
  void getCategoriesData() {
    DioHelper.getData(url: 'categories').then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(ShopSuccessCategoriesStates());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesStates());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesStates());
    DioHelper.postData(
      url: 'favorites',
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavoritesData();
      }
      emit(ShopSuccessChangeFavoritesStates(
          changeFavoritesModel as ChangeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      emit(ShopErrorChangeFavoritesStates());
    });
  }

  FavoritesModel? getFavoritesModel;
  void getFavoritesData() {
    emit(ShopLoadingGetFavoritesStates());
    DioHelper.getData(url: 'favorites', token: token).then((value) {
      getFavoritesModel = FavoritesModel.fromJson(value.data);
      emit(ShopSuccessGetFavoritesStates());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesStates());
    });
  }

  ShopUserDataModel? userData;
  void getUserData() {
    emit(ShopLoadingUserDataStates());
    DioHelper.getData(url: 'profile', token: token).then((value) {
      userData = ShopUserDataModel.fromJson(value.data);
      print(value.data);
      emit(ShopSuccessUserDataStates(userData!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataStates());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateDataStates());
    DioHelper.putData(url: 'update-profile', token: token , data: {
      'name' : name,
      'email' : email,
      'phone' : phone,
    },).then((value) {
      userData = ShopUserDataModel.fromJson(value.data);
      print(value.data);
      emit(ShopSuccessUpdateDataStates(userData!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateDataStates());
    });
  }
}
