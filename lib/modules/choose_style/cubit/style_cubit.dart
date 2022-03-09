

import 'package:anonymous/modules/main_cubit/main_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../models/style_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/constants.dart';
import 'style_states.dart';

class StyleCubit extends Cubit<StyleStates>{
  StyleCubit( ) : super(StyleInitialState());

  static StyleCubit get(context)=>BlocProvider.of(context);


  List<StyleModel> stylesList=[];

  void getStyles() {

    emit(GetStylesLoadingState());
    if(stylesList.length ==0) {
      FirebaseFirestore.instance
          .collection('styles')
          .get()
          .then((value) {
        value.docs.forEach((element) {

          stylesList.add(StyleModel.fromJson(element.data()));


        });

        emit(GetStylesSuccessState());
      }).catchError((error) {
        emit(GetStylesErrorState(error.toString()));
      });
    }
  }



  int styleIndex=-1;
  String? imageUrl;
  String? nickName;


  void changeStyleIndex(int index, String? name, String? imaUrl){
    styleIndex=index;
    imageUrl=imaUrl;
    nickName=name;

    emit(ChangeStyleIndexState());
  }


  UserModel? userModel;


  String userId=FirebaseAuth.instance.currentUser!.uid.toString();

  void getUserData() {
    emit(GetUserDataLoadingStyleState());

    FirebaseFirestore.instance.collection('users').doc(userId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      print(value.data());
      uid=userId;
      emit(GetUserDataSuccessStyleState());
    }).catchError((onError) {
      print(onError.toString());
      Fluttertoast.showToast(msg: onError.toString());
      emit(GetUserDataErrorStyleState(onError.toString()));
    });

  }




  void updateUserData({
    required String name,
    required String imageUrl,
  }) {
    emit(UpdateUserDataLoadingState());
    // if(profileImage != null){
    //   uploadProfileImage();
    //   print('     profile image uploaded');
    // }else if (coverImage != null){
    //   uploadCoverImage();
    //   print('     cover image uploaded');
    //
    // }
    UserModel model = UserModel(
      name: name,
      imageUrl: imageUrl,
      email: userModel!.email,
      uid: userModel!.uid,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(globalUserModel!.uid)
        .update(model.toMap())
        .then((value) {
      print('               userData  update success');
      print('                 get after update userData success');
    }).catchError((error) {
      print('                 update Error');
      emit(UpdateUserDataErrorState());
    });
  }





}