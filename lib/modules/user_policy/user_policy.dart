// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPolicy extends StatelessWidget  {
  const UserPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.blue[900],

        child: Center(
          child: Column(
            children: [
              Text('User Policy',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
      ),
              SizedBox(height: 20,),
              Text("Anonymous Chat, Inc. a Delaware corporation respects your privacy and is committed to protecting it through this privacy policy (the “Privacy Policy”). "
                  " \nThis Privacy Policy describes That we Are Not collect, use, share, disclose and We protect your information , and the Anonymous Chat Software, which includes live chat and any other additional services that We may add to such Pure Chat Software in the future."
                  " \nThis policy applies only to Anonymous Chat Software and any emails, texts or other electronic communications sent through the Site or Anonymous Chat Software."
                  "\n\n\nPlease email us with any questions or comments about this Privacy Policy and our privacy practices at pro.islamhmam@gmail.com",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 15,
                  
                ),
              ),


              SizedBox(height: 40,),

              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black,
                      offset: Offset(0,0),
                        blurRadius: 10,

                      )
                    ]
                  ),
                  child: CircleAvatar(

                    radius: 40,
                    backgroundImage:  AssetImage('images/islam.jpg'),

                  ),
                ),
              ),
              // SizedBox(height: 20,),

          //     Center(
          //   child: InkWell(
          //       child:  Text('Open My YouTube Channel',
          //         style: TextStyle(
          //           color: Colors.lightBlueAccent[100],
          //           fontSize: 15,
          //           fontWeight: FontWeight.bold,
          //           letterSpacing: 2,
          //
          //         ),
          //
          //       ),
          //       onTap: () => launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html'),
          //   ),
          // ),





            ],
          ),
        ),

      ),
    );
  }
}
