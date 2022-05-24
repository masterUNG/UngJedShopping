import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungjedshopping/models/user_model.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/utility/my_dialog.dart';
import 'package:ungjedshopping/widgets/show_button.dart';
import 'package:ungjedshopping/widgets/show_form.dart';
import 'package:ungjedshopping/widgets/show_image.dart';
import 'package:ungjedshopping/widgets/show_text.dart';
import 'package:ungjedshopping/widgets/show_text_button.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  State<Authen> createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  String? user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: Container(
          decoration: MyConstant().mainBG(),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            newLogo(),
                            newTextLogin(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  formUser(),
                  formPassword(),
                  buttonLogin(),
                  newCreateAccount(context: context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row newCreateAccount({required BuildContext context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ShowText(label: 'No Account ? '),
        ShowTextButton(
            label: 'Create Account',
            pressFunc: () {
              Navigator.pushNamed(context, MyConstant.routeCreateAccount);
            }),
      ],
    );
  }

  ShowButton buttonLogin() => ShowButton(
        label: 'Login',
        pressFunc: () {
          if ((user?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            MyDialog(context: context).normalDialog(
                title: 'Have Space ?', subTitle: 'Please Fill Every Blank');
          } else {
            checkAuthen();
          }
        },
      );

  Future<void> checkAuthen() async {
    String urlCheckAuthen =
        'http://www.program2me.com/api/ungapi/getUserWhereUser.php?user=$user';
    await Dio().get(urlCheckAuthen).then((value) {
      if (value.toString() == 'null') {
        MyDialog(context: context).normalDialog(
            title: 'User False ?', subTitle: 'No $user in my Database');
      } else {
        for (var element in value.data) {
          UserModel userModel = UserModel.fromMap(element);

          print('userModel ==> ${userModel.toMap()}');

          if (password == userModel.Password) {
            processSaveUser(userModel: userModel);

            switch (userModel.Usertype) {
              case 'Buyer':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeBuyer, (route) => false);
                break;
              case 'Shoper':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeShopper, (route) => false);
                break;
              case 'Rider':
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeRider, (route) => false);
                break;
              default:
            }
          } else {
            MyDialog(context: context).normalDialog(
                title: 'Password False ?',
                subTitle: 'Please TryAgain Password False');
          }
        }
      }
    });
  }

  Future<void> processSaveUser({required UserModel userModel}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MyConstant.keyUser, userModel.Code);
    preferences.setString(MyConstant.keyTypeUser, userModel.Usertype);
  }

  ShowForm formPassword() {
    return ShowForm(
      obsecu: true,
      label: 'Password :',
      iconData: Icons.lock_outline,
      changeFunc: (String string) {
        password = string.trim();
      },
    );
  }

  ShowForm formUser() {
    return ShowForm(
      label: 'User :',
      iconData: Icons.perm_identity,
      changeFunc: (String string) {
        user = string.trim();
      },
    );
  }

  ShowText newTextLogin() => ShowText(
        label: 'Login :',
        textStyle: MyConstant().h1Style(),
      );

  SizedBox newLogo() {
    return SizedBox(
      width: 80,
      child: ShowImage(),
    );
  }
}
