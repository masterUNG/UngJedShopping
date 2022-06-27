// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ungjedshopping/models/user_model.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/utility/my_dialog.dart';
import 'package:ungjedshopping/widgets/show_button.dart';
import 'package:ungjedshopping/widgets/show_form.dart';
import 'package:ungjedshopping/widgets/show_icon_button.dart';
import 'package:ungjedshopping/widgets/show_image_internet.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class EditInformation extends StatefulWidget {
  final UserModel userModel;
  const EditInformation({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<EditInformation> createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  File? file;
  bool change = false; // false => non Change All

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    nameController.text = userModel!.Name;
    addressController.text = userModel!.Address;
    telephoneController.text = userModel!.Telephone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShowText(
          label: 'Edit Information',
          textStyle: MyConstant().h2Style(),
        ),
        foregroundColor: MyConstant.dark,
        flexibleSpace: Container(
          decoration: MyConstant().mainAppBar(),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusScopeNode()),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
          return Stack(
            children: [
              ListView(
                children: [
                  newImage(boxConstraints),
                  formName(),
                  formAddress(),
                  formTelephone(),
                ],
              ),
              buttonEdit(boxConstraints),
            ],
          );
        }),
      ),
    );
  }

  Positioned buttonEdit(BoxConstraints boxConstraints) {
    return Positioned(
      bottom: 0,
      child: SizedBox(
        width: boxConstraints.maxWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShowButton(
              label: 'Edit Information',
              pressFunc: () {
                if (change) {
                  print('Have Change');
                } else {
                  MyDialog(context: context).normalDialog(
                      title: 'Non Change ?',
                      subTitle:
                          'Please Change Image, Name, Address or Telephone');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Row newImage(BoxConstraints boxConstraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            SizedBox(
              width: boxConstraints.maxWidth * 0.75,
              height: boxConstraints.maxWidth * 0.75,
              child: file == null
                  ? ShowImageInternet(path: userModel!.Picture)
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        file!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ShowIconButton(
                iconData: Icons.add_a_photo,
                pressFunc: () {
                  MyDialog(context: context).normalDialog(
                      label2: 'Gallery',
                      pressFunc2: () {
                        Navigator.pop(context);
                        processTakePhoto(source: ImageSource.gallery);
                      },
                      label: 'Camera',
                      pressFunc: () {
                        Navigator.pop(context);
                        processTakePhoto(source: ImageSource.camera);
                      },
                      title: 'Take Photo ?',
                      subTitle: 'Please Take Photo by tab Camera or Gallery');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> processTakePhoto({required ImageSource source}) async {
    var result = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );
    file = File(result!.path);
    change = true;
    setState(() {});
  }

  Row formTelephone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowForm(
          textEditingController: telephoneController,
          label: 'Telephone :',
          iconData: Icons.phone,
          changeFunc: (String string) {
            change = true;
          },
        ),
      ],
    );
  }

  Row formAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowForm(
          textEditingController: addressController,
          label: 'Address :',
          iconData: Icons.home_outlined,
          changeFunc: (String string) {
            change = true;
          },
        ),
      ],
    );
  }

  Row formName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowForm(
          textEditingController: nameController,
          label: 'Name :',
          iconData: Icons.fingerprint,
          changeFunc: (String string) {
            change = true;
          },
        ),
      ],
    );
  }
}
