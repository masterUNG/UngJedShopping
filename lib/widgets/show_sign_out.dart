import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/utility/my_dialog.dart';
import 'package:ungjedshopping/widgets/show_menu.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowMenu(
      iconData: Icons.exit_to_app,
      title: 'Sign Out',
      pressFunc: () {
        MyDialog(context: context).normalDialog(
            title: 'Sign Out ?',
            subTitle: 'Are You Sure !!',
            label: 'Sign Out',
            pressFunc: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.clear().then((value) {
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeAuthen, (route) => false);
              });
            });
      },
      subTitle: 'SignOut Move to Authen',
    );
  }
}
