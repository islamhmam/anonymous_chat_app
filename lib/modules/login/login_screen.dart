// ignore_for_file: prefer_const_constructors

import 'package:anonymous/modules/login/cubit/login_cubit.dart';
import 'package:anonymous/modules/login/cubit/login_states.dart';
import 'package:anonymous/shared/components/components.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../layout/home_layout/home_layout.dart';
import '../../shared/constants.dart';
import '../../shared/network/local/cash_helper.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {


  var formKey=GlobalKey<FormState>();

  var nameController=TextEditingController();
  var phoneController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit , LoginStates>(
        listener:(context, state)  {
          if(state is LoginErrorState){
            Fluttertoast.showToast(
                msg: '${state.error}',
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }else if(state is LoginSuccessState){
            CashHelper.putData(key: 'uid', value:state.userId )
                .then((value) {
              uid=state.userId;
              navigateAndFinish(context: context,widget: HomeLayout());
            });


          }



        },
       builder:(context, state)  {
          return Scaffold(
            body: Container(

              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: [
                        Colors.green.shade900,
                        Colors.green.shade500,
                        Colors.green.shade400,
                      ]
                  )
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  // #login, #welcome
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const[
                        Text("Login",style: TextStyle(color: Colors.white,fontSize: 40),),
                        SizedBox(height: 10,),
                        Text("Welcome Back",style: TextStyle(color: Colors.white,fontSize: 20),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60),topRight: Radius.circular(60)),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            children: [
                              const SizedBox(height: 60,),
                              // #email, #password
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const[
                                    BoxShadow(
                                        color: Color.fromRGBO(171, 171, 171, .7),blurRadius: 20,offset: Offset(0,10)),
                                  ],
                                ),


                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                        ),
                                        child:defaultFormField(
                                          controller: emailController,
                                          type: TextInputType.emailAddress,
                                          validator: (String? value)
                                          {
                                            if(value!.isEmpty){
                                              return'You Should Write User Name';

                                            }
                                          },
                                          label:'Email' ,
                                          prefix: Icons.email,)  ,


                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                        ),
                                        child: defaultFormField(
                                          controller: passwordController,
                                          type: TextInputType.visiblePassword,
                                          validator: (String? value)
                                          {
                                            if(value!.isEmpty){
                                              return'You Should Write User Password Right';

                                            }
                                          },
                                          onSubmit: (value){
                                            if(formKey.currentState!.validate()) {
                                              LoginCubit.get(context).userLogin(
                                                  email: emailController.text,
                                                  password: passwordController.text);
                                            }
                                          },
                                          label:'Password' ,
                                          isPassword: true,
                                          prefix: Icons.lock,)  ,
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              // #login
                              ConditionalBuilder(
                                condition:state is! LoginLoadingState  ,
                                fallback:(context) =>Center(child: CircularProgressIndicator()) ,
                                builder:(context) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 50),

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.green[800]
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      highlightColor: Colors.lightGreenAccent,
                                      splashColor: Colors.green[800],
                                      borderRadius: BorderRadius.circular(50),
                                      onTap: () {
                                        print('1');
                                        if(formKey.currentState!.validate()) {
                                          LoginCubit.get(context).userLogin(
                                              email: emailController.text,
                                              password: passwordController.text);
                                        }
                                      },

                                      child: Container(
                                        height: 50,
                                        width: double.infinity,
                                        // width: ,
                                        // margin: const EdgeInsets.symmetric(horizontal: 50),
                                        // decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(50),
                                        //     color: Colors.green[800]
                                        // ),
                                        child: const Center(
                                          child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        ),

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              // #login SNS
                              TextButton(

                                  onPressed: () { navigateTo(context: context,widget: RegisterScreen() ); },
                                  child: const Text("Register(New User)",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)),
                              const SizedBox(height: 40),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.blue[800],

                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell (
                                          highlightColor: Colors.lightBlueAccent,
                                          splashColor: Colors.blue[800],
                                          borderRadius: BorderRadius.circular(50),
                                          onTap: (){},
                                          child: Container(
                                            height: 50,


                                            child: const Center(
                                              child: Text("Facebook",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.red[900],
                                      ),

                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: (){},
                                          highlightColor: Colors.redAccent,
                                          splashColor: Colors.red[900],
                                          borderRadius: BorderRadius.circular(50),
                                          child: Container(
                                            height: 50,
                                            child: const Center(
                                              child: Text("Gmail",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
       } ,

      ),
    );
  }


}



