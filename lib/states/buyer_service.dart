import 'package:flutter/material.dart';
import 'package:ungjedshopping/bodys/my_order_buyer.dart';
import 'package:ungjedshopping/bodys/shopping_mall_buyer.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/widgets/show_menu.dart';
import 'package:ungjedshopping/widgets/show_sign_out.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  State<BuyerService> createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  var titles = <String>[
    'Shopping Mall',
    'My Order',
  ];

  var bodys = <Widget>[
    const ShoppingMallBuyer(),
    const MyOrderBuyer(),
  ];

  int indexBody = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        foregroundColor: MyConstant.dark,
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
        title: ShowText(
          label: titles[indexBody],
          textStyle: MyConstant().h2Style(),
        ),
      ),
      drawer: newDrawer(context),
      body: bodys[indexBody],
    );
  }

  Drawer newDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: MyConstant().mainBG(),
            accountName: null,
            accountEmail: null,
          ),
          ShowMenu(
            iconData: Icons.shopping_cart,
            title: titles[0],
            subTitle: 'Shopping State, All Shop, All Product',
            pressFunc: () {
              Navigator.pop(context);
              indexBody = 0;
              setState(() {});
            },
          ),
          Divider(
            color: MyConstant.dark,
          ),
          ShowMenu(
            iconData: Icons.production_quantity_limits,
            title: titles[1],
            subTitle: 'Order, Receive, History',
            pressFunc: () {
              Navigator.pop(context);
              indexBody = 1;
              setState(() {});
            },
          ),
          Divider(
            color: MyConstant.dark,
          ),
          const Spacer(),
          Divider(
            color: MyConstant.dark,
          ),
          ShowSignOut()
        ],
      ),
    );
  }
}
