import 'package:anonymous/models/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';



class MenuItems{

 static List<MenuItem> firstItemsMenu=[
    shareItem,
    EditProfileItem

  ];
static  List<MenuItem> SecondItemsMenu=[
    signOutItem
  ];


static  const MenuItem EditProfileItem=  MenuItem(
       itemName: 'Edit  Profile',
       itemIcon:  Icons.settings,
);

static const MenuItem shareItem=  MenuItem(
       itemName: 'Share Link',
       itemIcon: Icons.share,);

static const MenuItem signOutItem=  MenuItem(
       itemName: 'Sign Out',
       itemIcon: Icons.logout_sharp,);

}