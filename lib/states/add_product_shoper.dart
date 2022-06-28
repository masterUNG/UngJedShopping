// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/widgets/show_icon_button.dart';
import 'package:ungjedshopping/widgets/show_image.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class AddProductShoper extends StatelessWidget {
  final String shopCode;
  const AddProductShoper({
    Key? key,
    required this.shopCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: constraints.maxWidth * 0.6,
          width: constraints.maxWidth * 0.6,
          child: ShowImage(
            path: 'images/image.png',
          ),
        ),
      ),
    );
  }

  AppBar newAppBar() {
    return AppBar(
      actions: [ShowIconButton(iconData: Icons.add_box, pressFunc: () {})],
      title: ShowText(
        label: 'Add New Product',
        textStyle: MyConstant().h2Style(),
      ),
      foregroundColor: MyConstant.dark,
      flexibleSpace: Container(
        decoration: MyConstant().mainAppBar(),
      ),
    );
  }
}
