// ignore_for_file: prefer_const_constructors

import 'package:anonymous/modules/choose_style/choose_style_screen.dart';
import 'package:anonymous/modules/register/cubit/register_cubit.dart';
import 'package:anonymous/modules/register/cubit/register_states.dart';
import 'package:anonymous/shared/components/components.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/home_layout/home_layout.dart';
import '../../shared/constants.dart';
import '../../shared/network/local/cash_helper.dart';

class RegisterScreen extends StatelessWidget {


  var formKey=GlobalKey<FormState>();

  // var nameController=TextEditingController();
  // var phoneController=TextEditingController();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  var confirmPasswordController=TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context, state) {

          if(state is RegisterSuccessState) {
            CashHelper.putData(key: 'uid', value:state.userId )
                .then((value) {
              uid=state.userId;
              navigateAndFinish(context: context, widget: ChooseStyleScreen());

            });
          }
        },
        builder: (context,state){
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
                  const SizedBox(height: 40),
                  // #login, #welcome
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const[
                        Text("Register",style: TextStyle(color: Colors.white,fontSize: 40),),
                        SizedBox(height: 10,),
                        Text("Your Gate to Private Chating",style: TextStyle(color: Colors.white,fontSize: 20),),
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
                                          label:'Password' ,
                                          isPassword: true,
                                          prefix: Icons.lock,)  ,
                                      ),Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                                        ),
                                        child: defaultFormField(
                                          controller: confirmPasswordController,
                                          type: TextInputType.visiblePassword,
                                          validator: (String? value)
                                          {
                                            if(value!.isEmpty){
                                              return'You Should Write User Password Right';

                                            }
                                          },
                                          label:'Confirm Password' ,
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
                                condition: state is! RegisterLoadingState,
                                fallback:(context) => Center(child: CircularProgressIndicator())  ,
                                builder: (context)=>
                                 Container(
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
                                        if(formKey.currentState!.validate()) {
                                          RegisterCubit.get(context).userRegister(
                                            email: emailController.text,
                                            password: passwordController.text,

                                          );

                                        }
                                        print('1');

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
                                          child: Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        ),

                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              // #login SNS
                              // const Text("Or Login With:",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                              // const SizedBox(height: 30),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Container(
                              //
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(50),
                              //           color: Colors.blue[800],
                              //
                              //         ),
                              //         child: Material(
                              //           color: Colors.transparent,
                              //           child: InkWell (
                              //             highlightColor: Colors.lightBlueAccent,
                              //             splashColor: Colors.blue[800],
                              //             borderRadius: BorderRadius.circular(50),
                              //             onTap: (){},
                              //             child: Container(
                              //               height: 50,
                              //
                              //
                              //               child: const Center(
                              //                 child: Text("Facebook",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     const SizedBox(width: 30),
                              //     Expanded(
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(50),
                              //           color: Colors.red[900],
                              //         ),
                              //
                              //         child: Material(
                              //           color: Colors.transparent,
                              //           child: InkWell(
                              //             onTap: (){},
                              //             highlightColor: Colors.redAccent,
                              //             splashColor: Colors.red[900],
                              //             borderRadius: BorderRadius.circular(50),
                              //             child: Container(
                              //               height: 50,
                              //               child: const Center(
                              //                 child: Text("Gmail",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
        },

      ),
    );
  }


}



