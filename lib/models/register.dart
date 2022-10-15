class RegisterModel {
  bool? status;
  String? message;
  RegisterData? data;

  RegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? RegisterData.fromJson(json['data']) : null;
  }
}

class RegisterData {
  String? name;
  String? phone;
  String? email;
  String? image;
  String? token;
  int? id;

  RegisterData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    token = json['token'];
    id = json['id'];
  }
}
