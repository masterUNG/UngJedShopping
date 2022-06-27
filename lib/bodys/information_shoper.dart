import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ungjedshopping/models/user_model.dart';
import 'package:ungjedshopping/states/edit_information.dart';
import 'package:ungjedshopping/utility/my_api.dart';
import 'package:ungjedshopping/utility/my_constant.dart';
import 'package:ungjedshopping/widgets/show_button.dart';
import 'package:ungjedshopping/widgets/show_image_internet.dart';
import 'package:ungjedshopping/widgets/show_progress.dart';
import 'package:ungjedshopping/widgets/show_text.dart';

class InformationShoper extends StatefulWidget {
  const InformationShoper({Key? key}) : super(key: key);

  @override
  State<InformationShoper> createState() => _InformationShoperState();
}

class _InformationShoperState extends State<InformationShoper> {
  UserModel? userModel;
  bool load = true;

  @override
  void initState() {
    super.initState();
    processFindUserModel();
  }

  Future<void> processFindUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString(MyConstant.keyUser);

    await MyApi().findUserModel(user: user!).then((value) {
      userModel = value;
      load = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints boxConstraints) {
            return Stack(
              children: [
                ListView(
                  children: [
                    showValue(head: 'Name :', value: userModel!.Name),
                    showValue(head: 'Address :', value: userModel!.Address),
                    showValue(head: 'Telephone :', value: userModel!.Telephone),
                    SizedBox(
                      width: boxConstraints.maxWidth * 0.75,
                      height: boxConstraints.maxWidth * 0.75,
                      child: ShowImageInternet(path: userModel!.Picture),
                    ),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: boxConstraints.maxWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShowButton(
                            label: 'Edit Information',
                            pressFunc: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditInformation(userModel: userModel!),
                                  )).then((value) {
                                load = true;
                                processFindUserModel();
                                setState(() {});
                              });
                            },
                          ),
                        ],
                      ),
                    )),
              ],
            );
          });
  }

  Padding showValue({required String head, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ShowText(
              label: head,
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 2,
            child: ShowText(label: value),
          ),
        ],
      ),
    );
  }
}
