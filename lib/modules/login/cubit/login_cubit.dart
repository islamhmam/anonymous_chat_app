import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_states.dart';


class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);



  void userLogin({
    required String email,
    required String password,

  }
      ){
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value) {
      print ('login success ###########################');


      emit(LoginSuccessState(value.user!.uid.toString()));

    }).catchError((onError){

      print(onError.toString());

      emit(LoginErrorState(onError.toString()));
    });

  }






}