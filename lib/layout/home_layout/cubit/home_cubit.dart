

import 'package:anonymous/modules/main_cubit/main_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/user_model.dart';
import '../../../shared/constants.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates>{
  HomeCubit( ) : super(HomeInitialState());

  static HomeCubit get(context)=>BlocProvider.of(context);

  List<UserModel> users=[];

  void getAllUsers() {
    print('user id ===========  ${uuid}');
    if(users.length ==0) {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if(element.data()['uid'] != uid) {
            users.add(UserModel.fromJson(element.data()));
          }

        });

        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState(error));
      });
    }
    print(users.length);


  }
  void getAllOneUsers() {

    users.clear();
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if(element.data()['uid'] != uid) {
            users.add(UserModel.fromJson(element.data()));
            emit(GetAllUsersSuccessOneState());

          }

        });

        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState(error));
      });

    print(users.length);


  }


  String uuid=FirebaseAuth.instance.currentUser!.uid.toString();

  List<UserModel> chatUsers=[];

  void getChatUsers()   {

    chatUsers.clear();
      FirebaseFirestore.instance
          .collection('users')
          .doc(uuid)
          .collection('chats')
          .get().then((value) {
        value.docs.forEach((element) {
          print('id ------------------------------------------------------');
          print(element.id);

          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .get().then((value) {
            chatUsers.add(UserModel.fromJson(value.data()!));
            emit(GetChatUsersSuccessOneState());

          });
        });
        emit(GetChatUsersSuccessState());
      }).catchError((error) {
        emit(GetChatUsersErrorState(error));
      });


    print(chatUsers.length);

  }


  void deleteChatItem( UserModel userModel){
   // chatUsers.removeAt(index);
   // emit(ChatUsersRemoveLocalState());

   FirebaseFirestore.instance
       .collection('users')
       .doc(uuid)
       .collection('chats')
        .doc(userModel.uid)
        .delete().then((value){
     // emit(ChatUsersRemoveFirebaseSuccessState());
     getChatUsers();

   }).catchError((error){
     Fluttertoast.showToast(msg: error.toString());
     // emit(ChatUsersRemoveFirebaseErrorState());
   });


  }







}