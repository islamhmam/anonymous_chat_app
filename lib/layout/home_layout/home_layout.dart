// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:anonymous/layout/home_layout/cubit/home_cubit.dart';
import 'package:anonymous/models/menu_item.dart';
import 'package:anonymous/modules/choose_style/choose_style_screen.dart';
import 'package:anonymous/modules/menu/menu_items.dart';
import 'package:anonymous/shared/components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

import '../../models/user_model.dart';
import '../../modules/chat_details/chat_details.dart';
import '../../shared/constants.dart';
import 'cubit/home_states.dart';


class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {


  var reportController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDynamicLinks();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..getChatUsers()..getAllUsers(),
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Anonymous Chat'),
                actions: [
                  PopupMenuButton<MenuItem>(
                    onSelected: (item) => onSelected(context,item) ,
                    itemBuilder: (context) =>[
                      ...MenuItems.firstItemsMenu.map(buildItem).toList(),
                      PopupMenuDivider(),
                      ...MenuItems.SecondItemsMenu.map(buildItem).toList(),
                    ],
                  ),
                ],
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
                           chatUsers(context,HomeCubit.get(context).chatUsers),


                ],
              ) ,


            ),
          );






        },
      ),
    )  ;
  }


  Widget randomUsers(context , List<UserModel> users)=>  RefreshIndicator(
    onRefresh: () async{
      HomeCubit.get(context).getAllOneUsers();
      return await Future.delayed(Duration(seconds: 2));
    },
    child: ConditionalBuilder(
      condition:
    users.length > 0
      ,
      fallback:(context) => Center(

        child:SingleChildScrollView(
          physics:BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) ,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 30,right: 30,bottom: 20),
              child: Expanded(child: Text('Refresh By Sliding Down',
                overflow: TextOverflow.ellipsis, // default is .clip
                maxLines: 4,
              )),
            ),
            height: MediaQuery.of(context).size.height,

          ),


        ),




      ) ,
      builder: (context) => ListView.separated(
            physics:  BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
      // shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildLastChatItem(users[index],context);
          },
          separatorBuilder:(context, index) => myDivider(),
          itemCount: users.length
      ) ,


    ),
  );

  Widget chatUsers(context , List<UserModel> users)=>  RefreshIndicator(
    onRefresh: () async{
      HomeCubit.get(context).getChatUsers();
      return await Future.delayed(Duration(seconds: 2));



    },
    child: ConditionalBuilder(
      condition:
    users.length > 0
      ,
      fallback:(context) => Center(

        child:SingleChildScrollView(
            physics:BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()) ,
            child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 30,right: 30,bottom: 20),
                  child: Expanded(child: Text('Send New Message to any User then Refresh By Sliding Down.',
                    overflow: TextOverflow.ellipsis, // default is .clip
                    maxLines: 4,
                  )),
                ),
                 height: MediaQuery.of(context).size.height,

            ),


        ),




      ) ,

      builder: (context) => ListView.separated(
        physics:  BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
      // shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildLastChatItem(users[index],context,);
          },
          separatorBuilder:(context, index) => myDivider(),
          itemCount: users.length
      ) ,


    ),
  );




  Widget buildLastChatItem(UserModel model ,BuildContext context1, ) =>InkWell(
    onTap: (){
      navigateTo(context: context1, widget: ChatDetails(model));
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        CircleAvatar(
          radius: 25,
          backgroundImage:  CachedNetworkImageProvider('${model.imageUrl}'),

        ),
        SizedBox(width: 20,),
        Expanded(
          child: Text('${model.name}',
            style: Theme.of(context1).textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        PopupMenuButton(
          shape: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2
              ),
            borderRadius: BorderRadius.circular(30),
          ),
          color: Colors.redAccent[100],
          icon: Icon(Icons.menu,
          color: Colors.red[900],
              size: 30),
            itemBuilder:(context){
              List<MenuItem> menu =MenuItems.userMenu;
            return menu.map((MenuItem menuItem){
              return PopupMenuItem(
                  child: ListTile(
                    leading: Icon(menuItem.itemIcon),
                    title: Text('${menuItem.itemName}'),
                  ),
                  value: menuItem.value,
              );
            }).toList();
            },
          onSelected: (value){

            switch(value) {
              case 1: {
                showDialog(
                    context: context1,
                    builder: (context1) =>BlocProvider(
                      create: (context1) => HomeCubit(),
                      child: BlocConsumer<HomeCubit,HomeStates>(
                        listener: (context1, state) {
                        },
                        builder:(context1, state){
                          return AlertDialog(
                            title: Text('Confirm Deleting?'),
                            content: Text('This Will Delete All Message For Sender and Receiver!',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,

                            ),
                            actions: [
                              MaterialButton(
                                onPressed: (){


                                  HomeCubit.get(context1).deleteChatItem( model);

                                  Fluttertoast.showToast(msg: 'Refresh the Page After Delete');

                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                              MaterialButton(

                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                            ],
                          );
                        } ,

                      ),
                    )
                );
              }
              break;

              case 2: {
                showDialog(
                    context: context1,
                    builder: (context1) =>BlocProvider(
                      create: (context1) => HomeCubit(),
                      child: BlocConsumer<HomeCubit,HomeStates>(
                        listener: (context1, state) {
                        },
                        builder:(context1, state){
                          return AlertDialog(
                            title: Text('Describe Violation?'),
                            content: TextField(
                              controller: reportController,
                              minLines: 1,
                              maxLines: 10,

                            ),
                            actions: [

                              MaterialButton(
                                onPressed: (){


                                  HomeCubit.get(context1).blockUser( model);

                                  Fluttertoast.showToast(msg: 'Refresh the Page After Block');

                                  Navigator.of(context).pop();
                                },
                                child: Text('Block',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                              MaterialButton(
                                onPressed: (){


                                  HomeCubit.get(context1).deleteChatItem( model);

                                  Fluttertoast.showToast(msg: 'Refresh the Page After Delete');

                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete Chat',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                              MaterialButton(
                                onPressed: (){
                                  HomeCubit.get(context1).reportViolation( model, reportController.text.toString());
                                  Fluttertoast.showToast(msg: 'Report Send');

                                  Navigator.of(context).pop();
                                },
                                child: Text('Report',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),

                            ],
                          );
                        } ,

                      ),
                    )
                );              }
              break;
              case 3: {
                showDialog(
                    context: context1,
                    builder: (context1) =>BlocProvider(
                      create: (context1) => HomeCubit(),
                      child: BlocConsumer<HomeCubit,HomeStates>(
                        listener: (context1, state) {
                        },
                        builder:(context1, state){
                          return AlertDialog(
                            title: Text('Confirm Block?'),
                            content: Text('Confirm Block!',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,

                            ),
                            actions: [
                              MaterialButton(
                                onPressed: (){


                                  HomeCubit.get(context1).blockUser( model);
//
                                  Fluttertoast.showToast(msg: 'Refresh the Page After Block');

                                  Navigator.of(context).pop();
                                },
                                child: Text('Confirm',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                              MaterialButton(

                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blueAccent,
                              ),
                            ],
                          );
                        } ,

                      ),
                    )
                );            }
            break;


            }

          },
            ),






      ],),
    ),
  );

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem(
      value: item,
      child: Row(
        children: [
          Icon(item.itemIcon , color: Colors.black,size: 30,),
          SizedBox(width: 5,),
          Text(item.itemName!,style: TextStyle(
            fontWeight: FontWeight.w500
          ),),

        ],
      ),
  );

 void onSelected(BuildContext context, MenuItem item) {
        switch(item){
          case MenuItems.EditProfileItem :
            navigateTo(context: context , widget: ChooseStyleScreen() );
            break;
          case MenuItems.shareItem:
            buildDynamicLinks(uid);
            break;
          case MenuItems.signOutItem:
            signOut(context);
            break;

        }
  }

  void initDynamicLinks() async{
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink)async{
          final Uri? deeplink = dynamicLink!.link;

          if(deeplink != null){

            handleMyLink(deeplink);
          }
        },
        onError: (OnLinkErrorException e)async{
          print("We got error $e");

        }

    );
  }


  void handleMyLink(Uri url){
    List<String> seperatedLink = [];
    /// osama.link.page/Hellow --> osama.link.page and Hellow
    seperatedLink.addAll(url.path.split('/'));

    print("The Token that i'm interesed in is ${seperatedLink[1]}");
    FirebaseFirestore.instance
        .collection('users')
        .doc(seperatedLink[1])
        .get().then((value) {
     UserModel userModel= UserModel.fromJson(value.data()!);
     if(uid != seperatedLink[1]) {
       navigateTo(context: context, widget: ChatDetails(userModel));
     }else{
       Fluttertoast.showToast(msg: 'You Cant Chat To Your Self \n Click on Other Invitation');

     }


    }).catchError((error){
      Fluttertoast.showToast(msg: error.toString());
    });



    // Get.to(()=>ProductDetailScreen(sepeatedLink[1]));

  }

  buildDynamicLinks(String userId) async {
    String url = "https://anonymouschat.page.link";
    print('dynamic link user id is :__________ ${userId}');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$userId'),
      androidParameters: AndroidParameters(
        packageName: "com.studentguide.anonymous",
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: "Bundle-ID",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: '',
          imageUrl:
          Uri.parse("https://firebasestorage.googleapis.com/v0/b/chat-me-app-be3e1.appspot.com/o/icons%26photos%2Flogo.png?alt=media&token=6caf359f-43ca-459d-ad25-bbf36f0d78d2"),
          title: 'Anonymous Chat Invitation'),
    );


    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();

    String? desc = '${dynamicUrl.shortUrl.toString()}';

    await Share.share(desc, subject: 'Anonymous Chat Invitation',);

  }









}
