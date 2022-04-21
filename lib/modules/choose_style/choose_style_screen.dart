// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:anonymous/layout/home_layout/home_layout.dart';
import 'package:anonymous/shared/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/style_model.dart';
import '../../shared/components/components.dart';

import 'cubit/style_cubit.dart';
import 'cubit/style_states.dart';

class ChooseStyleScreen extends StatelessWidget {

  var nameController = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StyleCubit()..getStyles()..getUserData(),
      child: BlocConsumer<StyleCubit,StyleStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              titleSpacing: 0,
              title: Text('Choose Name/Photo'),
              actions: [
               Container(
                 color: Colors.lightBlue[400],

                 child: Material(
                   color: Colors.transparent,
                   child: InkWell(

                     onTap: () {

                       if(StyleCubit.get(context).styleIndex==-1){
                         Fluttertoast.showToast(msg: 'Choose Photo !!!');

                       }else if(nameController.text.trim().isEmpty){
                         Fluttertoast.showToast(msg: 'Write NickName !!!');

                       } else{
                         StyleCubit.get(context).updateUserData(
                           name: nameController.text.trim(),
                           imageUrl: StyleCubit.get(context).imageUrl!,
                         );
                         Fluttertoast.showToast(msg: 'Style Saved');

                         navigateAndFinish(context: context , widget:  HomeLayout());
                       }



                     },
                     child: Container(
                       child: Padding(
                         padding: const EdgeInsets.only(left: 20.0,right: 15,top: 8,bottom: 8),
                         child: ConditionalBuilder(
                           condition: state is UpdateUserDataLoadingState ,
                           builder:(context) => Center(child: CircularProgressIndicator(color: Colors.white,),) ,
                           fallback:(context) =>Center(child: Text('Save',
                             style: TextStyle(
                                 fontSize: 18,
                                 color: Colors.white,
                                 fontWeight: FontWeight.w600

                             ),
                           )) ,


                         ),
                       ),
                     ),
                   ),
                 ),
               )
              ],
                elevation: 0,


            ),
            body:ConditionalBuilder(
              condition:state is!  GetUserDataLoadingStyleState && state is!  GetUserDataErrorStyleState ,
              fallback: (context)=>Center(child: CircularProgressIndicator(),),
              builder: (context)=>Column(
                children: [
                  Container(
                    color: Colors.blue,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(

                        children: [
                        Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:  CachedNetworkImageProvider('${StyleCubit.get(context).userModel!.imageUrl}'),

                              ),

                              //Active Circle
                              // Padding(
                              //   padding: const EdgeInsetsDirectional.only(
                              //     bottom: 0,
                              //     end: 0,),
                              //   child: CircleAvatar(
                              //     radius: 8.0,
                              //     backgroundColor: Colors.white,
                              //     child: CircleAvatar(
                              //       radius: 6.0,
                              //       backgroundColor: Colors.green,
                              //     ),
                              //   ),
                              // ),


                            ]
                        ),
                        SizedBox(width: 20,),
                        Text('${StyleCubit.get(context).userModel!.name}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                              fontWeight: FontWeight.w700
                          ),),


                      ],

                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,top: 5,bottom: 10),
                    child: Container(

                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),

                      child: defaultFormField(

                        controller: nameController,
                        type: TextInputType.name,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'You Should Write NickName';
                          }
                        },
                        label: 'NickName',
                        prefix: Icons.email,),


                    ),
                  ),
                  Text('Choose Picture:',
                    style: TextStyle(
                        color: Colors.black,

                        fontWeight: FontWeight.bold,
                        // backgroundColor: Colors.blueAccent,
                        fontSize: 25

                    ),),


                  Expanded(
                    child: Container(
                      child: ConditionalBuilder(
                        condition: StyleCubit.get(context).stylesList.length > 0,
                        fallback:(context) => Center(child: CircularProgressIndicator(),) ,
                        builder: (context) =>Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GridView.count(


                            crossAxisCount: 3,

                            children: List.generate(StyleCubit.get(context).stylesList.length, (index) {
                              return  buildStyle(StyleCubit.get(context).stylesList[index],context,index);

                            }),
                            // physics: BouncingScrollPhysics() ,

                          ),
                        ) ,


                      ),
                    ),
                  ),
                ],
              ),

            ),
          );


        },
      ),
    )  ;
  }




  Widget buildStyle(StyleModel styleModel,context,index)=>
  Padding(
    padding: const EdgeInsets.only(bottom: 5,top: 5,left: 5, right: 5),
    child: InkWell(
      onTap: (){
        StyleCubit.get(context).changeStyleIndex(index,styleModel.nickName,styleModel.imageUrl);

      },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image:  CachedNetworkImageProvider( "${styleModel.imageUrl}",),
              height: 80.0,
              width: 80.0,

            ),
            SizedBox(height: 5.0,),
            // Text("${styleModel.nickName}",
            //   style: TextStyle(
            //     color:StyleCubit.get(context).styleIndex==index ? Colors.white : Colors.black,
            //     fontSize: 25.5,
            //     fontWeight: FontWeight.bold,
            //
            //   ),
            // ),
          ],

        ),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color:StyleCubit.get(context).styleIndex==index ? Colors.blue : Colors.grey[400] ,
        ),
      ),
    ),
  );
}
