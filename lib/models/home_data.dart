class HomeDataModel {
  late bool status;
  DataModel? data;

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}

class DataModel {
  List<Banners> banners = [];
  List<Products> products = [];

  DataModel.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((element) {
      banners.add(Banners.fromJson(element));
    });
    json['products'].forEach((element) {
      products.add(Products.fromJson(element));
    });
  }
}

class Banners {
  late int id;
  late String image;

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class Products {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String image;
  late String name;
  late bool inFavourites;
  late bool inCarts;

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    name = json['name'];
    image = json['image'];
    inFavourites = json['in_favorites'];
    inCarts = json['in_cart'];
  }
}
