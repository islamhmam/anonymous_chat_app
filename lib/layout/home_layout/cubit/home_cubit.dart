

import 'package:anonymous/modules/main_cubit/main_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import '../../../shared/constants.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates>{
  HomeCubit( ) : super(HomeInitialState());

  static HomeCubit get(context)=>BlocProvider.of(context);

  List<UserModel> users=[];

  void getAllUsers() {

    emit(GetAllUsersLoadingState());
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


  List<UserModel> chatUsers=[];

  void getChatUsers() {

    emit(GetChatUsersLoadingState());
    if(chatUsers.length ==0) {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) async {
          print('id ------------------------------------------------------');

          // var collection = FirebaseFirestore.instance
          //                                   .collection('users')
          //                                   .doc(uid).collection('chats');
          //
          //
          // var querySnapshots = await collection.get();
          // for (var snapshot in querySnapshots.docs) {
          //   String documentID = snapshot.id; // <-- Document ID
          //   print('###########################' + documentID);
          //
          // }

String uuid=FirebaseAuth.instance.currentUser!.uid.toString();

// print(uuid);

          FirebaseFirestore.instance
              .collection('users')
              .doc(uuid)
              .collection('chats')
              .get().then((value) {

                  print('inside 11111111111111111111111111111111111111111111');
                  value.docs.forEach((element){

                    print(element.id);

                  });


            // for (var snapshot in value.docs) {
            //   print('inside 222222222222222222222222222222222222222222222222222');
            //
            //   String documentID = snapshot.id; // <-- Document ID
            //     print('###########################' + documentID);
            //
            //   }
          });





            chatUsers.add(UserModel.fromJson(element.data()));





        });
        emit(GetChatUsersSuccessState());

      }).catchError((error) {
        emit(GetChatUsersErrorState(error));
      });
    }
    print(chatUsers.length);

  }


}