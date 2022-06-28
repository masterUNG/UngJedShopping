import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungjedshopping/states/add_product_shoper.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/widgets/show_button.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class ManageProductShoper extends StatefulWidget {
  const ManageProductShoper({Key? key}) : super(key: key);

  @override
  State<ManageProductShoper> createState() => _ManageProductShoperState();
}

class _ManageProductShoperState extends State<ManageProductShoper> {
  String? shopCode;

  @override
  void initState() {
    super.initState();
    readMyProduct();
  }

  Future<void> readMyProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopCode = preferences.getString(MyConstant.keyUser);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowText(label: 'This is Manage Product'),
        Spacer(),
        buttonAddNewProduct(),
      ],
    );
  }

  Row buttonAddNewProduct() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowButton(
          label: 'Add New Product',
          pressFunc: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddProductShoper(shopCode: shopCode!),));
          },
        ),
      ],
    );
  }
}
