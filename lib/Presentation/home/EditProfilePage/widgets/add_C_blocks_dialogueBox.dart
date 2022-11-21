import 'dart:developer';
import 'dart:io';

import 'package:dropili/Presentation/home/EditProfilePage/bloc/editProfileScreen_bloc.dart';
import 'package:dropili/Presentation/home/EditProfilePage/widgets/icon_container.dart';
import 'package:dropili/common/constant/colors.dart';
import 'package:dropili/common/extensions/translation_extension.dart';
import 'package:dropili/data/models/get_blocks_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCustomBlocksDialog extends StatefulWidget {
  const AddCustomBlocksDialog();

  @override
  _AddCustomBlocksDialogState createState() => _AddCustomBlocksDialogState();
}

class _AddCustomBlocksDialogState extends State<AddCustomBlocksDialog> {
  bool success = false;

  _AddCustomBlocksDialogState();

  @override
  Widget build(BuildContext context) {
    Future<void> pickImage() async {
      BlocProvider.of<EditProfileBloc>(context).add(GetCostumeBlockImage());
    }
    String titlear='' , titlefr='' , url='';
    return BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) async {},
        child: BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.only(left: 10, top: 50, right: 10, bottom: 50),
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              left: 10, top: 50, right: 10, bottom: 0),
                          margin: EdgeInsets.only(top: 40),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, right: 5, left: 5),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) {
                                        titlear = value;
                                      },
                                      decoration:
                                          buildInputDecoration('Name ar'),
                                    ),
                                    SizedBox(height: 5),
                                    TextFormField(
                                      onChanged: (value) {
                                        titlefr = value;
                                      },
                                      decoration:
                                          buildInputDecoration('Name fr'),
                                    ),
                                    SizedBox(height: 5),
                                    TextFormField(
                                      onChanged: (value) {
                                        url = value;
                                      },
                                      decoration: buildInputDecoration('Url'),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'.t(context)),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        BlocProvider.of<EditProfileBloc>(
                                                context)
                                            .add(PostCostumeBlock(url: url , titleAr: titlear , titleFr: titlefr, icon: state.addCostumeBlockImgPath ));
                                      },
                                      child: Text('Save'.t(context)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                pickImage().then((value) {
                                  success = true;
                                });
                                log('hi');
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(50, 0, 0, 0),
                                      offset: Offset(0.0, 5.0),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: success
                                      ? Image.file(
                                          File(state.addCostumeBlockImgPath),
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/dropili_app_logo.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }
}

contentBox(context) {}
InputDecoration buildInputDecoration(String text) {
  return InputDecoration(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Color.fromARGB(50, 166, 166, 166),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(7),
      borderSide: BorderSide.none,
    ),
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    labelText: text,
    floatingLabelBehavior: FloatingLabelBehavior.never,
  );
}