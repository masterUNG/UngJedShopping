import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungjedshopping/states/authen.dart';
import 'package:ungjedshopping/states/buyer_service.dart';
import 'package:ungjedshopping/states/create_account.dart';
import 'package:ungjedshopping/states/rider_service.dart';
import 'package:ungjedshopping/states/shopper_service.dart';
import 'package:ungjedshopping/utility/my_constant.dart';

final Map<String, WidgetBuilder> map = {
  MyConstant.routeAuthen: (context) => const Authen(),
  MyConstant.routeCreateAccount: (context) => const CreateAccount(),
  MyConstant.routeBuyer: (context) => const BuyerService(),
  MyConstant.routeShopper: (context) => const ShopperService(),
  MyConstant.routeRider: (context) => const RiderService(),
};

String? firstState;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? typeUser = preferences.getString(MyConstant.keyTypeUser);
    print('typeUser ==> $typeUser');
    if (typeUser?.isEmpty ?? true) {
      firstState = MyConstant.routeAuthen;
      runApp(const MyApp());
    } else {
      switch (typeUser) {
        case 'Buyer':
          firstState = MyConstant.routeBuyer;
          runApp(const MyApp());
          break;
        case 'Shoper':
          firstState = MyConstant.routeShopper;
          runApp(const MyApp());
          break;
        case 'Rider':
          firstState = MyConstant.routeRider;
          runApp(const MyApp());
          break;
        default:
      }
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      routes: map,
      initialRoute: firstState,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
