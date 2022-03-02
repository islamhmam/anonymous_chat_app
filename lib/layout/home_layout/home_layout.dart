// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:anonymous/layout/home_layout/cubit/home_cubit.dart';
import 'package:anonymous/shared/components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../models/user_model.dart';
import '../../modules/chat_details/chat_details.dart';
import 'cubit/home_states.dart';


class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getAllUsers()..getChatUsers(),
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Anonymous Chat'),
                bottom: TabBar(
                  tabs: [
                    Tab(text: 'Random Users', icon: Icon(
                      Icons.wc_rounded,
                      size: 35,
                    ),),
                    Tab(text: 'Last Chats', icon: Icon(
                        Icons.wechat,
                        size: 35,
                    ),),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                           randomUsers(context,HomeCubit.get(context).users),
                           randomUsers(context,HomeCubit.get(context).chatUsers),


                ],
              ) ,

            ),
          );





          
        },
      ),
    )  ;
  }

  
  
  Widget randomUsers(context , List<UserModel> users)=>  ConditionalBuilder(
    condition:
  users.length > 0
    ,
    fallback:(context) => Center(child: CircularProgressIndicator(),) ,
    builder: (context) => ListView.separated(
        itemBuilder: (context, index) {
          return buildChatItem(users[index],context);
        },
        separatorBuilder:(context, index) => myDivider(),
        itemCount: users.length
    ) ,


  );
  
  
  Widget buildChatItem(UserModel model ,context) =>InkWell(
    onTap: (){
      navigateTo(context: context, widget: ChatDetails(model));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:  CachedNetworkImageProvider('${model.imageUrl}'),

          ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                bottom: 0,
                end: 0,),
              child: CircleAvatar(
                radius: 8.0,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 6.0,
                  backgroundColor: Colors.green,
                ),
              ),
            ),


          ]
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Text('${model.name}',
            style: Theme.of(context).textTheme.subtitle1,),
        ),


      ],),
    ),
  );
}
