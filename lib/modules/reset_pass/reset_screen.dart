// ignore_for_file: prefer_const_constructors


import 'package:anonymous/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../register/register_screen.dart';

class ResetScreen extends StatefulWidget {


  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(

            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      Colors.blue.shade900,
                      Colors.blue.shade500,
                      Colors.blue.shade400,
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:  AssetImage('images/logo.png'),

                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const[
                            Text("Reset",
                              style: TextStyle(color: Colors.white, fontSize: 40),),
                            SizedBox(height: 10,),
                            Text("Reset Password",
                              style: TextStyle(color: Colors.white, fontSize: 20),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60),
                          topRight: Radius.circular(60)),
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
                                      color: Color.fromRGBO(171, 171, 171, .7),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)),
                                ],
                              ),


                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey.shade200)),
                                      ),
                                      child: defaultFormField(
                                        controller: emailController,
                                        type: TextInputType.emailAddress,
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'You Should Write Correct Email';
                                          }
                                        },
                                        label: 'Email',
                                        prefix: Icons.email,),


                                    ),

                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // #login
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 50),

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue[800]
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor: Colors.lightBlueAccent,
                                  splashColor: Colors.blue[800],
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    if(formKey.currentState!.validate()){
                                      FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim())
                                          .then((value) {
                                            print('1');
                                            setState(() {
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      backgroundColor: Colors.blue[900],
                                                      content: Text('Check Your Email'))
                                              );
                                            });

                                      }).catchError((onError){
                                        print('2');

                                        Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                                backgroundColor: Colors.blue[900],

                                                content: Text('${onError.toString()}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                ))
                                        );
                                      });

                                    }
                                  },

                                  child: Container(
                                    height: 50,
                                    width: double.infinity,

                                    child: const Center(
                                      child: Text("Send Mail", style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),),
                                    ),

                                  ),
                                ),
                              ),
                            ),



                            const SizedBox(height: 40),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}



