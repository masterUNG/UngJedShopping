import 'package:flutter/material.dart';

class MyConstant {
  static var urlBanners = <String>[
    'http://www.program2me.com/api/ungapi/banner/banner1.png',
    'http://www.program2me.com/api/ungapi/banner/banner2.png',
    'http://www.program2me.com/api/ungapi/banner/banner3.png',
  ];

  static var typeUsers = <String>[
    'Buyer',
    'Shoper',
    'Rider',
  ];

  static String keyUser = 'user';
  static String keyTypeUser = 'typeUser';

  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyer = '/buyerService';
  static String routeShopper = '/shopperService';
  static String routeRider = '/riderService';

  static Color primary = const Color(0xffadd500);
  static Color dark = const Color(0xff133c29);
  static Color light = Color.fromARGB(255, 227, 234, 198);

  BoxDecoration mainAppBar() => BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[MyConstant.light, MyConstant.primary],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      );

  BoxDecoration mainBG() => BoxDecoration(
        gradient: RadialGradient(
            colors: <Color>[Colors.white, MyConstant.primary],
            radius: 1.5,
            center: const Alignment(-0.5, -0.4)),
      );

  TextStyle h1Style() => TextStyle(
        color: dark,
        fontSize: 48,
        fontWeight: FontWeight.bold,
      );

  TextStyle h2Style() => TextStyle(
        color: dark,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      );

  TextStyle h3Style() => TextStyle(
        color: dark,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  TextStyle h3ActiveStyle() => const TextStyle(
        color: Colors.pink,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      );
}
