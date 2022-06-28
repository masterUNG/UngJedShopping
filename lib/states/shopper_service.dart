// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungjedshopping/bodys/information_shoper.dart';
import 'package:ungjedshopping/bodys/order_shoper.dart';
import 'package:ungjedshopping/models/user_model.dart';
import 'package:ungjedshopping/utility/my_api.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/widgets/show_icon_button.dart';
import 'package:ungjedshopping/widgets/show_image_avatar.dart';
import 'package:ungjedshopping/widgets/show_image_internet.dart';
import 'package:ungjedshopping/widgets/show_menu.dart';
import 'package:ungjedshopping/widgets/show_sign_out.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class ShopperService extends StatefulWidget {
  const ShopperService({Key? key}) : super(key: key);

  @override
  State<ShopperService> createState() => _ShopperServiceState();
}

class _ShopperServiceState extends State<ShopperService> {
  UserModel? userModel;
  var bodys = <Widget>[
    const OrderShoper(),
    const InformationShoper(),
  ];

  var titles = <String>[
    'My Order',
    'Information',
  ];

  int indexBody = 0;

  final scaffordKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    processFindUserModel();
  }

  Future<void> processFindUserModel() async {
    print('processFindUserModel Work');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString(MyConstant.keyUser);

    print('user ==> $user');

    userModel = await MyApi().findUserModel(user: user!);
    if (userModel != null) {
      print('picture ==> ${userModel!.Picture}');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffordKey,
      appBar: AppBar(
        leading: ShowIconButton(
          iconData: Icons.menu,
          pressFunc: () {
            processFindUserModel();
            scaffordKey.currentState!.openDrawer();
          },
        ),
        title: ShowText(
          label: titles[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
        foregroundColor: MyConstant.dark,
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
      drawer: newDrawer(),
      body: bodys[indexBody],
    );
  }

  Drawer newDrawer() {
    return Drawer(
      child: Column(
        children: [
          newHeadDrawer(),
          ShowMenu(
            iconData: Icons.shopping_bag_outlined,
            title: 'My Order',
            pressFunc: () {
              Navigator.pop(context);
              setState(() {
                indexBody = 0;
              });
            },
            subTitle: 'Order Wait Approve or Cancel',
          ),
          Divider(
            color: MyConstant.dark,
          ),
          ShowMenu(
            iconData: Icons.shop_2,
            title: 'Information',
            pressFunc: () {
              Navigator.pop(context);
              setState(() {
                indexBody = 1;
              });
            },
            subTitle: 'Detail Shop',
          ),
          Divider(
            color: MyConstant.dark,
          ),
          const Spacer(),
          const ShowSignOut(),
        ],
      ),
    );
  }

  UserAccountsDrawerHeader newHeadDrawer() => UserAccountsDrawerHeader(
        currentAccountPicture: userModel == null
            ? const SizedBox()
            : SizedBox(
                width: 80,
                height: 80,
                child: ShowImageAvatar(path: userModel!.Picture),
              ),
        decoration: BoxDecoration(color: MyConstant.light),
        accountName: userModel == null
            ? ShowText(
                label: 'Name = ? ',
                textStyle: MyConstant().h2Style(),
              )
            : ShowText(
                label: userModel!.Name,
                textStyle: MyConstant().h2Style(),
              ),
        accountEmail: const ShowText(label: 'Shoper'),
      );
}
