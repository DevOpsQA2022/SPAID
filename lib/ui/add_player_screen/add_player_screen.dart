import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/add_player_response/add_existing_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/service/firebase_dynamic_link_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'add_player_screen_provider.dart';

class AddPlayerScreen extends StatefulWidget {
  var contact;

  AddPlayerScreen(this.contact);

  @override
  _AddPlayerScreenState createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends BaseState<AddPlayerScreen> {
  //region Private Members
  AddPlayerProvider? _addplayerProvider;
  String? gender, _genderchosenName;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  int count = 0;
  FocusNode _node = new FocusNode();
  FocusNode _notenode = new FocusNode();
  bool _webDatePicker = false;
  DateTime _selectedDate = DateTime.now();
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String? dateformat, first;
  TextEditingController DatepickerController = TextEditingController();
  List<int>? imageBytes;
  String? imgFilePath;
  String imageB64 = "";
  int? userID, teamIDNo;
  String? teamName, userName, fcm, userEmail;
  RoasterListViewProvider? _roasterListViewProvider;
  AddExistingPlayerResponse? _addExistingPlayer;
  bool isMemberExist = false;
  ScrollController _scrollController = ScrollController();
  ScrollController _controllerOne = ScrollController();

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
    getCountryCodeAsyncs();

    super.initState();
    _addplayerProvider = Provider.of<AddPlayerProvider>(context, listen: false);

    _addplayerProvider!.initialProvider();
    _addplayerProvider!.listener = this;
    _roasterListViewProvider =
        Provider.of<RoasterListViewProvider>(context, listen: false);
    _roasterListViewProvider!.listener = this;
    Future.delayed(Duration.zero, () {
      print(widget.contact);
      if (kIsWeb) {
        _addplayerProvider!.firstNameController!.text =
        widget.contact[1] != null ? widget.contact[1] : "";
        _addplayerProvider!.emailController!.text =
        widget.contact[3] != null ? widget.contact[3] : "";

        try {
          print((int.parse(widget.contact[2].toString())));
          _addplayerProvider!.contactPhoneController!.text =
          widget.contact[2].toString() != null
              ? widget.contact[2].toString()
              : "";
        } catch (e) {
          print(e);
        }
      } else {
        if (widget.contact != null) {
          _addplayerProvider!.firstNameController!.text =
          widget.contact.displayName != null
              ? widget.contact.displayName
              : "";
          _addplayerProvider!.DatePickerController!.text =
          widget.contact.birthday.toString() != "null"
              ? widget.contact.birthday.toString()
              : "";
          if (widget.contact.emails.length > 0)
            _addplayerProvider!.emailController!.text =
            widget.contact.emails.first.value != null
                ? widget.contact.emails.first.value
                : "";
          if (widget.contact.phones.length > 0)
            _addplayerProvider!.contactPhoneController!.text =
            widget.contact.phones.first.value != null
                ? widget.contact.phones.first.value
                : "";
        }
      }
    });
  }

  /*
Return Type:
Input Parameters:
Use: Validate user inputs and Send Player data to server.
 */
  void _addPlayer() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Internet.checkInternet().then((value) {
        if (value) {
          _roasterListViewProvider!
              .getExistingPlayer(_addplayerProvider!.emailController!.text);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressBar.instance.showProgressbar(context);
          });
          // if (!_addplayerProvider.isManager &&
          //     !_addplayerProvider.isNonPlayer) {
          //   _addplayerProvider.AddPlayerAsync(imageBytes, Constants.teamPlayer);
          // }
          // if (_addplayerProvider.isManager && !_addplayerProvider.isNonPlayer) {
          //   _addplayerProvider.AddPlayerAsync(
          //       imageBytes, Constants.coachorManager);
          // }
          // if (_addplayerProvider.isNonPlayer && !_addplayerProvider.isManager) {
          //   _addplayerProvider.AddPlayerAsync(imageBytes, Constants.nonPlayer);
          // }
          // if (_addplayerProvider.isNonPlayer && _addplayerProvider.isManager) {
          //   _addplayerProvider.AddPlayerAsync(
          //       imageBytes, Constants.coachorManager);
          // }
        } else {
          CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
        }
      });
    } else {
      if (_addplayerProvider!.firstNameController!.text.isEmpty) {
        _scrollController.jumpTo(0);
        //CodeSnippet.instance.showMsg(ValidateInput.requiredFieldsFirstName(_addplayerProvider.firstNameController.text));
      } else if (_addplayerProvider!.lastNameController!.text.isEmpty) {
        _scrollController.jumpTo(0);
        // CodeSnippet.instance.showMsg(ValidateInput.requiredFieldsLastName(_addplayerProvider.lastNameController.text));
      } else if (ValidateInput.verifyDOB(
          _addplayerProvider!.DatePickerController!.text) !=
          null) {
        _scrollController.jumpTo(0);
        //CodeSnippet.instance.showMsg(ValidateInput.verifyDOB(_addplayerProvider.DatePickerController.text));
      } else if (ValidateInput.validateEmail(
          _addplayerProvider!.emailController!.text) !=
          null) {
        _scrollController.jumpTo(700);
        //CodeSnippet.instance.showMsg(ValidateInput.validateEmail(_addplayerProvider.emailController.text));
      }
    }
  }

  /*Widget addFamilyList() {
    return  ListView.builder(
            itemCount: count,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return AddFamilyListCard();
            });
  }*/
  @override
  Future<void> onSuccess(any, {int? reqId}) async {
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.ADD_PLAYER_SCREEN:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          var response = _response.responseMessage!.split(",");

          DynamicLinksService()
              .createDynamicLink("create_Password_Screen?userid=" +
              response.first +
              "&teamid=" +
              teamIDNo.toString() +
              "&email=" +
              _addplayerProvider!.emailController!.text +
              "&userRoleId=" +
              response.last +
              "&team=" +
              teamName! +
              "&player=" +
              _addplayerProvider!.firstNameController!.text +
              "&manager=" +
              userName! +
              "&fcm=" +
              fcm.toString() +
              "&isMemberExist=" +
              isMemberExist.toString() +
              "&toMail=" +
              userEmail.toString() +
              "&toID=" +
              userID.toString())
              .then((acceptvalue) async {
            print(acceptvalue);
            DynamicLinksService()
                .createDynamicLink("intro_Screen?userid=" +
                response.first +
                "&teamid=" +
                teamIDNo.toString() +
                "&email=" +
                _addplayerProvider!.emailController!.text +
                "&userRoleId=" +
                response.last +
                "&team=" +
                teamName! +
                "&player=" +
                _addplayerProvider!.firstNameController!.text +
                "&manager=" +
                userName! +
                "&fcm=" +
                fcm.toString() +
                "&toMail=" +
                userEmail.toString() +
                "&toID=" +
                userID.toString())
                .then((declainvalue) {
              print(declainvalue);
              EmailService().invitePlayer(
                  "Invitation mail",
                  "Invitation",
                  Constants.teamInvite,
                  userID!,
                  int.parse(response.first),
                  teamIDNo!,
                  "You have been invited to join " + teamName!,
                  _addplayerProvider!.emailController!.text,
                  _addplayerProvider!.firstNameController!.text +
                      " " +
                      _addplayerProvider!.lastNameController!.text,
                  acceptvalue,
                  declainvalue,
                  teamName!,
                  userName!);
            });
          });

          Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 1);
        } else if (_response.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          //  CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.ADD_EXISTING_PLAYER:
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   ProgressBar.instance.showProgressbar(context);
      // });
        _addExistingPlayer = any as AddExistingPlayerResponse;
        if (_addExistingPlayer!.responseResult== Constants.success) {
          isMemberExist = true;
          CodeSnippet.instance.showMsg("Members already exist in the SPAID application, use Add from other team option to add member");
          // showPlayers();
          //Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 1);
        } else {
          isMemberExist = false;
          Internet.checkInternet().then((value) {
            if (value) {

              WidgetsBinding.instance.addPostFrameCallback((_) {
                ProgressBar.instance.showProgressbar(context);
              });
              if (!_addplayerProvider!.isManager! &&
                  !_addplayerProvider!.isNonPlayer!) {
                _addplayerProvider!.AddPlayerAsync(imageBytes??[], Constants.teamPlayer);
              }
              if (_addplayerProvider!.isManager! && !_addplayerProvider!.isNonPlayer!) {
                _addplayerProvider!.AddPlayerAsync(
                    imageBytes??[], Constants.coachorManager);
              }
              if (_addplayerProvider!.isNonPlayer! && !_addplayerProvider!.isManager!) {
                _addplayerProvider!.AddPlayerAsync(imageBytes??[], Constants.nonPlayer);
              }
              if (_addplayerProvider!.isNonPlayer! && _addplayerProvider!.isManager!) {
                _addplayerProvider!.AddPlayerAsync(
                    imageBytes??[], Constants.coachorManager);
              }
            } else {
              CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
            }
          });
          // CodeSnippet.instance.showMsg("No Results were found");
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
Return Type: bool
Input Parameters:
Use: Handle backpress action.
 */

  void _onBackPressed() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
          gifPath: MyImages.team,
          okFun: () => {
            Navigator.of(context).pop(),
            Navigation.navigateWithArgument(
                context, MyRoutes.homeScreen, 1),
          },
          cancelColor: MyColors.red,
          cancelFun: () => {Navigator.of(context).pop()},
          title: MyStrings.conformDiscardChanges,
        )) ;
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
      if (kIsWeb) {
        List<int> resizedBytes =
        await compute<List<int>, List<int>>(_resizeImage, file.bytes);
        setState(() {
          imageBytes = resizedBytes;
        });
      } else {
        //  File imageFile = File(file.path);
        /* Uint8List imageRaw = await imageFile.readAsBytes();
      print(imageRaw);*/
        if (!Device.get().isTablet) {
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
              ));
          imageBytes = await testCompressFile(croppedFile!);
        } else {
          File imageFile = File(file.path);
          imageBytes = await testCompressFile(imageFile);
        }
        print(imageBytes);
        setState(() {
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
  Future<void> getCountryCodeAsyncs() async {
    first =
    "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    userID = int.parse(
        "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
    teamIDNo = int.parse(
        "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
    teamName =
    await SharedPrefManager.instance.getStringAsync(Constants.teamName);
    userName =
    await SharedPrefManager.instance.getStringAsync(Constants.userName);
    userEmail =
    await SharedPrefManager.instance.getStringAsync(Constants.userId);
    fcm = (await SharedPrefManager.instance.getStringAsync(Constants.FCM))
        .toString();
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
        // DatepickerController.text = _selectedDate.toString();
        _addplayerProvider!.DatePickerController!
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedDate)
              : dateformat == "CA"
              ? DateFormat("yyyy/MM/dd").format(_selectedDate)
              : DateFormat("dd/MM/yyyy").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _addplayerProvider!.DatePickerController!.text.length,
              affinity: TextAffinity.upstream));

        print("ll" + _selectedDate.toString());
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
      _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
    });
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop:(){ _onBackPressed();
        return Future.value(false);
        },
        child: Scaffold(
          appBar: getValueForScreenType<bool>(
            context: context,
            mobile: false,
            tablet: true,
            desktop: true,
          )
              ? CustomSimpleAppBar(
            title: MyStrings.appName,
            iconLeft: MyIcons.backwardArrow,
            tooltipMessageLeft: MyStrings.back,
            iconRight: MyIcons.done,
            tooltipMessageRight: MyStrings.save,
            onClickRightImage: () {
              Navigator.of(context).pop();
            },
            onClickLeftImage: () {
              Navigator.of(context).pop();
            },
          )
              : null,
          body: TopBar(
            child: Row(
              children: <Widget>[
                if (getValueForScreenType<bool>(
                  context: context,
                  mobile: false,
                  tablet: true,
                  desktop: true,
                ))
                  Expanded(
                    child: Image.asset(
                      MyImages.signin,
                      height: size.height * ImageSize.signInImageSize,
                    ),
                  ),
                Expanded(
                  child: WebCard(
                    marginVertical: 20,
                    marginhorizontal: 40,
                    child: Scaffold(
                        backgroundColor: MyColors.white,
                        appBar: CustomAppBar(
                          title: MyStrings.addPlayer,
                          iconRight: MyIcons.done,
                          tooltipMessageRight: MyStrings.save,
                          iconLeft: MyIcons.cancel,
                          tooltipMessageLeft: MyStrings.cancel,
                          onClickRightImage: () {
                            _addPlayer();
                            //Navigation.navigateTo(context, MyRoutes.homeScreen);
                          },
                          onClickLeftImage: () {
                            _onBackPressed();
                          },
                        ),
                        body: SingleChildScrollView(
                          controller: _scrollController,
                          child: Consumer<AddPlayerProvider>(
                              builder: (context, provider, _) {
                                return Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: SafeArea(
                                    child: Container(
                                      width: size.width,
                                      constraints: BoxConstraints(
                                          minHeight: size.height - 30),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: getValueForScreenType<bool>(
                                              context: context,
                                              mobile: false,
                                              tablet: true,
                                              desktop: true,
                                            )
                                                ? null
                                                : EdgeInsets.symmetric(
                                                vertical: MarginSize
                                                    .headerMarginVertical1,
                                                horizontal: MarginSize
                                                    .headerMarginHorizontal1),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: getValueForScreenType<
                                                              bool>(
                                                            context: context,
                                                            mobile: false,
                                                            tablet: true,
                                                            desktop: true,
                                                          )
                                                              ? PaddingSize
                                                              .headerPadding2
                                                              : PaddingSize
                                                              .headerPadding2),
                                                      child: Column(
                                                        /*mainAxisAlignment: !isMobile(context)
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                          crossAxisAlignment: !isMobile(context)
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,*/
                                                        children: <Widget>[
                                                          // if (isMobile(context))
                                                          Padding(
                                                            padding: EdgeInsets.all(
                                                                getValueForScreenType<
                                                                    bool>(
                                                                  context: context,
                                                                  mobile: false,
                                                                  tablet: true,
                                                                  desktop: true,
                                                                )
                                                                    ? PaddingSize
                                                                    .headerPadding1
                                                                    : PaddingSize
                                                                    .headerPadding2),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: SizedBoxSize
                                                                      .standardSizedBoxHeight,
                                                                  width: SizedBoxSize
                                                                      .standardSizedBoxWidth,
                                                                ),

                                                                Stack(
                                                                  children: [
                                                                    imageBytes !=
                                                                        null
                                                                        ?CircleAvatar(
                                                                      backgroundImage:
                                                                      MemoryImage(
                                                                          Uint8List.fromList(imageBytes!)),

                                                                      // Image.file(new File(imgFilePath)),                                                        //backgroundImage: NetworkImage(MyImages.spaid),

                                                                      // Image.file(new File(imgFilePath)),
                                                                      backgroundColor:
                                                                      MyColors
                                                                          .kPrimaryLightColor,
                                                                      radius: Consts
                                                                          .avatarRadius,
                                                                    ):CircleAvatar(
                                                                      backgroundImage:
                                                                      AssetImage(
                                                                        MyImages
                                                                            .noImageData,
                                                                      ),
                                                                      // Image.file(new File(imgFilePath)),                                                        //backgroundImage: NetworkImage(MyImages.spaid),

                                                                      // Image.file(new File(imgFilePath)),
                                                                      backgroundColor:
                                                                      MyColors
                                                                          .kPrimaryLightColor,
                                                                      radius: Consts
                                                                          .avatarRadius,
                                                                    ),
                                                                    Positioned(
                                                                      left: Dimens
                                                                          .standard_90,
                                                                      top: Dimens
                                                                          .standard_100,
                                                                      right: Consts
                                                                          .padding,
                                                                      child:
                                                                      PopupMenuButton<
                                                                          int>(
                                                                        tooltip: MyStrings
                                                                            .imageTooltip,
                                                                        icon: Icon(
                                                                          Icons
                                                                              .camera_alt,
                                                                          size: 30,
                                                                          color: MyColors
                                                                              .black,
                                                                        ),
                                                                        onSelected:
                                                                            (value) {
                                                                          if (value ==
                                                                              1) {
                                                                            selectFileAsync();
                                                                          } else if (value ==
                                                                              2) {
                                                                            setState(
                                                                                    () {
                                                                                  imageBytes =
                                                                                  null;
                                                                                });
                                                                          }
                                                                        },
                                                                        itemBuilder:
                                                                            (context) =>
                                                                        [
                                                                          PopupMenuItem(
                                                                            value: 1,
                                                                            child: Text(
                                                                                MyStrings
                                                                                    .imageTooltipUpload),
                                                                          ),
                                                                          if (imageBytes !=
                                                                              null)
                                                                            PopupMenuItem(
                                                                              value: 2,
                                                                              child: Text(
                                                                                  MyStrings
                                                                                      .imageTooltipRemove),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),

                                                                SizedBox(
                                                                  height: SizedBoxSize
                                                                      .standardSizedBoxHeight,
                                                                  width: SizedBoxSize
                                                                      .standardSizedBoxWidth,
                                                                ),
                                                                Text(
                                                                  MyStrings
                                                                      .playerdetails,
                                                                  style: TextStyle(
                                                                      fontSize: getValueForScreenType<
                                                                          bool>(
                                                                        context:
                                                                        context,
                                                                        mobile: false,
                                                                        tablet: false,
                                                                        desktop: true,
                                                                      )
                                                                          ? FontSize
                                                                          .headerFontSize1
                                                                          : FontSize
                                                                          .headerFontSize3,
                                                                      fontWeight:
                                                                      FontWeights
                                                                          .headerFontWeight1),
                                                                ),
                                                                SizedBox(
                                                                  height: SizedBoxSize
                                                                      .standardSizedBoxHeight,
                                                                  width: SizedBoxSize
                                                                      .standardSizedBoxWidth,
                                                                ),
                                                                Focus(
                                                                  focusNode: _node,
                                                                  onFocusChange:
                                                                      (bool focus) {
                                                                    setState(() {
                                                                      _webDatePicker ==
                                                                          true
                                                                          ? _webDatePicker =
                                                                      false
                                                                          : _webDatePicker =
                                                                      false;
                                                                    });
                                                                  },
                                                                  child: Listener(
                                                                    onPointerDown: (_) {
                                                                      FocusScope.of(
                                                                          context)
                                                                          .requestFocus(
                                                                          _node);
                                                                    },
                                                                    child:
                                                                    CustomizeTextFormField(
                                                                      labelText: MyStrings
                                                                          .firstName +
                                                                          "*",
                                                                      controller: provider
                                                                          .firstNameController,
                                                                      inputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                      // suffixImage: MyImages.dropDown,
                                                                      isEnabled: true,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            25),
                                                                      ],
                                                                      validator:
                                                                      ValidateInput
                                                                          .requiredFieldsFirstName,
                                                                      onSave: (value) {
                                                                        provider
                                                                            .firstNameController!
                                                                            .text = value!;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizedBoxSize
                                                                      .standardSizedBoxHeight,
                                                                  width: SizedBoxSize
                                                                      .standardSizedBoxWidth,
                                                                ),
                                                                Focus(
                                                                  focusNode: _node,
                                                                  onFocusChange:
                                                                      (bool focus) {
                                                                    setState(() {
                                                                      _webDatePicker ==
                                                                          true
                                                                          ? _webDatePicker =
                                                                      false
                                                                          : _webDatePicker =
                                                                      false;
                                                                    });
                                                                  },
                                                                  child: Listener(
                                                                    onPointerDown: (_) {
                                                                      FocusScope.of(
                                                                          context)
                                                                          .requestFocus(
                                                                          _node);
                                                                    },
                                                                    child:
                                                                    CustomizeTextFormField(
                                                                      labelText: MyStrings
                                                                          .lastName +
                                                                          "*",
                                                                      controller: provider
                                                                          .lastNameController,
                                                                      // suffixImage: MyImages.dropDown,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            25),
                                                                      ],
                                                                      inputAction:
                                                                      TextInputAction
                                                                          .next,
                                                                      validator:
                                                                      ValidateInput
                                                                          .requiredFieldsLastName,
                                                                      isEnabled: true,
                                                                      onSave: (value) {
                                                                        provider
                                                                            .lastNameController!
                                                                            .text = value!;
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: SizedBoxSize
                                                                      .standardSizedBoxHeight,
                                                                  width: SizedBoxSize
                                                                      .standardSizedBoxWidth,
                                                                ),
                                                                /*DatePickerTextfieldWidget(
                                                labelText: MyStrings.dob,
                                                controller: provider.DatePickerController,
                                                validator: ValidateInput.verifyDOB,
                                                inputAction: TextInputAction.next,
                                                onSave: (value) {
                                                  provider.DatePickerController.text =
                                                      value;
                                                  // print(provider.startDateController.text);
                                                  print(value);
                                                },
                                            ),*/
                                                                // DatePickerTextfieldWidget(
                                                                //     suffixIcon: MyIcons.calendar,
                                                                //     labelText: MyStrings.dob,
                                                                //     controller: provider.DatePickerController,
                                                                //     inputAction: TextInputAction.next,
                                                                //     validator: ValidateInput.verifyDOB,
                                                                //     onTab: (){
                                                                //       setState(() {
                                                                //         _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
                                                                //       });
                                                                //     },
                                                                //     onChange: (value){
                                                                //       setState(() {
                                                                //
                                                                //       });
                                                                //     },
                                                                //     onSave: (value) {
                                                                //       provider.DatePickerController.text = value;
                                                                //       // print(provider.startDateController.text);
                                                                //
                                                                //       print(value);
                                                                //     },
                                                                // ),
                                                                // _webDatePicker == true ?   DayPickerPage(
                                                                //     selectedYear: provider.selectedYear,
                                                                //     controller: provider.DatePickerController,
                                                                // ) : SizedBox(),
                                                                DatePickerTextfieldWidget(
                                                                  suffixIcon:
                                                                  MyIcons.calendar,
                                                                  labelText:
                                                                  MyStrings.dob +
                                                                      "*",
                                                                  controller: provider
                                                                      .DatePickerController,
                                                                  inputAction:
                                                                  TextInputAction
                                                                      .next,
                                                                  validator:
                                                                  ValidateInput
                                                                      .verifyDOB,
                                                                  onTab: () {
                                                                    setState(() {
                                                                      _webDatePicker ==
                                                                          true
                                                                          ? _webDatePicker =
                                                                      false
                                                                          : _webDatePicker =
                                                                      true;
                                                                    });
                                                                  },
                                                                  onChange: (value) {
                                                                    setState(() {});
                                                                  },
                                                                  onSave: (value) {
                                                                    provider
                                                                        .DatePickerController!
                                                                        .text = value!;
                                                                    // print(provider.startDateController.text);

                                                                    print(value);
                                                                  },
                                                                ),


                                                                Stack(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height: SizedBoxSize
                                                                              .standardSizedBoxHeight,
                                                                          width: SizedBoxSize
                                                                              .standardSizedBoxWidth,
                                                                        ),
                                                                        Container(
                                                                          height: Dimens
                                                                              .standard_61,
                                                                          child: Focus(
                                                                            focusNode:
                                                                            _node,
                                                                            onFocusChange:
                                                                                (bool
                                                                            focus) {
                                                                              setState(
                                                                                      () {
                                                                                    _webDatePicker ==
                                                                                        true
                                                                                        ? _webDatePicker =
                                                                                    false
                                                                                        : _webDatePicker =
                                                                                    false;
                                                                                  });
                                                                            },
                                                                            child:
                                                                            Listener(
                                                                              onPointerHover:
                                                                                  (_) {
                                                                                setState(
                                                                                        () {
                                                                                      _webDatePicker == true
                                                                                          ? _webDatePicker = false
                                                                                          : _webDatePicker = false;
                                                                                    });
                                                                                FocusScope.of(context)
                                                                                    .requestFocus(_node);
                                                                              },
                                                                              onPointerDown:
                                                                                  (_) {
                                                                                FocusScope.of(context)
                                                                                    .requestFocus(_node);
                                                                              },
                                                                              child:
                                                                              DropdownBelow(
                                                                                boxDecoration: BoxDecoration(
                                                                                  // color: MyColors.white,
                                                                                    border: Border.all(color: MyColors.colorGray_818181)),
                                                                                itemWidth: getValueForScreenType<
                                                                                    bool>(
                                                                                  context:
                                                                                  context,
                                                                                  mobile:
                                                                                  true,
                                                                                  tablet:
                                                                                  false,
                                                                                  desktop:
                                                                                  false,
                                                                                )
                                                                                    ? size.width -
                                                                                    78
                                                                                    : getValueForScreenType<bool>(
                                                                                  context: context,
                                                                                  mobile: false,
                                                                                  tablet: true,
                                                                                  desktop: false,
                                                                                )
                                                                                    ? size.width * 0.4
                                                                                    : size.width * 0.41,
                                                                                icon: MyIcons
                                                                                    .arrowdownIos,
                                                                                itemTextstyle: TextStyle(
                                                                                    wordSpacing: 4,
                                                                                    // fontSize: 34,
                                                                                    height: WidgetCustomSize.dropdownItemHeight,
                                                                                    // fontWeight: FontWeight.w400,
                                                                                    color: MyColors.colorGray_818181),
                                                                                boxTextstyle: TextStyle(
                                                                                    decorationColor: MyColors.white,
                                                                                    //backgroundColor: MyColors.white,
                                                                                    // fontSize: 14,
                                                                                    // fontWeight: FontWeight.w400,
                                                                                    color: MyColors.colorGray_818181),
                                                                                boxPadding: EdgeInsets.fromLTRB(
                                                                                    PaddingSize.boxPaddingLeft,
                                                                                    PaddingSize.boxPaddingTop,
                                                                                    PaddingSize.boxPaddingRight,
                                                                                    PaddingSize.boxPaddingBottom),
                                                                                boxWidth:
                                                                                size.width *
                                                                                    WidgetCustomSize.dropdownBoxWidth,
                                                                                boxHeight:
                                                                                WidgetCustomSize.dropdownBoxHeight,
                                                                                hint: Text(
                                                                                    MyStrings
                                                                                        .gender,
                                                                                    style:
                                                                                    TextStyle(
                                                                                      color: MyColors.colorGray_818181,
                                                                                      fontFamily: 'OswaldLight',
                                                                                      fontSize: 16,
                                                                                      height: 1,
                                                                                    )),
                                                                                value: provider.genderController!.text.isEmpty
                                                                                    ? null
                                                                                    : provider.genderController!.text,
                                                                                items: getGender.map((Gender
                                                                                gen) {
                                                                                  return new DropdownMenuItem<
                                                                                      String>(
                                                                                    value:
                                                                                    gen.name,
                                                                                    child:
                                                                                    new Text(gen.name, style: Theme.of(context).textTheme.bodyText2),
                                                                                  );
                                                                                }).toList(),
                                                                                onChanged:
                                                                                    (val) {
                                                                                  setState(() =>
                                                                                  gender = val.toString());
                                                                                  provider
                                                                                      .genderController!
                                                                                      .text = val.toString();
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                        /*SizedBox(
                                                height: SizedBoxSize.standardSizedBoxHeight,
                                                width: SizedBoxSize.standardSizedBoxWidth,
                                            ),
                                            Text(
                                                MyStrings.gender,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500),
                                            ),
                                            Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 300,
                                                      height: 120,
                                                      child: ListView.builder(
                                                          scrollDirection: Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemCount: genders.length,
                                                          itemBuilder: (context, index) {
                                                            return InkWell(
                                                             // splashColor: Colors.pinkAccent,
                                                              onTap: () {
                                                                setState(() {
                                                                  genders.forEach((gender) =>
                                                                  gender.isSelected = false);
                                                                  genders[index].isSelected =
                                                                  true;
                                                                });
                                                              },
                                                               child: CustomRadioButton(genders[index].name,genders[index].icon,genders[index].isSelected),
                                                            );
                                                          }),
                                                    ),
                                                  ]
                                            ),*/
                                                                        SizedBox(
                                                                          height: 10,
                                                                          width: SizedBoxSize
                                                                              .standardSizedBoxWidth,
                                                                        ),
                                                                        Focus(
                                                                          focusNode:
                                                                          _node,
                                                                          onFocusChange:
                                                                              (bool
                                                                          focus) {
                                                                            setState(
                                                                                    () {
                                                                                  _webDatePicker ==
                                                                                      true
                                                                                      ? _webDatePicker =
                                                                                  false
                                                                                      : _webDatePicker =
                                                                                  false;
                                                                                });
                                                                          },
                                                                          child:
                                                                          Listener(
                                                                            onPointerDown:
                                                                                (_) {
                                                                              FocusScope.of(
                                                                                  context)
                                                                                  .requestFocus(
                                                                                  _node);
                                                                            },
                                                                            child:
                                                                            CustomizeTextFormField(
                                                                              labelText:
                                                                              MyStrings
                                                                                  .jerseyNumber,
                                                                              controller:
                                                                              provider
                                                                                  .jersetNumberController,
                                                                              keyboardType:
                                                                              TextInputType.number,
                                                                              inputFormatter: <
                                                                                  TextInputFormatter>[
                                                                                FilteringTextInputFormatter
                                                                                    .digitsOnly,
                                                                                new LengthLimitingTextInputFormatter(
                                                                                    10)
                                                                              ],
                                                                              inputAction:
                                                                              TextInputAction
                                                                                  .next,
                                                                              // suffixImage: MyImages.dropDown,
                                                                              isEnabled:
                                                                              true,
                                                                              onSave:
                                                                                  (value) {
                                                                                provider
                                                                                    .jersetNumberController!
                                                                                    .text = value!;
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: SizedBoxSize
                                                                              .standardSizedBoxHeight,
                                                                          width: SizedBoxSize
                                                                              .standardSizedBoxWidth,
                                                                        ),
                                                                        Focus(
                                                                          focusNode:
                                                                          _node,
                                                                          onFocusChange:
                                                                              (bool
                                                                          focus) {
                                                                            setState(
                                                                                    () {
                                                                                  _webDatePicker ==
                                                                                      true
                                                                                      ? _webDatePicker =
                                                                                  false
                                                                                      : _webDatePicker =
                                                                                  false;
                                                                                });
                                                                          },
                                                                          child:
                                                                          Listener(
                                                                            onPointerDown:
                                                                                (_) {
                                                                              FocusScope.of(
                                                                                  context)
                                                                                  .requestFocus(
                                                                                  _node);
                                                                            },
                                                                            child:
                                                                            CustomizeTextFormField(
                                                                              labelText:
                                                                              MyStrings
                                                                                  .position,
                                                                              controller:
                                                                              provider
                                                                                  .positionController,
                                                                              inputFormatter: [
                                                                                new LengthLimitingTextInputFormatter(
                                                                                    25),
                                                                              ],
                                                                              // suffixImage: MyImages.dropDown,
                                                                              inputAction:
                                                                              TextInputAction
                                                                                  .next,
                                                                              isEnabled:
                                                                              true,
                                                                              onSave:
                                                                                  (value) {
                                                                                provider
                                                                                    .positionController!
                                                                                    .text = value!;
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: SizedBoxSize
                                                                              .standardSizedBoxHeight,
                                                                          width: SizedBoxSize
                                                                              .standardSizedBoxWidth,
                                                                        ),
                                                                        Focus(
                                                                          focusNode:
                                                                          _node,
                                                                          onFocusChange:
                                                                              (bool
                                                                          focus) {
                                                                            setState(
                                                                                    () {
                                                                                  _webDatePicker ==
                                                                                      true
                                                                                      ? _webDatePicker =
                                                                                  false
                                                                                      : _webDatePicker =
                                                                                  false;
                                                                                });
                                                                          },
                                                                          child:
                                                                          Listener(
                                                                            onPointerDown:
                                                                                (_) {
                                                                              FocusScope.of(
                                                                                  context)
                                                                                  .requestFocus(
                                                                                  _node);
                                                                            },
                                                                            child:
                                                                            CustomizeTextFormField(
                                                                              labelText:
                                                                              MyStrings
                                                                                  .shoot,
                                                                              controller:
                                                                              provider
                                                                                  .shootController,
                                                                              inputFormatter: [
                                                                                new LengthLimitingTextInputFormatter(
                                                                                    30),
                                                                              ],
                                                                              // suffixImage: MyImages.dropDown,
                                                                              inputAction:
                                                                              TextInputAction
                                                                                  .next,
                                                                              isEnabled:
                                                                              true,
                                                                              onSave:
                                                                                  (value) {
                                                                                provider
                                                                                    .shootController!
                                                                                    .text = value!;
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: SizedBoxSize
                                                                              .standardSizedBoxHeight,
                                                                          width: SizedBoxSize
                                                                              .standardSizedBoxWidth,
                                                                        ),
                                                                        Focus(
                                                                          focusNode:
                                                                          _node,
                                                                          onFocusChange:
                                                                              (bool
                                                                          focus) {
                                                                            setState(
                                                                                    () {
                                                                                  _webDatePicker ==
                                                                                      true
                                                                                      ? _webDatePicker =
                                                                                  false
                                                                                      : _webDatePicker =
                                                                                  false;
                                                                                });
                                                                          },
                                                                          child:
                                                                          Listener(
                                                                            onPointerDown:
                                                                                (_) {
                                                                              FocusScope.of(
                                                                                  context)
                                                                                  .requestFocus(
                                                                                  _node);
                                                                            },
                                                                            child:
                                                                            Scrollbar(
                                                                              isAlwaysShown:
                                                                              true,
                                                                              controller:
                                                                              _controllerOne,
                                                                              child:
                                                                              CustomizeTextFormField(
                                                                                labelText:
                                                                                MyStrings.medicalNote,
                                                                                controller:
                                                                                provider.medicalNoteController,
                                                                                inputFormatter: [
                                                                                  new LengthLimitingTextInputFormatter(
                                                                                      100),
                                                                                ],
                                                                                // suffixImage: MyImages.dropDown,
                                                                                minLines:
                                                                                3,
                                                                                maxLines:
                                                                                3,
                                                                                keyboardType:
                                                                                TextInputType.multiline,
                                                                                inputAction:
                                                                                TextInputAction.newline,
                                                                                isEnabled:
                                                                                true,
                                                                                onSave:
                                                                                    (value) {
                                                                                  provider
                                                                                      .medicalNoteController!
                                                                                      .text = value!;
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height: SizedBoxSize
                                                                              .standardSizedBoxHeight,
                                                                          width: SizedBoxSize
                                                                              .standardSizedBoxWidth,
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                          children: <
                                                                              Widget>[
                                                                            Material(
                                                                              child:
                                                                              SizedBox(
                                                                                height:
                                                                                SizedBoxSize.checkSizedBoxHeight,
                                                                                width: SizedBoxSize
                                                                                    .checkSizedBoxWidth,
                                                                                child:
                                                                                Theme(
                                                                                  data:
                                                                                  ThemeData(
                                                                                    unselectedWidgetColor:
                                                                                    Colors.black,
                                                                                  ),
                                                                                  child:
                                                                                  Checkbox(
                                                                                    hoverColor:
                                                                                    MyColors.transparent,
                                                                                    focusColor:
                                                                                    MyColors.transparent,
                                                                                    shape:
                                                                                    RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(2.0),
                                                                                      side: BorderSide(
                                                                                        color: Colors.grey,
                                                                                        width: 1.5,
                                                                                      ),
                                                                                    ),
                                                                                    side:
                                                                                    BorderSide(
                                                                                      color: Colors.grey,
                                                                                      width: 1.5,
                                                                                    ),
                                                                                    checkColor:
                                                                                    MyColors.black,
                                                                                    activeColor:
                                                                                    Colors.grey[400],
                                                                                    value:
                                                                                    provider.getManager,
                                                                                    onChanged:
                                                                                        (value) {
                                                                                      setState(() {
                                                                                        provider.setManager(value!);
                                                                                        _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;

                                                                                      });
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child:
                                                                              Container(
                                                                                width: MarginSize
                                                                                    .headerMarginHeight1,
                                                                                child:
                                                                                ListTile(
                                                                                  title:
                                                                                  Text(
                                                                                    MyStrings.managerAccess,
                                                                                  ),
                                                                                  subtitle:
                                                                                  Text(
                                                                                    MyStrings.managerAccessRights,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: SizedBoxSize
                                                                              .standardSizedBoxHeight,
                                                                          width: SizedBoxSize
                                                                              .standardSizedBoxWidth,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    _webDatePicker ==
                                                                        true &&
                                                                        getValueForScreenType<
                                                                            bool>(
                                                                          context:
                                                                          context,
                                                                          mobile:
                                                                          false,
                                                                          tablet:
                                                                          true,
                                                                          desktop:
                                                                          true,
                                                                        )
                                                                        ? Container(
                                                                      width: 330,
                                                                      child: Card(
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                            3.0,
                                                                            left:
                                                                            0.0,
                                                                            top:
                                                                            0.0,
                                                                            bottom:
                                                                            30.0),
                                                                        elevation:
                                                                        10,
                                                                        shadowColor:
                                                                        MyColors
                                                                            .colorGray_666BC,
                                                                        child:
                                                                        SfDateRangePicker(
                                                                          initialDisplayDate: _selectedDate,
                                                                          initialSelectedDate: _selectedDate,
                                                                          view: DateRangePickerView
                                                                              .month,
                                                                          todayHighlightColor:
                                                                          MyColors.red,
                                                                          allowViewNavigation:
                                                                          true,
                                                                          showNavigationArrow:
                                                                          true,
                                                                          navigationMode:
                                                                          DateRangePickerNavigationMode.snap,
                                                                          endRangeSelectionColor:
                                                                          MyColors.kPrimaryColor,
                                                                          rangeSelectionColor:
                                                                          MyColors.kPrimaryColor,
                                                                          selectionColor:
                                                                          MyColors.kPrimaryColor,
                                                                          startRangeSelectionColor:
                                                                          MyColors.kPrimaryColor,
                                                                          onSelectionChanged:
                                                                          _onSelectionChanged,
                                                                          selectionMode:
                                                                          DateRangePickerSelectionMode.single,
                                                                          onSubmit:
                                                                              (value) {
                                                                            provider.DatePickerController!.text =
                                                                                value.toString();
                                                                          },
                                                                          initialSelectedRange: PickerDateRange(
                                                                              DateTime.now().subtract(const Duration(days: 4)),
                                                                              DateTime.now().add(const Duration(days: 3))),
                                                                        ),
                                                                      ),
                                                                    )
                                                                        : SizedBox(),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                  MainAxisSize.min,
                                                                  children: <Widget>[
                                                                    Material(
                                                                      child: SizedBox(
                                                                        height: SizedBoxSize
                                                                            .checkSizedBoxHeight,
                                                                        width: SizedBoxSize
                                                                            .checkSizedBoxWidth,
                                                                        child: Theme(
                                                                          data:
                                                                          ThemeData(
                                                                            unselectedWidgetColor:
                                                                            Colors
                                                                                .black,
                                                                          ),
                                                                          child:
                                                                          Checkbox(
                                                                            hoverColor:
                                                                            MyColors
                                                                                .transparent,
                                                                            focusColor:
                                                                            MyColors
                                                                                .transparent,
                                                                            shape:
                                                                            RoundedRectangleBorder(
                                                                              borderRadius:
                                                                              BorderRadius.circular(
                                                                                  2.0),
                                                                              side:
                                                                              BorderSide(
                                                                                color: Colors
                                                                                    .grey,
                                                                                width:
                                                                                1.5,
                                                                              ),
                                                                            ),
                                                                            side:
                                                                            BorderSide(
                                                                              color: Colors
                                                                                  .grey,
                                                                              width:
                                                                              1.5,
                                                                            ),
                                                                            checkColor:
                                                                            MyColors
                                                                                .black,
                                                                            activeColor:
                                                                            Colors.grey[
                                                                            400],
                                                                            value: provider
                                                                                .getNonPlayer,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(
                                                                                      () {
                                                                                    provider
                                                                                        .setNonPlayer(value!);
                                                                                    _webDatePicker ==
                                                                                        true
                                                                                        ? _webDatePicker =
                                                                                    false
                                                                                        : _webDatePicker =
                                                                                    false;
                                                                                  });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child: Container(
                                                                        width: MarginSize
                                                                            .headerMarginHeight1,
                                                                        child: ListTile(
                                                                          title: Text(
                                                                            MyStrings
                                                                                .nonPlayer,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Text(
                                                                      MyStrings
                                                                          .contactinfo,
                                                                      style: TextStyle(
                                                                          fontSize: getValueForScreenType<
                                                                              bool>(
                                                                            context:
                                                                            context,
                                                                            mobile:
                                                                            false,
                                                                            tablet:
                                                                            false,
                                                                            desktop:
                                                                            true,
                                                                          )
                                                                              ? FontSize
                                                                              .headerFontSize1
                                                                              : FontSize
                                                                              .headerFontSize3,
                                                                          fontWeight:
                                                                          FontWeights
                                                                              .headerFontWeight1),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          labelText:
                                                                          MyStrings
                                                                              .email +
                                                                              "*",
                                                                          // prefixIcon: MyIcons.mail,
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(
                                                                                100),
                                                                          ],
                                                                          keyboardType:
                                                                          TextInputType
                                                                              .emailAddress,
                                                                          controller:
                                                                          provider
                                                                              .emailController,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          validator:
                                                                          ValidateInput
                                                                              .validateEmail,
                                                                          isEnabled:
                                                                          true,

                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .emailController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          labelText:
                                                                          MyStrings
                                                                              .altemail,
                                                                          // prefixIcon: MyIcons.mail,
                                                                          controller:
                                                                          provider
                                                                              .altemailController,
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(
                                                                                100),
                                                                          ],
                                                                          keyboardType:
                                                                          TextInputType
                                                                              .emailAddress,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          //validator: ValidateInput.validateEmail,
                                                                          isEnabled:
                                                                          true,

                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .altemailController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child: CustomizeTextFormField(
                                                                          labelText: MyStrings
                                                                              .contactPhone,
                                                                          hintText: MyStrings.noFormat,
                                                                          controller: provider
                                                                              .contactPhoneController,
                                                                          keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          inputFormatter: <
                                                                              TextInputFormatter>[
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly,
                                                                            new LengthLimitingTextInputFormatter(
                                                                                10)
                                                                          ],
                                                                          // suffixImage: MyImages.dropDown,
                                                                          isEnabled: true,
                                                                          onSave: (value) {
                                                                            provider
                                                                                .contactPhoneController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          labelText:
                                                                          MyStrings
                                                                              .altcontactPhone,
                                                                          controller:
                                                                          provider
                                                                              .altcontactPhoneController,
                                                                          keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          inputFormatter: <
                                                                              TextInputFormatter>[
                                                                            FilteringTextInputFormatter
                                                                                .digitsOnly,new LengthLimitingTextInputFormatter(10)
                                                                          ],
                                                                          // suffixImage: MyImages.dropDown,
                                                                          isEnabled:
                                                                          true,
                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .altcontactPhoneController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          labelText:
                                                                          MyStrings
                                                                              .address1,
                                                                          controller:
                                                                          provider
                                                                              .addressController,
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          isEnabled:
                                                                          true,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(
                                                                                50),
                                                                          ],
                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .addressController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          labelText:
                                                                          MyStrings
                                                                              .altaddress,
                                                                          controller:
                                                                          provider
                                                                              .altaddressController,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(
                                                                                50),
                                                                          ],
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          isEnabled:
                                                                          true,
                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .altaddressController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          labelText:
                                                                          MyStrings
                                                                              .city,
                                                                          controller:
                                                                          provider
                                                                              .cityController,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(
                                                                                25),
                                                                          ],
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          isEnabled:
                                                                          true,
                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .cityController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          labelText:
                                                                          MyStrings
                                                                              .state,
                                                                          controller:
                                                                          provider
                                                                              .stateController,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(
                                                                                25),
                                                                          ],
                                                                          // suffixImage: MyImages.dropDown,
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          isEnabled:
                                                                          true,
                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .stateController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        CustomizeTextFormField(
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(
                                                                                10),
                                                                          ],
                                                                          labelText:
                                                                          MyStrings
                                                                              .zipcode,
                                                                          controller:
                                                                          provider
                                                                              .zipcodeController,
                                                                          inputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                          onFieldSubmit: (v){
                                                                            FocusScope.of(context).requestFocus(_notenode);

                                                                          },

                                                                          // suffixImage: MyImages.dropDown,
                                                                          isEnabled:
                                                                          true,
                                                                          onSave:
                                                                              (value) {
                                                                            provider
                                                                                .zipcodeController!
                                                                                .text = value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    Focus(
                                                                      focusNode: _node,
                                                                      onFocusChange:
                                                                          (bool focus) {
                                                                        setState(() {
                                                                          _webDatePicker ==
                                                                              true
                                                                              ? _webDatePicker =
                                                                          false
                                                                              : _webDatePicker =
                                                                          false;
                                                                        });
                                                                      },
                                                                      child: Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(
                                                                              context)
                                                                              .requestFocus(
                                                                              _node);
                                                                        },
                                                                        child:
                                                                        Scrollbar(
                                                                          isAlwaysShown:
                                                                          true,
                                                                          controller:
                                                                          _controllerOne,
                                                                          child:
                                                                          CustomizeTextFormField(
                                                                            labelText:
                                                                            MyStrings
                                                                                .notes,
                                                                            inputAction:
                                                                            TextInputAction
                                                                                .newline,
                                                                            controller:
                                                                            provider
                                                                                .noteController,
                                                                            focusNode:_notenode,
                                                                            inputFormatter: [
                                                                              new LengthLimitingTextInputFormatter(
                                                                                  100),
                                                                            ],
                                                                            // suffixImage: MyImages.dropDown,
                                                                            minLines: 3,
                                                                            maxLines: 3,
                                                                            keyboardType:
                                                                            TextInputType
                                                                                .multiline,
                                                                            isEnabled:
                                                                            true,
                                                                            onSave:
                                                                                (value) {
                                                                              provider
                                                                                  .noteController!
                                                                                  .text = value!;
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                    /*  addFamilyList(),
                                                  Container(
                                                      child: RaisedButtonCustom(
                                                    buttonColor: MyColors.kPrimaryColor,
                                                    textColor: MyColors.kPrimaryLightColor,
                                                    splashColor: Colors.grey,
                                                    buttonText: MyStrings.addFamily,
                                                    onPressed: _addFamily,
                                                  ))*/
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class Gender {
  final int id;
  final String name;

  Gender(
      this.id,
      this.name,
      );
}

List<Gender> getGender = <Gender>[
  Gender(
    1,
    MyStrings.male,
  ),
  Gender(
    2,
    MyStrings.female,
  ),
  Gender(
    3,
    MyStrings.others,
  ),
];
