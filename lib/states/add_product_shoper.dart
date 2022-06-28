// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/utility/my_dialog.dart';
import 'package:ungjedshopping/widgets/show_button.dart';
import 'package:ungjedshopping/widgets/show_form.dart';
import 'package:ungjedshopping/widgets/show_icon_button.dart';
import 'package:ungjedshopping/widgets/show_image.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class AddProductShoper extends StatefulWidget {
  final String shopCode;
  const AddProductShoper({
    Key? key,
    required this.shopCode,
  }) : super(key: key);

  @override
  State<AddProductShoper> createState() => _AddProductShoperState();
}

class _AddProductShoperState extends State<AddProductShoper> {
  String? shopCode, nameProduct, qty, unit, price;
  var clickSmallImages = <bool>[];
  var files = <File?>[];
  File? file;

  @override
  void initState() {
    super.initState();
    shopCode = widget.shopCode;

    for (var i = 0; i < 4; i++) {
      clickSmallImages.add(true);
      //true ==> no image
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: newAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
          child: ListView(
            children: [
              newImage(constraints),
              newCenter(
                constraints: constraints,
                widget: ShowForm(
                  label: 'Name Product :',
                  iconData: Icons.production_quantity_limits,
                  changeFunc: (String string) {
                    nameProduct = string.trim();
                  },
                ),
              ),
              newCenter(
                  constraints: constraints,
                  widget: SizedBox(
                    width: constraints.maxWidth * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShowForm(
                          textInputType: TextInputType.number,
                          width: constraints.maxWidth * 0.6 * 0.5,
                          label: 'QTY',
                          iconData: Icons.pie_chart,
                          changeFunc: (String string) {
                            qty = string.trim();
                          },
                        ),
                        ShowForm(
                          width: constraints.maxWidth * 0.6 * 0.5,
                          label: 'Unit',
                          iconData: Icons.ice_skating,
                          changeFunc: (String string) {
                            unit = string.trim();
                          },
                        ),
                      ],
                    ),
                  )),
              newCenter(
                constraints: constraints,
                widget: ShowForm(
                  textInputType: TextInputType.number,
                  label: 'Price :',
                  iconData: Icons.money,
                  changeFunc: (String string) {
                    price = string.trim();
                  },
                ),
              ),
              newCenter(
                constraints: constraints,
                widget: ShowButton(
                  label: 'Add New Product',
                  pressFunc: () {
                    if (file == null) {
                      MyDialog(context: context).normalDialog(
                          title: 'No Photo ?', subTitle: 'Please Take Photo');
                    } else {
                      if ((nameProduct?.isEmpty ?? true) ||
                          (qty?.isEmpty ?? true) ||
                          (unit?.isEmpty ?? true) ||
                          (price?.isEmpty ?? true)) {
                        MyDialog(context: context).normalDialog(
                            title: 'Have Space ?',
                            subTitle: 'Please Fill Every Blank');
                      } else {
                        processUploadAndInsert();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row newCenter({required BoxConstraints constraints, required Widget widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.75,
          child: widget,
        ),
      ],
    );
  }

  Row newImage(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          height: constraints.maxWidth * 0.7,
          width: constraints.maxWidth * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.5,
                height: constraints.maxWidth * 0.5,
                child: file == null
                    ? const ShowImage(
                        path: 'images/image.png',
                      )
                    : Image.file(file!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  smallImage(indexClick: 0),
                  smallImage(indexClick: 1),
                  smallImage(indexClick: 2),
                  smallImage(indexClick: 3),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  GestureDetector smallImage({required int indexClick}) {
    return GestureDetector(
      onTap: () {
        print('click ==> $indexClick');

        if (clickSmallImages[indexClick]) {
          // Take Photo
          MyDialog(context: context).normalDialog(
              label: 'Camera',
              pressFunc: () {
                Navigator.pop(context);
                processTakePhoto(
                    source: ImageSource.camera, indexClick: indexClick);
              },
              label2: 'Gallery',
              pressFunc2: () {
                Navigator.pop(context);
                processTakePhoto(
                    source: ImageSource.gallery, indexClick: indexClick);
              },
              title: 'Take Photo ${indexClick + 1} ?',
              subTitle: 'Please Tap Camera or Gallery');
        } else {
          // Show Photo
          file = files[indexClick];
          setState(() {});
        }
      },
      child: SizedBox(
        width: 48,
        height: 48,
        child: files[indexClick] == null
            ? const ShowImage(
                path: 'images/image.png',
              )
            : Padding(
                padding: const EdgeInsets.all(2),
                child: Image.file(
                  files[indexClick]!,
                  fit: BoxFit.cover,
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

  Future<void> processTakePhoto(
      {required ImageSource source, required int indexClick}) async {
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (result != null) {
      file = File(result.path);
      files[indexClick] = file;
      clickSmallImages[indexClick] = false;
      setState(() {});
    }
  }

  Future<void> processUploadAndInsert() async {
    String path = 'http://www.program2me.com/api/ungapi/saveProduct.php';
    int index = 0;
    var urlImages = <String>[];
    for (var element in files) {
      if (element != null) {
        String nameImage = '$shopCode${Random().nextInt(1000000)}.jpg';
        Map<String, dynamic> map = {};
        map['file'] = await MultipartFile.fromFile(files[index]!.path,
            filename: nameImage);
        FormData formData = FormData.fromMap(map);
        await Dio().post(path, data: formData).then((value) {
          String urlImage =
              'http://www.program2me.com/api/ungapi/product/$nameImage';
          urlImages.add(urlImage);
        });
      }

      index++;
    }
    print('urlImages ==>> $urlImages');
  }
}
