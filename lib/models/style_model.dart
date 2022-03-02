import 'package:flutter/material.dart';

class StyleModel {
  String? imageUrl;
  String? nickName;

  StyleModel(this.nickName ,this.imageUrl);

  StyleModel.fromJson(Map<String,dynamic> json){

    imageUrl = json['imageUrl'];
    nickName = json['name'];

  }

  Map<String,dynamic> toMap(){
    return{
      'name':nickName,
      'imageUrl':imageUrl,
    };

  }
}