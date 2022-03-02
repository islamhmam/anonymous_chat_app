

import 'package:anonymous/modules/main_cubit/main_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/constants.dart';
import 'chat_detail_state.dart';

class ChatDetailsCubit extends Cubit<ChatDetailsStates>{
  ChatDetailsCubit( ) : super(ChatDetailsInitialState());

  static ChatDetailsCubit get(context)=>BlocProvider.of(context);



  String userId=FirebaseAuth.instance.currentUser!.uid.toString();


  // UserModel? userModel;
  // void getUserData() {
  //   emit(ChatDetailsGetUserDataLoadingState());
  //   FirebaseFirestore.instance.collection('users').doc(userId).get().then((value) {
  //     userModel = UserModel.fromJson(value.data()!);
  //     print(value.data());
  //     uid=userId;
  //     emit(ChatDetailsGetUserDataSuccessState());
  //   }).catchError((onError) {
  //     print(onError.toString());
  //     emit(ChatDetailsGetUserDataErrorState(onError.toString()));
  //   });
  //
  // }






  List<MessageModel> messages=[];
  void getMessage({
    required String? receiverId,
  }){
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages=[];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(ChatDetailsGetMessagesSuccessState());
    });


  }











  void sendMessag({
    required String receiverId,
    required String text,
    required String dateTime,
  }){
    MessageModel model =MessageModel(
      text: text,
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: userId,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {

      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(receiverId).set({
        'chatsId':receiverId , // John Doe
      });
      emit(ChatDetailsSendMessageSuccessState());
    })
        .catchError((error){

      emit(ChatDetailsSendMessageErrorState());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {

      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(userId).set({
        'chatsId':userId , // John Doe
      });
      emit(ChatDetailsSendMessageSuccessState());
    })
        .catchError((error){

      emit(ChatDetailsSendMessageErrorState());
    });

  }





  void scrollDown(ScrollController listController) {
    listController.animateTo(
      listController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
    emit(ChatDetailsScrollMessageState());
  }

}