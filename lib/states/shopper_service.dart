import 'package:flutter/material.dart';
import 'package:ungjedshopping/widgets/show_sign_out.dart';

class ShopperService extends StatelessWidget {
  const ShopperService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(child: Column(
        children: [
          UserAccountsDrawerHeader(accountName: null, accountEmail: null),
          const Spacer(),
          ShowSignOut(),
        ],
      ),),
    );
  }
}
