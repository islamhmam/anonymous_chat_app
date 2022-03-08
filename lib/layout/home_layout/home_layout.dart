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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDynamicLinks();
  }

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
                           randomUsers(context,HomeCubit.get(context).chatUsers),


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
      await HomeCubit.get(context).getChatUsers();
    },
    child: ConditionalBuilder(
      condition:
    users.length > 0
      ,
      fallback:(context) => Center(child: CircularProgressIndicator(),) ,
      builder: (context) => ListView.separated(
        physics:  BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
      // shrinkWrap: true,
          itemBuilder: (context, index) {
            return buildChatItem(users[index],context);
          },
          separatorBuilder:(context, index) => myDivider(),
          itemCount: users.length
      ) ,


    ),
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
     navigateTo(context: context, widget: ChatDetails(userModel));
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
          Uri.parse("https://firebasestorage.googleapis.com/v0/b/chat-me-app-be3e1.appspot.com/o/icons%26photos%2F5377826.png?alt=media&token=491a9400-4133-4b9d-8053-2acd9de6f0ae"),
          title: 'Anonymous Chat Invitation'),
    );


    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();

    String? desc = '${dynamicUrl.shortUrl.toString()}';

    await Share.share(desc, subject: 'Anonymous Chat Invitation',);

  }







}
