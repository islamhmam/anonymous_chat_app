import 'dart:core';

class UserModel{
  String? email;
  String? uid;
  String? imageUrl;
  String? name;


  UserModel({
    this.email,
    this.uid,
    this.imageUrl,
    this.name,
  });

  UserModel.fromJson(Map<String,dynamic> json){
    email = json['email'];
    uid = json['uid'];
    imageUrl = json['imageUrl'];
    name = json['name'];
  }

  Map<String,dynamic> toMap(){
    return{
      'email':email,
      'uid':uid,
      'imageUrl':imageUrl,
      'name':name,
    };
  }



}