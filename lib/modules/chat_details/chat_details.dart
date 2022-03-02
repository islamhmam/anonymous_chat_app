// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anonymous/models/user_model.dart';

import '../../models/message_model.dart';
import 'chat_detail_cubit/chat_detail_cubit.dart';
import 'chat_detail_cubit/chat_detail_state.dart';

class ChatDetails extends StatelessWidget {
  UserModel userModel;

  ChatDetails(this.userModel);

  var messageController = TextEditingController();
   ScrollController listController = ScrollController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     create: (context) => ChatDetailsCubit()..getMessage(receiverId: userModel.uid),
      child: BlocConsumer<ChatDetailsCubit, ChatDetailsStates>(
          listener: (context, state) {

          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundImage: CachedNetworkImageProvider(
                          '${userModel.imageUrl}'),
                    ),
                    SizedBox(width: 5,),
                    Text('${userModel.name}',

                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        controller: listController,
                        itemBuilder: (context, index) {
                          var message = ChatDetailsCubit.get(context).messages[index];
                          if(ChatDetailsCubit.get(context).userId == message.senderId)
                            return buildMyMessage(message);

                          return buildMessage(message);
                        } ,
                        separatorBuilder: (context, index) => SizedBox(height: 10,),
                        itemCount: ChatDetailsCubit.get(context).messages.length,
                      ),
                    ),
                    // buildMessage(),
                    // buildMyMessage(),
                    // Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(22),

                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(children: [

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: TextFormField(
                              controller: messageController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Your Message...'
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          color: Colors.blueAccent,
                          child: MaterialButton(
                            minWidth: 1,
                            onPressed: () {
                              ChatDetailsCubit.get(context).sendMessag(
                                  receiverId: userModel.uid!,
                                  text: messageController.text,
                                  dateTime: DateTime.now().toString());
                              messageController.clear();
                              ChatDetailsCubit.get(context).scrollDown(listController);

                            },
                            child: Icon(Icons.send,
                              color: Colors.white,

                            ),
                          ),
                        ),

                      ],),
                    ),


                  ],
                ),
              ),

            );
          },

        ),


    );
  } //build


  Widget buildMyMessage(MessageModel message) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 3,
              left: 15,
              right: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10),
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
              ),
              color: Colors.grey[300],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:CrossAxisAlignment.end,

              children: [

                Text('${message.text}',
                style: TextStyle(
                  // fontWeight: FontWeight.w400,
                      fontSize: 16
                ),
                ),
                SizedBox(height: 1,),

                Row(
                  children: [
                    Icon(Icons.check_circle,
                    size: 15,
                      color: Colors.grey,
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                )
              ],
            )),
      );


  Widget buildMessage(MessageModel message) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                // bottomEnd: Radius.circular(10),
                topEnd: Radius.circular(10),
                topStart: Radius.circular(10),
                bottomStart: Radius.circular(10),
              ),
              color: Colors.blue[900],

            ),
            child: Text('${message.text}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white
              ),
            )
        ),
      );


}
