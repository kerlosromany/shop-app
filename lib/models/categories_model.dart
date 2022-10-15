import 'package:flutter/material.dart';
class CategoriesModel {
  late bool status;
  CategoriesDataModel? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null
        ? CategoriesDataModel.fromJson(json['data'])
        : null;
  }
}

class CategoriesDataModel {
  late int currentPage;
  List<Datamodel> data = [];

  CategoriesDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data.add(Datamodel.fromJson(element));
    });
  }
}

class Datamodel {
  late int id;
  late String name;
  late String image;

  Datamodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
