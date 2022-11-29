import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/add_event_screen/opponent_screen/add_opponent_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';

class OpponentAddScreen extends StatefulWidget {
  @override
  _OpponentAddScreenState createState() => _OpponentAddScreenState();
}

class _OpponentAddScreenState extends BaseState<OpponentAddScreen> {
  //region Private Members
  final _formKey = GlobalKey<FormState>();
  String? imgFilePath;
  String imageB64 = "";
  List<int>? imageBytes;
  AddOpponentProvider? _addOpponentProvider;
  static Future<List<int>> _resizeImage(List<int> bytes) async {
    // final bytes = await file.readAsBytes();
    final img.Image image = img.decodeImage(bytes);
    final img.Image resized = img.copyResize(image, width: 300);
    final List<int> resizedBytes = img.encodeJpg(resized, quality: 10);

    return resizedBytes;
  }
  //endregion

  @override
  void initState() {
    super.initState();
    _addOpponentProvider =
        Provider.of<AddOpponentProvider>(context, listen: false);
    _addOpponentProvider!.initialProvider();
    _addOpponentProvider!.listener = this;
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.ADD_OPPONENT:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          Navigator.of(context).pop();

          Navigation.navigateTo(context, MyRoutes.opponentListviewScreen);
        } else if (_response.responseResult == Constants.failed) {
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
          //print("400");
        } else {
          /* CodeSnippet.instance.showMsg(_response.errorMessage);
          print("else");*/
        }
        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  /*
Return Type:
Input Parameters:
Use: Validate user inputs and Send opponent details to the server.
 */
  void _addOpponent() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _addOpponentProvider!.addOpponentAsync(imageBytes!);
    }
  }

  selectFileAsync() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowCompression: true,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      if(kIsWeb){
        List<int> resizedBytes = await compute<List<int>, List<int>>(_resizeImage,file.bytes );
        setState(() {
          imageBytes=resizedBytes;
        });
      } else {
       // File imageFile = File(file.path);
        /* Uint8List imageRaw = await imageFile.readAsBytes();
      print(imageRaw);*/
        if( !Device.get().isTablet) {
          File? croppedFile = await ImageCropper().cropImage(
              sourcePath: file.path,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
              androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Cropper',
                  toolbarColor: MyColors.kPrimaryColor,
                  toolbarWidgetColor: Colors.white,
                  activeControlsWidgetColor: MyColors.kPrimaryColor,
                  initAspectRatio: CropAspectRatioPreset.original,
                  lockAspectRatio: false),
              iosUiSettings: IOSUiSettings(
                minimumAspectRatio: 1.0,
              )
          );
          imageBytes = await testCompressFile(croppedFile!);
        }else{
          File imageFile = File(file.path);
          imageBytes = await testCompressFile(imageFile);
        }setState(() {
          imgFilePath = file.path;
          imageB64 = base64Encode(imageBytes!);
          print(imageB64);
          Uint8List decoded = base64Decode(imageB64);
          print(decoded);
        });
      }
    } else {
      // User canceled the picker
    }
  }
//  compress file and get Uint8List
  Future<Uint8List> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 400,
      minHeight: 400,
      quality: 10,
    );
    print(file.lengthSync());
    print(result!.length);
    return result;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TopBar(
        child: WebCard(
          marginVertical: 20,
          marginhorizontal: 40,
          child: Scaffold(
            backgroundColor: MyColors.white,
            appBar: CustomAppBar(
              title: MyStrings.opponent,
              iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
              iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
              onClickLeftImage: () {
                Navigator.of(context).pop();
                Navigation.navigateTo(context, MyRoutes.opponentListviewScreen);
              },
              onClickRightImage: () {
                _addOpponent();
              },
            ),
            body: Consumer<AddOpponentProvider>(builder: (context, provider, _) {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      width: size.width,
                      constraints: BoxConstraints(minHeight: size.height - 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            /* margin: EdgeInsets.symmetric(
                                vertical: MarginSize.headerMarginVertical3,
                                horizontal: MarginSize.headerMarginVertical3),*/
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: SizedBox(
                                  //height: 680,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        PaddingSize.headerPadding1),
                                    child: Column(
                                      /*mainAxisAlignment: !isMobile(context)
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                          crossAxisAlignment: !isMobile(context)
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,*/
                                      children: <Widget>[
                                        // if (isMobile(context))
                                        SizedBox(
                                            height: SizedBoxSize
                                                .headerSizedBoxHeight),
                                        Stack(
                                          children: [
                                            imageBytes != null?
                                            CircleAvatar(

                                              backgroundImage:MemoryImage(Uint8List.fromList(imageBytes!)) ,                    // Image.file(new File(imgFilePath)),                                                        //backgroundImage: NetworkImage(MyImages.spaid),
                                            backgroundColor:
                                                MyColors.kPrimaryLightColor,
                                            radius: Consts.avatarRadius,
                                          ):CircleAvatar(

                                              backgroundImage:AssetImage(
                                                MyImages.noImageData,
                                              ),// Image.file(new File(imgFilePath)),                      // Image.file(new File(imgFilePath)),                                                        //backgroundImage: NetworkImage(MyImages.spaid),
                                              backgroundColor:
                                              MyColors.kPrimaryLightColor,
                                              radius: Consts.avatarRadius,
                                            ),
                                          Positioned(
                                            left: Dimens.standard_90 ,
                                            top:Dimens.standard_100 ,
                                            right: Consts.padding,
                                            child: PopupMenuButton<int>(
                                              tooltip:
                                                  MyStrings.imageTooltip,
                                              icon: Icon(
                                                Icons.camera_alt,
                                                size: 30,
                                                color: MyColors.black,
                                              ),
                                              onSelected: (value) {
                                                if (value == 1) {
                                                  selectFileAsync();
                                                }
                                                if (value == 2) {
                                                  setState(() {
                                                    imageBytes = null;
                                                  });
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Text(MyStrings
                                                      .imageTooltipUpload),
                                                ),
                                                if(imageBytes != null)
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Text(MyStrings
                                                      .imageTooltipRemove),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              SizedBoxSize.checkSizedBoxWidth),
                                      CustomizeTextFormField(
                                        labelText: MyStrings.opponentName+"*",
                                        prefixIcon: MyIcons.username,
                                        isEnabled: true,
                                        inputFormatter: [new LengthLimitingTextInputFormatter(50),],
                                        controller: provider.opponentNameController,
                                        validator: ValidateInput.requiredFields,
                                        onSave: (value) {
                                          provider.opponentNameController!.text=value!;
                                        },
                                      ),
                                      SizedBox(
                                          height: SizedBoxSize
                                              .headerSizedBoxHeight),
                                      CustomizeTextFormField(
                                        labelText: MyStrings.contactName+"*",
                                        prefixIcon: MyIcons.username,
                                        isEnabled: true,
                                        inputFormatter: [new LengthLimitingTextInputFormatter(25),],
                                        controller: provider.contactNameController,
                                        validator: ValidateInput.requiredFields,
                                        onSave: (value) {
                                          provider.contactNameController!.text=value!;
                                        },
                                      ),
                                      SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                                      CustomizeTextFormField(
                                        labelText: MyStrings.contactPhone+"*",
                                        keyboardType: TextInputType.number,
                                        prefixIcon: MyIcons.username,
                                        hintText: MyStrings.noFormat,
                                        inputFormatter: [new LengthLimitingTextInputFormatter(10),],
                                        isEnabled: true,
                                        controller: provider.phoneNameController,
                                        validator: ValidateInput.requiredFields,
                                        onSave: (value) {
                                          provider.phoneNameController!.text=value!;
                                        },
                                      ),
                                      SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                                      CustomizeTextFormField(
                                        labelText: MyStrings.contactEmail+"*",
                                        prefixIcon: MyIcons.mail,
                                        isEnabled: true,
                                        inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                        keyboardType: TextInputType.emailAddress,
                                        validator: ValidateInput.requiredFields,
                                        controller: provider.contactEmailController,
                                        onSave: (value) {
                                          provider.contactEmailController!.text=value!;
                                        },
                                      ),
                                      SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                                      CustomizeTextFormField(
                                        labelText: MyStrings.notes,
                                        prefixIcon: MyIcons.message,
                                        /*maxLines: FontSize.textMaxLine,
                                        minLines: FontSize.textMinLine,*/
                                        controller: provider.noteController,
                                        isEnabled: true,
                                        inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                        onSave: (value) {
                                          provider.noteController!.text=value!;
                                        },
                                      ),
                                      SizedBox(height: SizedBoxSize.headerSizedBoxHeight),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
