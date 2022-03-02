// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:anonymous/layout/home_layout/home_layout.dart';
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






  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StyleCubit()..getStyles()..getUserData(),
      child: BlocConsumer<StyleCubit,StyleStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Choose NickName'),
              actions: [
               Container(
                 color: Colors.lightBlue[400],

                 child: Material(
                   color: Colors.transparent,
                   child: InkWell(

                     onTap: () {

                       if(StyleCubit.get(context).styleIndex==-1){
                         Fluttertoast.showToast(msg: 'Choose any Style First');

                       }else{
                         StyleCubit.get(context).updateUserData(
                           name: StyleCubit.get(context).nickName!,
                           imageUrl: StyleCubit.get(context).imageUrl!,
                         );

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



            ),
            body: ConditionalBuilder(
              condition: StyleCubit.get(context).stylesList.length > 0,
              fallback:(context) => Center(child: CircularProgressIndicator(),) ,
              builder: (context) =>Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(StyleCubit.get(context).stylesList.length, (index) {
                   return  buildStyle(StyleCubit.get(context).stylesList[index],context,index);

                  }),
                    // physics: BouncingScrollPhysics() ,

                ),
              ) ,


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
            Text("${styleModel.nickName}",
              style: TextStyle(
                color:StyleCubit.get(context).styleIndex==index ? Colors.white : Colors.black,
                fontSize: 25.5,
                fontWeight: FontWeight.bold,

              ),
            ),
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
