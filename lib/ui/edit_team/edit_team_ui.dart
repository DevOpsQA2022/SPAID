import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:country_picker/country_picker.dart';
import 'package:country_pickers/country.dart' as b;
import 'package:country_pickers/country_pickers.dart' as c;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as d;
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/create_team_response/create_team_response.dart';
import 'package:spaid/model/response/create_team_response/team_details_response.dart';
import 'package:spaid/model/response/signin_response/signin_response.dart';
import 'package:spaid/service/email_service.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/email_template.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/create_team/create_team_provider.dart';
import 'package:spaid/ui/edit_team/edit_team_provider.dart';
import 'package:spaid/ui/select_team_screen/select_team_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_raised_button.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

class EditTeamScreen extends StatefulWidget {
  @override
  _EditTeamScreenState createState() => _EditTeamScreenState();
}

class _EditTeamScreenState extends BaseState<EditTeamScreen> {
  //region Private Members

  String _country = '';

  EditTeamProvider? _editTeamProvider;

  List<S2Choice<String>> _timeZone = [];
  final _formKey = GlobalKey<FormState>();

  String countryCode="IN",playerEmail="";
  Location location = new Location();
  String value = 'IST';
  List<S2Choice<String>> options = [
    S2Choice<String>(value: 'IST', title: 'Chennai, Kolkata, Mumbai, New Delhi (UTC+05:30)'),
    S2Choice<String>(value: 'SLST', title: 'Sri Lanka Standard Time'),
    S2Choice<String>(value: 'NST', title: 'Nepal Standard Time'),
  ];
  String _selectedTimeZone = '';
  SelectTeamProvider? _selectTeamProvider;

  bool showTimezone = false;
  TextEditingController searchController = TextEditingController();
  String id = "";
  String? imgFilePath;
  String imageB64="";
  List<int>? imageBytes;
  FocusNode _node = new FocusNode();
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
    super.initState();
    _editTeamProvider =
        Provider.of<EditTeamProvider>(context, listen: false);
    _editTeamProvider!.initialProvider();
    _editTeamProvider!.listener = this;
    _editTeamProvider!.getTeamDetails("");
    _selectTeamProvider =
        Provider.of<SelectTeamProvider>(context, listen: false);

    //  _getCountryNameAsync();

  }

//Future Purpose
/*  Future<void> getCountryCodeAsync() async {
    Locale l = await Devicelocale.currentAsLocale;
    if (l != null) {
      print("CurrentAsLocale result: Language Code: ${l.languageCode} , Country Code: ${l.countryCode}");
    } else {
      print('Unable to determine currentAsLocale');
    }
  }*/

  @override
  void onSuccess(any, {int? reqId}) async{
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.EDIT_TEAM:
        TeamDetailsResponse _response = any as TeamDetailsResponse;
        if (_response.responseResult == Constants.success) {
          SharedPrefManager.instance
              .setStringAsync(
              Constants
                  .teamName,
              _editTeamProvider!.teamNameController!.text);


          SharedPrefManager.instance
              .setStringAsync(
              Constants
                  .teamCountry,
              _editTeamProvider!.countryController!.text);
         // Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 0);
          Navigator.of(context).pop();
          Navigation.navigateWithArgument(context, MyRoutes.teamProfileScreen, Constants.navigateIdOne);
        }
        break;
      case ResponseIds.GET_TEAM_DETAILS:
        TeamDetailsResponse _response = any as TeamDetailsResponse;
        if (_response.result!.teamIDNo != Constants.success) {
          setState(() {
            imageBytes=_response.result!.teamProfileImage!.isNotEmpty?base64Decode(_response.result!.teamProfileImage!):null;
            _editTeamProvider!.teamNameController!.text=_response.result!.teamName!;
            _editTeamProvider!.countryController!.text=_response.result!.teamCountry!;
            _editTeamProvider!.timezoneController!.text=_response.result!.teamTimeZone!;
            _getJsonTimeZoneAsync(_response.result!.teamTimeZone!);

            if(getValueForScreenType<bool>(
              context: context,
              mobile: false,
              tablet: true,
              desktop: true,)){
              _getJsonCountryAsync(_response.result!.teamCountry!);
            }else{
              _country=_response.result!.teamCountry!;

            }

          });


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
Use: Validate user inputs and Send Team Details to the Server.
 */
  void _createTeam() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Internet.checkInternet().then((value) {
        if (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressBar.instance.showProgressbar(context);
          });
          _editTeamProvider!.updateTeamAsync(imageBytes??[]);
        } else {
          CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
        }
      });
    }
  }

  /*
Return Type:String
Input Parameters:
Use: To get Country Code.
 */
  Future<void> _getCountryNameAsync() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

    }
    if(!kIsWeb) {
      d.Position position = await d.Geolocator()
          .getCurrentPosition(desiredAccuracy: d.LocationAccuracy.high);
      debugPrint('location: ${position.latitude}');
      final coordinates = new Coordinates(position.latitude, position.longitude);
      var addresses =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setState(() {
        //countryCode=first.countryCode;
       // _country = first.countryName;
        //_editTeamProvider.countryController.text = first.countryName;
      });
      //print(first.countryCode);
      print(addresses.toString());
    }
    // return first.countryCode; // this will return country name

  }

  // @override
  // initState() {
  //   super.initState();
  //   print(_dateTime.timeZoneName);
  //
  //   _readJsonCountry();
  //   tz.initializeTimeZones();
  //   var locations = tz.timeZoneDatabase.locations;
  //   print(locations.length); // => 429
  //   print(locations.keys); // => "Africa/Abidjan"
  //   print(locations);
  //   _readJsonTimeZone();
  // }

  // Fetch content from the json file
  Future<void> _getJsonCountryAsync(String country) async {

    final String response =
    await rootBundle.loadString('assets/json/multi/country_code_picker.json');
    final data = await json.decode(response);

    for (int i = 0; data["countries"].length > i; i++) {
     if ((data["countries"][i]["name"].toLowerCase()).toString().contains(country.split(" ").first.toLowerCase())) {
       setState(() {
         _country=data["countries"][i]["code"];
       });
      }
    }

  }


  // Fetch content from the json file
  Future<void> _getJsonTimeZoneAsync(String teamTimeZone) async {
    //countryCode=await SharedPrefManager.instance.getStringAsync(Constants.countryCode);
    //_country=await SharedPrefManager.instance.getStringAsync(Constants.countryName);
    playerEmail=await SharedPrefManager.instance.getStringAsync(Constants.userEmail);
   /* setState(() {
      _editTeamProvider.countryController.text = _country;
    });*/

    print(countryCode);
    print(playerEmail);

    final String response =
    await rootBundle.loadString('assets/json/multi/timezone_picker.json');
    final data = await json.decode(response);
   // DateTime dateTime = DateTime.now();
   // print(dateTime.timeZoneName);
    for (int i = 0; data["timeZones"].length > i; i++) {
      //_timeZone.add(S2Choice<String>(value: data["timeZones"][i]["index"], title: data["timeZones"][i]["index"]));
      //if (data["timeZones"][i]["id"].toLowerCase().contains(dateTime.timeZoneName.toLowerCase()) || data["timeZones"][i]["value"].toLowerCase().contains(dateTime.timeZoneName.toLowerCase())) {
      if (data["timeZones"][i]["id"].toLowerCase()==teamTimeZone.toLowerCase() || data["timeZones"][i]["name"].toLowerCase()==teamTimeZone.toLowerCase()) {
        setState(() {
          if(kIsWeb) {
            _selectedTimeZone = data["timeZones"][i]["name"];
          }else{
            if(getValueForScreenType<bool>(
              context: context,
              mobile: false,
              tablet: true,
              desktop: false,
            )){
              _selectedTimeZone = data["timeZones"][i]["name"];

            }else {
              _selectedTimeZone = data["timeZones"][i]["index"];
              print("Marlen 1" + data["timeZones"][i]["id"]);
            }

          }
         // _editTeamProvider.timezoneController.text=data["timeZones"][i]["name"];
          id=(i+1).toString();

        });
      }
    }
    _timeZone = S2Choice.listFrom<String, dynamic>(
      source: data[MyStrings.timeZones],
      group: (index, item) => item["index"].toString(),
      value: (index, item) => item["index"].toString(),
      title: (index, item) => item[MyStrings.name],
      subtitle: (index, item) => item[MyStrings.description],
    );
  }

  // Fetch content from the json file
  Future<void> _getJsonTimeZoneSearchAsync(String value) async {
    final String response =
    await rootBundle.loadString('assets/json/multi/timezone_picker.json');
    final data = await json.decode(response);
    if (value.isNotEmpty) {
      _timeZone.clear();
      List datas = [];
      for (int i = 0; data["timeZones"].length > i; i++) {
        if (data["timeZones"][i]["name"].toLowerCase().contains(value)) {
          datas.add(data["timeZones"][i]);
        } else {
          print(value);
        }
      }
      _timeZone = S2Choice.listFrom<String, dynamic>(
        source: datas,
        group: (index, item) => item["index"].toString(),
        value: (index, item) => item[MyStrings.id],
        title: (index, item) => item[MyStrings.name],
        subtitle: (index, item) => item[MyStrings.description],
      );
    } else {
      _timeZone.clear();
      _timeZone = S2Choice.listFrom<String, dynamic>(
        source: data[MyStrings.timeZones],
        group: (index, item) => item["index"].toString(),
        value: (index, item) => item[MyStrings.id],
        title: (index, item) => item[MyStrings.name],
        subtitle: (index, item) => item[MyStrings.description],
      );
    }
  }

  Widget _buildDropdownItem(b.Country country) => Row(
    children: <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Scrollbar(
            thickness: 10,
            controller: _controllerOne,
            isAlwaysShown: true,
            child: Container(
              child: Row(
                children: [
                  c.CountryPickerUtils.getDefaultFlagImage(country),
                  SizedBox(
                    width: 10,
                  ),
                  Text("+${country.name}(${country.isoCode})"),
                ],
              ),
            ),
          ),
        ],
      ),
      //Text("Llllll")
      // Text("+${country.phoneCode}"),
    ],
  );

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
      }else{
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
          imgFilePath=file.path;
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

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        Navigation.navigateWithArgument(context, MyRoutes.teamProfileScreen, Constants.navigateIdOne);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MyColors.white,
        appBar: getValueForScreenType<bool>(
          context: context,
          mobile: false,
          tablet: false,
          desktop: true,
        ) ? CustomSimpleAppBar(
          title: MyStrings.appName,
          iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
          iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
          onClickRightImage: () {
            Navigator.of(context).pop();
          },
          onClickLeftImage: () {
            Navigator.of(context).pop();
          },
        ) : null,
        body: SingleChildScrollView(
          child: SizedBox(
            height:  size.height * 0.98,
            child: TopBar(
              child: Row(
                children: [
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
                          title: MyStrings.editTeam,
                          //iconRight: MyIcons.exitToApp,
                          iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
                          onClickLeftImage: (){
                            Navigator.of(context).pop();
                            Navigation.navigateWithArgument(context, MyRoutes.teamProfileScreen, Constants.navigateIdOne);
                          },

                        ),
                        bottomNavigationBar: getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        )
                            ? Container(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButtonCustom(
                                  buttonColor: MyColors.kPrimaryColor,
                                  splashColor: Colors.grey,
                                  buttonText: MyStrings.save,
                                  buttonWidth: getValueForScreenType<bool>(
                                    context: context,
                                    mobile: true,
                                    tablet: false,
                                    desktop: false,)
                                      ? null
                                      : size.width *
                                      WidgetCustomSize
                                          .raisedButtonWebWidth,
                                  onPressed: () => {
                                    _createTeam(),
                                    // Navigation.navigateTo(context, MyRoutes.teamSetupScreen)
                                  }),
                            ],
                          ),
                        )
                            : null,
                        body: Consumer<EditTeamProvider>(
                            builder: (context, provider, _) {
                              return Form(
                                key: _formKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: SafeArea(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [

                                        Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: true,
                                                desktop: true,)
                                                  ? PaddingSize.headerPadding1
                                                  : PaddingSize.headerPadding2),
                                              child: Padding(
                                                padding: const EdgeInsets.all(18.0),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 20,
                                                    ),

                                                    Stack(
                                                      children: [
                                                        imageBytes != null? CircleAvatar(
                                                          backgroundImage:MemoryImage(Uint8List.fromList(imageBytes!)
                                                          ),// Image.file(new File(imgFilePath)),                      ,// Image.file(new File(imgFilePath)),
                                                          //backgroundImage: NetworkImage(MyImages.spaid),
                                                          backgroundColor:
                                                          MyColors.kPrimaryLightColor,
                                                          radius: Consts.avatarRadius,
                                                        ):CircleAvatar(
                                                          backgroundImage:AssetImage(
                                                            MyImages.noImageData,
                                                          ),// Image.file(new File(imgFilePath)),                      ,// Image.file(new File(imgFilePath)),
                                                          //backgroundImage: NetworkImage(MyImages.spaid),
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
                                                              else if(value ==2){
                                                                setState(() {
                                                                  imageBytes=null;
                                                                });

                                                              }
                                                            },
                                                            itemBuilder: (context) => [
                                                              PopupMenuItem(
                                                                value: 1,
                                                                child: Text(MyStrings.imageTooltipUpload),
                                                              ),
                                                              if(imageBytes != null)
                                                              PopupMenuItem(
                                                                value: 2,
                                                                child: Text(MyStrings.imageTooltipRemove),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    Focus(
                                                      focusNode:
                                                      _node,
                                                      onFocusChange:
                                                          (bool
                                                      focus) {
                                                        setState(
                                                                () {
                                                              showTimezone ==
                                                                  true
                                                                  ? showTimezone =
                                                              false
                                                                  : showTimezone =
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 8.0 ,top: 8.0 ,left: 16.0 , right : 20),

                                                          child: CustomizeTextFormField(
                                                            inputFormatter: [new LengthLimitingTextInputFormatter(50),],
                                                            labelText: MyStrings.teamName+"*",
                                                            prefixIcon: MyIcons.username,
                                                            controller:
                                                            provider.teamNameController,
                                                            // controller: _emailController,
                                                            validator: ValidateInput
                                                                .requiredTeamFields,
                                                            // suffixImage: MyImages.dropDown,
                                                            isEnabled: true,
                                                            onSave: (value) {
                                                              provider.teamNameController!.text =
                                                                  value!;
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // SizedBox(height: size.height * SizedBoxSize.footerSizedBoxWidth1),
                                                    getValueForScreenType<bool>(
                                                      context: context,
                                                      mobile: true,
                                                      tablet: false,
                                                      desktop: false,)
                                                        ?_timeZone.length>0? SmartSelect<String>.single(
                                                      title: MyStrings.timeZone+"*",
                                                      placeholder: _selectedTimeZone.isNotEmpty?_selectedTimeZone:MyStrings.selectOne,
                                                      value: _selectedTimeZone,
                                                      modalFilter: true,
                                                      modalFilterAuto: true,
                                                      modalType: S2ModalType.fullPage,
                                                      choiceType: S2ChoiceType.radios,

                                                      /*onChange: (state) => setState(
                                                              () => _selectedTimeZone =
                                                              state.value),*/
                                                      onChange: (state) {
                                                        if(state.value.isNotEmpty) {
                                                          print("Marlen 12"+state.value);
                                                          _selectedTimeZone =
                                                              state.value;
                                                          provider
                                                              .timezoneController!
                                                              .text = state.valueDisplay;
                                                        }
                                                      },
                                                      choiceItems: _timeZone,
                                                      choiceDivider: true,
                                                    ):Container()
                                                        : SizedBox(),
                                                    if (getValueForScreenType<bool>(
                                                      context: context,
                                                      mobile: false,
                                                      tablet: true,
                                                      desktop: true,
                                                       ))
                                                      Padding(
                                                        padding: const EdgeInsets.all(
                                                            PaddingSize.boxPaddingAllSide),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 8),

                                                              child: Text(
                                                                MyStrings.timeZone+"*",
                                                                style: TextStyle(
                                                                  fontSize: FontSize
                                                                      .headerFontSize5,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  _selectedTimeZone,
                                                                ),
                                                                IconButton(
                                                                  icon: MyIcons.arrowIos,
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      showTimezone =
                                                                      showTimezone ==
                                                                          true
                                                                          ? false
                                                                          : true;
                                                                    });
                                                                    //selectRepeat(size);
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    if (showTimezone == true)
                                                      Card(
                                                        elevation: 10,
                                                        shadowColor:
                                                        MyColors.colorGray_666BC,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(
                                                                  PaddingSize.boxPaddingAllSide),
                                                              child: CustomizeTextFormField(
                                                                labelText: MyStrings.search,
                                                                //  prefixIcon: MyIcons.group,
                                                                controller: searchController,
                                                                suffixIcon: MyIcons.search,
                                                                // suffixImage: MyImages.dropDown,
                                                                isEnabled: true,
                                                                // validator: ValidateInput.requiredFields,
                                                                onChange: (value) {
                                                                  setState(() {
                                                                    _getJsonTimeZoneSearchAsync(
                                                                        value);
                                                                  });
                                                                },
                                                                onSave: (value) {
                                                                  searchController.text = value!;
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 180,
                                                              child: VsScrollbar(
                                                                controller: _controllerOne,
                                                                isAlwaysShown: true,
                                                                child: SingleChildScrollView(
                                                                  child: Container(
                                                                    child: Column(
                                                                      children: _timeZone
                                                                          .map((data) =>
                                                                          RadioListTile(
                                                                            title: Text(
                                                                                "${data.title}"),
                                                                            groupValue: id,
                                                                            value: data.group,
                                                                            activeColor: MyColors
                                                                                .kPrimaryColor,
                                                                            onChanged: (val) {
                                                                              setState(() {
                                                                                _selectedTimeZone =
                                                                                    data.title;
                                                                                provider.timezoneController!.text=data.title;
                                                                                id = data.group;
                                                                                showTimezone =
                                                                                showTimezone ==
                                                                                    true
                                                                                    ? false
                                                                                    : true;
                                                                              });
                                                                            },
                                                                          ))
                                                                          .toList(),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                          ],
                                                        ),
                                                      ),

                                                    getValueForScreenType<bool>(
                                                      context: context,
                                                      mobile: true,
                                                      tablet: false,
                                                      desktop: false,)
                                                        ? GestureDetector(
                                                      onTap: () {
                                                        showCountryPicker(
                                                          context: context,
                                                          //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                                          /*exclude: <
                                                              String>[
                                                            'KN',
                                                            'MF'
                                                          ],*/
                                                          countryFilter: <
                                                              String>[
                                                            'CA',
                                                            'US'
                                                          ],
                                                          //Optional. Shows phone code before the country name.
                                                          showPhoneCode:
                                                          true,
                                                          onSelect: (
                                                              Country
                                                              country) {
                                                            provider
                                                                .countryController!
                                                                .text =
                                                                country
                                                                    .displayNameNoCountryCode;

                                                            setState(() {
                                                              _country =
                                                                  country
                                                                      .displayNameNoCountryCode;
                                                            });
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(
                                                            PaddingSize
                                                                .boxPaddingAllSide),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 8),

                                                              child: Text(
                                                                MyStrings
                                                                    .country+"*",
                                                                style: TextStyle(fontSize: FontSize.headerFontSize5),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  _country,
                                                                  /* style: TextStyle(
                                                                  color: MyColors
                                                                      .colorGray_818181,
                                                                  fontSize: FontSize
                                                                      .footerFontSize6,
                                                                ),*/
                                                                ),
                                                                //      !isMobile(context) ? CountryPickerDialog(
                                                                //   countryCode: countryCode != null ? countryCode : MyStrings.countryUS,
                                                                //   label: MyStrings.contactPhone,
                                                                //   countryCodeController: provider.countryController,
                                                                //   validator: ValidateInput.validateMobile,
                                                                //   onSave: (value) {
                                                                //     provider.countryController.text = value.toString();
                                                                //     setState(() {
                                                                //       this._country = value;
                                                                //     });
                                                                //   },
                                                                // ):
                                                                IconButton(
                                                                  icon:
                                                                  MyIcons
                                                                      .arrowIos,
                                                                  onPressed: (){
                                                                    showCountryPicker(
                                                                      context: context,
                                                                      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                                                      /*exclude: <
                                                              String>[
                                                            'KN',
                                                            'MF'
                                                          ],*/
                                                                      countryFilter: <
                                                                          String>[
                                                                        'CA',
                                                                        'US'
                                                                      ],
                                                                      //Optional. Shows phone code before the country name.
                                                                      showPhoneCode:
                                                                      true,
                                                                      onSelect: (
                                                                          Country
                                                                          country) {
                                                                        provider
                                                                            .countryController!
                                                                            .text =
                                                                            country
                                                                                .displayNameNoCountryCode;

                                                                        setState(() {
                                                                          _country =
                                                                              country
                                                                                  .displayNameNoCountryCode;
                                                                        });
                                                                      },
                                                                    );
                                                                  },
                                                                  // controller: provider.countryController,

                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                        : Padding(
                                                      padding: const EdgeInsets.only(
                                                        left: 18.0,
                                                        right: 18.0,
                                                      ),
                                                      child:_country.isEmpty ? Container(): c.CountryPickerDropdown(
                                                        // initialValue: 'CA',
                                                        initialValue: _country.isEmpty ? "CA" :_country,

                                                        itemBuilder:
                                                        _buildDropdownItem,
                                                        isExpanded: true,
                                                        itemFilter: (c) => ['CA', 'US'].contains(c.isoCode),
                                                        priorityList: [
                                                          c.CountryPickerUtils.getCountryByIsoCode('CA'),
                                                          c.CountryPickerUtils.getCountryByIsoCode('US'),
                                                        ],
                                                        sortComparator: (b.Country a,
                                                            b.Country b) =>
                                                            a.isoCode
                                                                .compareTo(b.isoCode),
                                                        onValuePicked:
                                                            (b.Country country) {
                                                          print("${country.name}");
                                                          provider
                                                              .countryController!
                                                              .text =
                                                              country.name;

                                                          setState(() {
                                                            _country =
                                                                country.name;
                                                          });
                                                        },
                                                      ),
                                                    ),


                                                    // SmartSelect<String>.single(
                                                    //   title: MyStrings.country,
                                                    //   placeholder: MyStrings.selectOne,
                                                    //   value: _SelectedCountry,
                                                    //   modalFilter: true,
                                                    //   modalFilterAuto: true,
                                                    //   modalType: S2ModalType.bottomSheet,
                                                    //   choiceType: S2ChoiceType.radios,
                                                    //   onChange: (state) =>
                                                    //       setState(() => _SelectedCountry = state.value),
                                                    //   choiceItems: _country,
                                                    //   choiceDivider: true,
                                                    // ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 8),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            MyStrings.sportName,
                                                            style: TextStyle(
                                                              fontSize: FontSize
                                                                  .headerFontSize5,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(4.0),
                                                            child: Text(MyStrings.iceHockey),
                                                          )
                                                        ],
                                                      ),
                                                    ),

                                                    // SmartSelect<String>.single(
                                                    //     title: MyStrings.sportName,
                                                    //     // selectedValue: _month,
                                                    //     choiceItems: game,
                                                    //     // controller: provider.sportNameController,
                                                    //     modalType: S2ModalType.popupDialog,
                                                    //     choiceType: S2ChoiceType.radios,
                                                    //     onChange: (selected) => {
                                                    //           provider.sportNameController.text = selected.value,
                                                    //           setState(() => _month = selected.value),
                                                    //         }),

                                                    /*RaisedButtonCustom(
                                                      buttonColor: MyColors.kPrimaryColor,
                                                      splashColor: Colors.grey,
                                                      buttonText: MyStrings.save,
                                                      buttonWidth: getValueForScreenType<bool>(
                                                  context: context,
                                                  mobile: false,
                                                  tablet: false,
                                                  desktop: true,)?size.width/8:isTab(context)?size.width/3:null,
                                                      onPressed: () => {
                                                            _createTeam(),
                                                            // Navigation.navigateTo(context, MyRoutes.teamSetupScreen)
                                                          }),*/
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if(getValueForScreenType<bool>(
                                              context: context,
                                              mobile: true,
                                              tablet: false,
                                              desktop: false,))
                                              RaisedButtonCustom(
                                                  buttonColor: MyColors.kPrimaryColor,
                                                  splashColor: Colors.grey,
                                                  buttonText: MyStrings.save,
                                                  buttonWidth: getValueForScreenType<bool>(
                                                    context: context,
                                                    mobile: true,
                                                    tablet: false,
                                                    desktop: false,)
                                                      ? null
                                                      : size.width *
                                                      WidgetCustomSize
                                                          .raisedButtonWebWidth,
                                                  onPressed: () => {
                                                    _createTeam(),
                                                    // Navigation.navigateTo(context, MyRoutes.teamSetupScreen)
                                                  }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Static Data
List<S2Choice<String>> game = [
  S2Choice<String>(value: '1', title: MyStrings.iceHockey),
];

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
      Rect rect, {
        TextDirection? textDirection,
      }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 30, 0);
    path.lineTo(rrect.width - 20, -10);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
    side: _side.scale(t),
    borderRadius: _borderRadius * t,
  );
}
