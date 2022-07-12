// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ungjedshopping/models/user_model.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class ListProductShoper extends StatefulWidget {
  final UserModel userShopModel;
  const ListProductShoper({
    Key? key,
    required this.userShopModel,
  }) : super(key: key);

  @override
  State<ListProductShoper> createState() => _ListProductShoperState();
}

class _ListProductShoperState extends State<ListProductShoper> {
  UserModel? userShopModel;

  @override
  void initState() {
    super.initState();
    userShopModel = widget.userShopModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ShowText(
          label: userShopModel!.Name,
          textStyle: MyConstant().h2Style(),
        ),
        foregroundColor: MyConstant.dark,
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
    );
  }
}
