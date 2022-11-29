import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/support/colors.dart';

import 'image_picker_provider.dart';

class ImagePicker extends StatefulWidget {
  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends BaseState<ImagePicker> {
  ImagePickerProvider? _imagePickerProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _imagePickerProvider =
          Provider.of<ImagePickerProvider>(context, listen: false);    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Selector<ImagePickerProvider, File>(
              builder: (context, data, child) {
                return data == null ? SizedBox() : Image.file(data);
              },
              selector: (context, data) => data.selectedImage,
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: MyColors.kPrimaryColor,
              ),
              onPressed: () => _imagePickerProvider!.selectImage(),
              child: Text("Image Picker"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onSuccess(any, {int? reqId}) {
    // TODO: implement onSuccess
    super.onSuccess(any,reqId: 0);
  }
}
