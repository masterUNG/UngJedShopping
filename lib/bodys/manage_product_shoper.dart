import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungjedshopping/models/product_model.dart';
import 'package:ungjedshopping/states/add_product_shoper.dart';
import 'package:ungjedshopping/states/edit_product_shoper.dart';
import 'package:ungjedshopping/utility/my_calculate.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/utility/my_dialog.dart';
import 'package:ungjedshopping/widgets/show_button.dart';
import 'package:ungjedshopping/widgets/show_icon_button.dart';
import 'package:ungjedshopping/widgets/show_progress.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class ManageProductShoper extends StatefulWidget {
  const ManageProductShoper({Key? key}) : super(key: key);

  @override
  State<ManageProductShoper> createState() => _ManageProductShoperState();
}

class _ManageProductShoperState extends State<ManageProductShoper> {
  String? shopCode;
  bool load = true;
  bool? haveData;
  var productModels = <ProductModel>[];
  var listUrlImages = <List<String>>[];

  @override
  void initState() {
    super.initState();
    readMyProduct();
  }

  Future<void> readMyProduct() async {
    if (productModels.isNotEmpty) {
      productModels.clear();
      listUrlImages.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    shopCode = preferences.getString(MyConstant.keyUser);

    String pathGetProduct =
        'http://www.program2me.com/api/ungapi/getAllProduct.php?shopcode=$shopCode';
    await Dio().get(pathGetProduct).then((value) {
      print('value getMyProduct ====>> $value');

      if (value.toString() == 'null') {
        haveData = false;
      } else {
        haveData = true;

        for (var element in value.data) {
          ProductModel productModel = ProductModel.fromMap(element);
          productModels.add(productModel);

          var urlImages =
              MyCalculate().changeStringToArray(string: productModel.picture);
          print('urlImage ======>> $urlImages');
          listUrlImages.add(urlImages);
        }
      }

      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints boxConstraints) {
      return SizedBox(
        width: boxConstraints.maxWidth,
        height: boxConstraints.maxHeight,
        child: Stack(
          children: [
            load
                ? const ShowProgress()
                : haveData!
                    ? SizedBox(
                        width: boxConstraints.maxWidth,
                        height: boxConstraints.maxHeight - 66,
                        child: listProduct(boxConstraints),
                      )
                    : Center(
                        child: ShowText(
                          label: 'No Product',
                          textStyle: MyConstant().h1Style(),
                        ),
                      ),
            Positioned(
              bottom: 0,
              child: buttonAddNewProduct(boxConstraints: boxConstraints),
            ),
          ],
        ),
      );
    });
  }

  ListView listProduct(BoxConstraints boxConstraints) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            SizedBox(
              width: boxConstraints.maxWidth * 0.5 - 4,
              height: boxConstraints.maxWidth * 0.4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Image.network(
                  listUrlImages[index][0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: boxConstraints.maxWidth * 0.5 - 4,
              height: boxConstraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowText(
                    label: productModels[index].name,
                    textStyle: MyConstant().h2Style(),
                  ),
                  ShowText(
                      label:
                          'Price : ${productModels[index].price} thb/${productModels[index].unit}'),
                  ShowText(
                      label:
                          'QTY : ${productModels[index].qty} ${productModels[index].unit}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShowIconButton(
                        color: const Color.fromARGB(255, 17, 125, 21),
                        iconData: Icons.edit_outlined,
                        pressFunc: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProducShoper(
                                    productModel: productModels[index]),
                              )).then((value) => null);
                        },
                      ),
                      ShowIconButton(
                        color: const Color.fromARGB(255, 226, 34, 20),
                        iconData: Icons.delete_forever_outlined,
                        pressFunc: () {
                          MyDialog(context: context).normalDialog(
                              label: 'Confirm Dalete',
                              pressFunc: () async {
                                Navigator.pop(context);

                                print(
                                    'delete id ====> ${productModels[index].id}');
                                String pathDeleteProduct =
                                    'http://www.program2me.com/api/ungapi/productDeleteWhereId.php?id=${productModels[index].id}';
                                await Dio()
                                    .get(pathDeleteProduct)
                                    .then((value) {
                                  load = true;
                                  readMyProduct();
                                  setState(() {});
                                });
                              },
                              label2: 'Cancel',
                              pressFunc2: () {
                                Navigator.pop(context);
                              },
                              title: 'Confirm Delete ?',
                              subTitle:
                                  'Are You Sure Delete ${productModels[index].name} ?');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buttonAddNewProduct({required BoxConstraints boxConstraints}) {
    return SizedBox(
      width: boxConstraints.maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowButton(
            label: 'Add New Product',
            pressFunc: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddProductShoper(shopCode: shopCode!),
                  )).then((value) {
                load = true;
                readMyProduct();
                setState(() {});
              });
            },
          ),
        ],
      ),
    );
  }
}
