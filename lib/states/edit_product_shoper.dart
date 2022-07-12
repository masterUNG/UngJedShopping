// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ungjedshopping/models/product_model.dart';
import 'package:ungjedshopping/utility/my_calculate.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/utility/my_dialog.dart';
import 'package:ungjedshopping/widgets/show_button.dart';
import 'package:ungjedshopping/widgets/show_form.dart';
import 'package:ungjedshopping/widgets/show_icon_button.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class EditProducShoper extends StatefulWidget {
  final ProductModel productModel;
  const EditProducShoper({
    Key? key,
    required this.productModel,
  }) : super(key: key);

  @override
  State<EditProducShoper> createState() => _EditProducShoperState();
}

class _EditProducShoperState extends State<EditProducShoper> {
  ProductModel? productModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  var urlImages = <String>[];
  var files = <File?>[];

  bool change = false; // true ==> Have Change
  String? name, qty, unit, price;

  @override
  void initState() {
    super.initState();
    productModel = widget.productModel;
    nameController.text = productModel!.name;
    qtyController.text = productModel!.qty;
    unitController.text = productModel!.unit;
    priceController.text = productModel!.price;

    name = productModel!.name;
    qty = productModel!.qty;
    unit = productModel!.unit;
    price = productModel!.price;

    urlImages =
        MyCalculate().changeStringToArray(string: productModel!.picture);

    for (var i = 0; i < urlImages.length; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints boxConstraints) {
        return ListView(
          children: [
            formName(),
            formQtyUnit(),
            formPrice(),
            const SizedBox(
              height: 16,
            ),
            listImage(boxConstraints),
            urlImages.length == 4 ? const SizedBox() : iconAddPicture(),
            const SizedBox(
              height: 16,
            ),
            buttonEditProduct(),
            const SizedBox(
              height: 16,
            ),
          ],
        );
      }),
    );
  }

  Row buttonEditProduct() => createCenter(
        widget: ShowButton(
          label: 'Edit Product',
          pressFunc: () {
            if (change) {
              processUploadAndEditData();
            } else {
              MyDialog(context: context).normalDialog(
                  title: 'No Change ?', subTitle: 'Please Edit Something');
            }
          },
        ),
      );

  Future<void> processUploadAndEditData() async {
    for (var i = 0; i < files.length; i++) {
      if (files[i] != null) {
        String nameFile = 'imageEdit${Random().nextInt(1000000)}.jpg';
        Map<String, dynamic> map = {};
        map['file'] = await MultipartFile.fromFile(files[i]!.path, filename: nameFile);
        String pathAPI = 'http://www.program2me.com/api/ungapi/saveProduct.php';
        FormData formData = FormData.fromMap(map);
        await Dio().post(pathAPI, data: formData).then((value) async {
          String urlImage =
              'http://www.program2me.com/api/ungapi/product/$nameFile';
          urlImages[i] = urlImage;
        });
      }
    }

    String pathApiEditProduct =
        'http://www.program2me.com/api/ungapi/ProductEditWhereId.php?id=${productModel!.id}&name=$name&unit=$unit&price=$price&qty=$qty&picture=${urlImages.toString()}';

    print('## pathAPIedit ===>>> $pathApiEditProduct');

    await Dio().get(pathApiEditProduct).then((value) {
      Navigator.pop(context);
    });
  }

  Row iconAddPicture() {
    return createCenter(
        widget: SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShowIconButton(
            size: 48,
            color: const Color.fromARGB(255, 18, 112, 188),
            iconData: Icons.add_box_outlined,
            pressFunc: () {
              MyDialog(context: context).normalDialog(
                  label: 'Camera',
                  pressFunc: () {
                    Navigator.pop(context);
                    processAddMorePicture(source: ImageSource.camera);
                  },
                  label2: 'Gallery',
                  pressFunc2: () {
                    Navigator.pop(context);
                    processAddMorePicture(source: ImageSource.gallery);
                  },
                  title: 'Source Image ?',
                  subTitle: 'Please Tap Camera or Gallery');
            },
          ),
        ],
      ),
    ));
  }

  Future<void> processAddMorePicture({required ImageSource source}) async {
    change = true;
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (result != null) {
      urlImages.add('');
      files.add(null);
      int index = files.length - 1;
      files[index] = File(result.path);
      setState(() {});
    }
  }

  ListView listImage(BoxConstraints boxConstraints) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: urlImages.length,
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: boxConstraints.maxWidth * 0.75,
            height: boxConstraints.maxWidth * 0.75,
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: boxConstraints.maxWidth * 0.75,
                  height: boxConstraints.maxWidth * 0.75,
                  child: files[index] == null
                      ? Image.network(
                          urlImages[index],
                        )
                      : Image.file(files[index]!),
                ),
                Container(
                  width: boxConstraints.maxWidth * 0.3,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.75)),
                  child: Row(
                    children: [
                      ShowIconButton(
                        color: const Color.fromARGB(255, 89, 225, 93),
                        iconData: Icons.edit_outlined,
                        pressFunc: () {
                          MyDialog(context: context).normalDialog(
                              label: 'Camera',
                              pressFunc: () {
                                Navigator.pop(context);
                                processTakePhoto(
                                    source: ImageSource.camera, index: index);
                              },
                              label2: 'Gallery',
                              pressFunc2: () {
                                Navigator.pop(context);
                                processTakePhoto(
                                    source: ImageSource.gallery, index: index);
                              },
                              title: 'Source Image ?',
                              subTitle: 'Please Tap Camera or Gallery');
                        },
                      ),
                      urlImages.length == 1
                          ? const SizedBox()
                          : ShowIconButton(
                              color: const Color.fromARGB(255, 228, 57, 45),
                              iconData: Icons.delete_forever,
                              pressFunc: () {
                                MyDialog(context: context).normalDialog(
                                    label: 'Confirm',
                                    pressFunc: () {
                                      change = true;
                                      Navigator.pop(context);
                                      print(
                                          'urlImages Before delete ==> $urlImages');
                                      print('delete image index ==>> $index');

                                      urlImages.removeAt(index);
                                      files.removeAt(index);

                                      print(
                                          'urlImages Alter delete ==> $urlImages');

                                      setState(() {});
                                    },
                                    label2: 'Cancel',
                                    pressFunc2: () {
                                      Navigator.pop(context);
                                    },
                                    title: 'Confirm Delete ?',
                                    subTitle: 'Are You Sure Delete Image ?');
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row formPrice() {
    return createCenter(
      widget: ShowForm(
        textEditingController: priceController,
        label: 'Price :',
        iconData: Icons.money,
        changeFunc: (String string) {
          price = string.trim();
          change = true;
        },
      ),
    );
  }

  Row formQtyUnit() {
    return createCenter(
      widget: SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShowForm(
              textEditingController: qtyController,
              width: 120,
              label: 'QTY',
              iconData: Icons.android,
              changeFunc: (String string) {
                qty = string;
                change = true;
              },
            ),
            ShowForm(
              textEditingController: unitController,
              width: 120,
              label: 'Unit',
              iconData: Icons.ac_unit,
              changeFunc: (String string) {
                unit = string.trim();
                change = true;
              },
            ),
          ],
        ),
      ),
    );
  }

  Row formName() {
    return createCenter(
        widget: ShowForm(
      textEditingController: nameController,
      label: 'Name :',
      iconData: Icons.fingerprint,
      changeFunc: (String string) {
        name = string.trim();
        change = true;
      },
    ));
  }

  Row createCenter({required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        widget,
      ],
    );
  }

  AppBar newAppBar() {
    return AppBar(
      title: ShowText(
        label: 'Edit Product',
        textStyle: MyConstant().h2Style(),
      ),
      foregroundColor: MyConstant.dark,
      flexibleSpace: Container(
        decoration: MyConstant().mainAppBar(),
      ),
    );
  }

  Future<void> processTakePhoto(
      {required ImageSource source, required int index}) async {
    change = true;
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    files[index] = File(result!.path);
    setState(() {});
  }
}
