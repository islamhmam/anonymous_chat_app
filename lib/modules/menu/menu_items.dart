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
static  List<MenuItem> UserPolicysMenu=[
    userPolicy
  ];

static  List<MenuItem> userMenu=[
  removeChat,
  reportViolation,
  blockUser
  ];


static  const MenuItem EditProfileItem=  MenuItem(
       itemName: 'Edit  Profile',
       itemIcon:  Icons.settings,
);

static const MenuItem shareItem=  MenuItem(
       itemName: 'Share Private Chat Link',
       itemIcon: Icons.share,);

static const MenuItem signOutItem=  MenuItem(
       itemName: 'Sign Out',
       itemIcon: Icons.logout_sharp,);
static const MenuItem userPolicy=  MenuItem(
       itemName: 'User Policy',
       itemIcon: Icons.supervised_user_circle,);





static const MenuItem blockUser=  MenuItem(
       itemName: 'Block',
       itemIcon: Icons.block,
        value: 3,
);
static const MenuItem reportViolation=  MenuItem(
       itemName: 'Report violation',
       itemIcon: Icons.report,
        value: 2,
);
static const MenuItem removeChat=  MenuItem(
       itemName: 'Remove Chat',
       itemIcon: Icons.delete_forever_rounded,
        value: 1,
  );

}