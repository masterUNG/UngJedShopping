import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ungjedshopping/models/product_model.dart';
import 'package:ungjedshopping/models/user_model.dart';
import 'package:ungjedshopping/states/list_product_shoper.dart';
import 'package:ungjedshopping/utility/my_calculate.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/widgets/show_banner.dart';
import 'package:ungjedshopping/widgets/show_progress.dart';
import 'package:ungjedshopping/widgets/show_text.dart';
import 'package:ungjedshopping/widgets/show_title.dart';

class ShoppingMallBuyer extends StatefulWidget {
  const ShoppingMallBuyer({Key? key}) : super(key: key);

  @override
  State<ShoppingMallBuyer> createState() => _ShoppingMallBuyerState();
}

class _ShoppingMallBuyerState extends State<ShoppingMallBuyer> {
  var userShopModels = <UserModel>[];
  var productModels = <ProductModel>[];
  var listUrlPictures = <List<String>>[];
  bool load = true;

  @override
  void initState() {
    super.initState();
    readAllShop();
    readAllProduct();
  }

  Future<void> readAllProduct() async {
    String pathReadAllProduct =
        'http://www.program2me.com/api/ungapi/productAllShop.php';
    await Dio().get(pathReadAllProduct).then((value) {
      for (var element in value.data) {
        ProductModel productModel = ProductModel.fromMap(element);
        productModels.add(productModel);
        var urlPictures =
            MyCalculate().changeStringToArray(string: productModel.picture);
        listUrlPictures.add(urlPictures);
      }
      setState(() {});
    });
  }

  Future<void> readAllShop() async {
    String pathRaddAllShop =
        'http://www.program2me.com/api/ungapi/getAllShoper.php';
    await Dio().get(pathRaddAllShop).then((value) {
      for (var element in value.data) {
        UserModel userModel = UserModel.fromMap(element);
        userShopModels.add(userModel);
        print('## urlPicture ==> ${userModel.Picture}');
      }
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      return ListView(
        children: [
          ShowBanner(urlBanners: MyConstant.urlBanners),
          const ShowTitle(
            title: 'Shoper :',
          ),
          listAllShop(boxConstraints),
          const ShowTitle(title: 'New Product :'),
          productModels.isEmpty
              ? SizedBox(
                  width: boxConstraints.maxWidth,
                  height: boxConstraints.maxWidth * 0.5,
                  child: const ShowProgress(),
                )
              : listAllProduct(boxConstraints),
        ],
      );
    });
  }

  Widget listAllShop(BoxConstraints boxConstraints) {
    return load
        ? SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxWidth * 0.5,
            child: const ShowProgress(),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: userShopModels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) => InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListProductShoper(
                            userShopModel: userShopModels[index]),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: boxConstraints.maxWidth * 0.3 - 25,
                          height: boxConstraints.maxWidth * 0.3 - 25,
                          child: Image.network(
                            userShopModels[index].Picture,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ShowText(
                          label: userShopModels[index].Name,
                          textStyle: MyConstant().h3ActiveStyle(),
                        ),
                      ],
                    ),
                  ),
                ));
  }

  Widget listAllProduct(BoxConstraints boxConstraints) {
    return load
        ? SizedBox(
            width: boxConstraints.maxWidth,
            height: boxConstraints.maxWidth * 0.5,
            child: const ShowProgress(),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: productModels.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) => Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: boxConstraints.maxWidth * 0.3 - 25,
                        height: boxConstraints.maxWidth * 0.3 - 25,
                        child: Image.network(
                          listUrlPictures[index][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      ShowText(
                        label: productModels[index].name,
                        textStyle: MyConstant().h3ActiveStyle(),
                      ),
                    ],
                  ),
                ));
  }
}
