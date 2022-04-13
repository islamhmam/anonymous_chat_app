

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
  String uuid=FirebaseAuth.instance.currentUser!.uid.toString();

  List<UserModel> users=[];
  List<String> blocked=[];

  Future<void> getBlocked() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uuid)
        .collection('blocked')
        .get()
        .then((value) {
          value.docs.forEach((element) {
            blocked.add(element.data()['id']);
          });
    }).catchError((onError){
          print(onError.toString());
    });

  }


  Future<void> getAllUsers() async {
    print('user id ===========  ${uuid}');

  await getBlocked();
    int l=0;

    if(users.length ==0) {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if(element.data()['uid'] != uid) {
            bool flag = true;

            for(int i =0 ; i< blocked.length ; i++){
              if(element.data()['uid'] == blocked[i]) {
                flag = false;
              }
            }

            if(flag==true){
              users.add(UserModel.fromJson(element.data()));
              l++;
            }

            emit(GetAllUsersSuccessOneState());
          }

          if(l==10){
            return;
          }
        });

        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState(error));
      });
    }
    print(users.length);


  }


  Future<void> getAllOneUsers() async {
    emit(GetAllUsersLoadingState());
    await getBlocked();

    int l=0;
    users.clear();
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if(element.data()['uid'] != uid) {
            bool flag = true;

            for(int i =0 ; i< blocked.length ; i++){
              if(element.data()['uid'] == blocked[i]) {
                flag = false;
              }
            }

            if(flag==true){
              users.add(UserModel.fromJson(element.data()));
              l++;
            }

            emit(GetAllUsersSuccessOneState());
          }

          if(l==10){
            return;
          }

        });

        emit(GetAllUsersSuccessState());
      }).catchError((error) {
        emit(GetAllUsersErrorState(error));
      });

    print(users.length);


  }







  List<UserModel> chatUsers=[];

  void getChatUsers()   {
    emit(GetChatUsersLoadingState());

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
        .collection('messages')
        .get()
        .then((val) async {
     for (var doc in val.docs) {
       await doc.reference.delete();
     }

     await FirebaseFirestore.instance
         .collection('users')
         .doc(uuid)
         .collection('chats')
         .doc(userModel.uid).delete();
//delete from other user-------------------------------------------------
     FirebaseFirestore.instance
         .collection('users')
         .doc(userModel.uid)
         .collection('chats')
         .doc(uuid)
         .collection('messages')
         .get()
         .then((val) async {
       for (var doc in val.docs) {
         await doc.reference.delete();
       }
       await FirebaseFirestore.instance
           .collection('users')
           .doc(userModel.uid)
           .collection('chats')
           .doc(uuid).delete();
         });

     getChatUsers();



   }).catchError((onError){
      print(onError.toString());
   });

     // FirebaseFirestore.instance
     //     .collection('users')
     //     .doc(userModel.uid)
     //     .collection('chats')
     //     .doc(uuid)
     //      .delete();


     // emit(ChatUsersRemoveFirebaseSuccessState());
     // getChatUsers();




  }


  void blockUser(UserModel userModel){
    FirebaseFirestore.instance
        .collection('users')
        .doc(uuid)
        .collection('blocked')
        .doc(userModel.uid)
        .set({
      'id': userModel.uid,
    });



  }


  void reportViolation(UserModel userModel, String report){
    FirebaseFirestore.instance
        .collection('reports')
        .doc()
        .set({
      'report maker': uuid,
      'reported': userModel.uid,
      'report body': report,

    });



  }









}