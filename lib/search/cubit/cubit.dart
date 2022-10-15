import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components.dart';
import 'package:shop_app/dio.dart';
import 'package:shop_app/search/cubit/states.dart';

import '../search_model.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialStates());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;
  void getSearchData(String text) {
    emit(SearchLoadingStates());

    DioHelper.postData(
      url: 'products/search',
      data: {
        'text': text,
      },
      token: token,
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessStates());
    }).catchError((error) {
      print(error.toString());
      emit(SearchErrorStates());
    });
  }
}
