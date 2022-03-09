import 'dart:core';

class MessageModel{
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  bool? isRead;


  MessageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.text,
    this.isRead

  });

  MessageModel.fromJson(Map<String,dynamic> json){

    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    text = json['text'];
    isRead = json['isRead'];

  }

  Map<String,dynamic> toMap(){
    return{
      'senderId':senderId,
      'receiverId':receiverId,
      'dateTime':dateTime,
      'text':text,
      'isRead':isRead,

    };

  }



}