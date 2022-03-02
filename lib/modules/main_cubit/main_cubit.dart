import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/style_model.dart';
import '../../models/user_model.dart';
import '../../shared/constants.dart';
import 'main_states.dart';

class MainCubit extends Cubit<MainStates>{
  MainCubit() : super(MainInitialState());

  static MainCubit get(context) => BlocProvider.of(context);







}

