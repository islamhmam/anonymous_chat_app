import 'package:anonymous/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../models/user_model.dart';
import 'register_states.dart';


class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  bool isUserPolicyChecked=false;

  void changeUserPolicy(bool value){

    isUserPolicyChecked=value;
    emit(ChangePolicyState());
  }


  void userRegister({
    required String email,
    required String password,
  }
      ){
    emit(RegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,

    ).then((value) {
      print(value.user!.email);
      print(value.user!.uid);

      createUser(
        email: email,
        uid: value.user!.uid,
      );
      Fluttertoast.showToast(msg: 'Success Registration');
      emit(RegisterSuccessState(value.user!.uid.toString()));
    }).catchError((onError){
      Fluttertoast.showToast(msg: onError.toString());

      emit(RegisterErrorState(onError.toString()));

    });


  }

  void createUser({
    required String email,
    required String uid,

  }){
    emit(CreateUserLoadingState());
     globalUserModel=UserModel(
      email: email,
      uid: uid,
      imageUrl: 'https://firebasestorage.googleapis.com/v0/b/chat-me-app-be3e1.appspot.com/o/animals_photos%2Flion.png?alt=media&token=23f5dfbf-da93-4fc5-ac8f-afbbc09a037a',
      name: 'Write Name',
    );

    FirebaseFirestore.instance
        .collection('users').doc(uid)
        .set(globalUserModel!.toMap())
        .then((value) {
      print('User Created################################');
      emit(CreateUserSuccessState());


    }).catchError((onError){

      emit(CreateUserErrorState(onError.toString()));

    });

  }




}