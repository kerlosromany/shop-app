import 'package:shop_app/models/shop_login_model.dart';

import '../../../models/change_favorites.dart';
import '../../../models/user_data.dart';

abstract class ShopStates {}

class ShopInitialStates extends ShopStates {}

class ShopChangeNavBarStates extends ShopStates {}

class ShopLoadingHomeDataStates extends ShopStates {}

class ShopSuccessHomeDataStates extends ShopStates {}

class ShopErrorHomeDataStates extends ShopStates {}

class ShopSuccessCategoriesStates extends ShopStates {}

class ShopErrorCategoriesStates extends ShopStates {}

class ShopSuccessChangeFavoritesStates extends ShopStates {
  final ChangeFavoritesModel model;

  ShopSuccessChangeFavoritesStates(this.model);
}

class ShopErrorChangeFavoritesStates extends ShopStates {}

class ShopChangeFavoritesStates extends ShopStates {}

class ShopSuccessGetFavoritesStates extends ShopStates {}

class ShopErrorGetFavoritesStates extends ShopStates {}

class ShopLoadingGetFavoritesStates extends ShopStates {}

class ShopSuccessUserDataStates extends ShopStates {
  final ShopUserDataModel userdata;

  ShopSuccessUserDataStates(this.userdata);

}

class ShopErrorUserDataStates extends ShopStates {}

class ShopLoadingUserDataStates extends ShopStates {}



class ShopSuccessUpdateDataStates extends ShopStates {
  final ShopUserDataModel userdata;

  ShopSuccessUpdateDataStates(this.userdata);

}

class ShopErrorUpdateDataStates extends ShopStates {}

class ShopLoadingUpdateDataStates extends ShopStates {}
