import 'package:anonymous/modules/main_cubit/main_cubit.dart';
import 'package:anonymous/shared/bloc_observer.dart';
import 'package:anonymous/shared/constants.dart';
import 'package:anonymous/shared/network/local/cash_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layout/home_layout/home_layout.dart';
import 'modules/choose_style/choose_style_screen.dart';
import 'modules/login/login_screen.dart';
import 'modules/main_cubit/main_states.dart';

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await CashHelper.init();
  uid=CashHelper.getData(key: 'uid');

  await Firebase.initializeApp();

  Widget widget;

  if(uid !=null){
    widget=HomeLayout();
  }else{
    widget=LoginScreen();
  }


  BlocOverrides.runZoned(
        () {
      // Use cubits...
          runApp( MyApp(startWidget: widget,));

        },
    blocObserver: MyBlocObserver(),
  );



}

class MyApp extends StatelessWidget {
  final Widget startWidget ;

  MyApp({Key? key, required this.startWidget}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => MainCubit(),)
        ],

        child: BlocProvider(create: (context) => MainCubit(),
          child: BlocConsumer<MainCubit,MainStates>(
            listener: (context, state) {},
            builder: (context , state){
              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(

                  primarySwatch: Colors.blue,
                ),
                home:  startWidget,
              );
            },
          ),

        )
    );





  }
}

