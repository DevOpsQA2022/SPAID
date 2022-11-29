import 'dart:convert';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/roaster_listview_response/team_members_details_response.dart';
import 'package:spaid/model/response/signup_response/signup_response.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/add_player_screen/add_player_screen.dart';
import 'package:spaid/ui/player_profile_screen/player_profile_screen_provider.dart';
import 'package:spaid/ui/select_team_screen/select_team_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:spaid/widgets/custom_editable_text.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/player_profile_detail_card.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

String? userID, userRoleId;

String initialText = "";

class _UserProfileScreenState extends BaseState<UserProfileScreen> {
  @override
  List? userdata;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  bool _isShowDial = true;
  bool _webDatePicker = false;
  bool _isEditingText = false;
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  PlayerProfileProvider? _playerProfileProvider;
  SignUpProvider? _signUpProvider;
  String? userProfile;
  String? dateformat, first, profileName;
  FocusNode _node = new FocusNode();
  FocusNode _phonenode = new FocusNode();
  FocusNode _phonenode2 = new FocusNode();
  FocusNode _zipnode = new FocusNode();
  String? gender;
  TeamMembersDetailsResponse? _response;
  int count = 0;

  getTeamList() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });
    _playerProfileProvider!.listener = this;
    _signUpProvider!.listener = this;
    _playerProfileProvider!.getSelectTeamAsync(int.parse(userID!), "user");
  }

  void _putProfile() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 0);
      _signUpProvider!.emailController = emailEditingController;
      _signUpProvider!.firstNameController = nameEditingController;
      _signUpProvider!.lastNameController = lastNameEditingController;
      _signUpProvider!.DatePickerController = dobEditingController;
      _signUpProvider!.gender = genderEditingController;
      _signUpProvider!.mobileNumberController = phoneEditingController;
      _signUpProvider!.address = addressEditingController;
      _signUpProvider!.address2Controller = altaddressEditingController;
      _signUpProvider!.stateController = sateEditingController;
      _signUpProvider!.cityController = cityEditingController;
      _signUpProvider!.zipController = zipEditingController;
      _signUpProvider!.countryCodeController!.text = _response!.result!.userCountry!;
      _signUpProvider!.middleNameController!.text = _response!.result!.userMiddleName!;
      _signUpProvider!.putSignupAsync(userID!);
    }
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
        dobEditingController
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedDate)
              : dateformat == "CA"
                  ? DateFormat("yyyy/MM/dd").format(_selectedDate)
                  : DateFormat("dd/MM/yyyy").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: dobEditingController.text.length,
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

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  SelectTeamProvider? _selectTeamProvider;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController genderEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController dobEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController altaddressEditingController = TextEditingController();
  TextEditingController sateEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController zipEditingController = TextEditingController();
  TextEditingController DatepickerController = TextEditingController();

  //endregion

  getTeamsList() {
    //Future Purpose

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressBar.instance.showProgressbar(context);
    });
    _selectTeamProvider!.listener = this;
    _selectTeamProvider!.getSelectTeamAsync(context);
  }

  /*
Return Type:
Input Parameters: SharedPrefManager used
Use: getRoleAsync with role getting.
 */
  getRoleAsync() async {
    try {
      userID =
          await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
      userRoleId =
          await SharedPrefManager.instance.getStringAsync(Constants.userRoleId);
      getTeamList();
      //getTeamsList();
      setState(() {});
    } catch (e) {
      _selectTeamProvider!.listener
          .onFailure(ExceptionErrorUtil.handleErrors(e));
    } //
  }

  Future<void> getCountryCodeAsync() async {
    first =
        "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  @override
  void onSuccess(any, {int? reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_USER_PROFILE:
        // TeamMembersDetailsResponse _response = any as TeamMembersDetailsResponse;

        _response = any as TeamMembersDetailsResponse;
        if (_response!.result != null && _response!.result!.userIdNo != Constants.success) {
          //_playerProfileProvider.setMemberList(_response.user.members);
          setState(() {
            nameEditingController.text = _response!.result!.userFirstName??"";
            lastNameEditingController.text = _response!.result!.userLastName??"";
            genderEditingController.text = _response!.result!.userGender == null?"":_response!.result!.userGender! == "M"
                ? MyStrings.male
                : _response!.result!.userGender == "F"
                    ? MyStrings.female
                    :MyStrings.others;
            emailEditingController.text = _response!.result!.userEmailID??"";
            profileName =
                (_response!.result!.userFirstName??"") + " " + (_response!.result!.userLastName??"");
            /*DateFormat formatter = new DateFormat('yyyy-MM-dd');
            if(_response.userDOB != null){
              DateTime dateTime = formatter.parse(_response.userDOB);
              dobEditingController.text = DateFormat('dd/MM/yyyy').format(dateTime);
            }else{
              dobEditingController.text ="";
            }*/
            DateFormat formatter = new DateFormat('yyyy-MM-dd');
            if (_response!.result!.userDOB != null && _response!.result!.userDOB!.isNotEmpty) {
              DateTime dateTime = formatter.parse(_response!.result!.userDOB!);
              _selectedDate = formatter.parse(_response!.result!.userDOB!);
              dobEditingController.text = dateformat == "US"
                  ? DateFormat("MM/dd/yyyy").format((DateFormat('dd/MM/yyyy')
                      .parse(DateFormat('dd/MM/yyyy').format(dateTime))))
                  : dateformat == "CA"
                      ? DateFormat("yyyy/MM/dd").format(
                          (DateFormat('dd/MM/yyyy').parse(
                              DateFormat('dd/MM/yyyy').format(dateTime))))
                      : DateFormat("dd/MM/yyyy").format(
                          (DateFormat('dd/MM/yyyy').parse(
                              DateFormat('dd/MM/yyyy').format(dateTime))));
            } else {
              dobEditingController.text = "";
            }
            phoneEditingController.text =
                _response!.result!.userPrimaryPhone.toString() == "0"
                    ? ""
                    : _response!.result!.userPrimaryPhone.toString();
            addressEditingController.text = _response!.result!.userAddress1??"";
            altaddressEditingController.text = _response!.result!.userAddress2??"";
            sateEditingController.text = _response!.result!.userState??"";
            cityEditingController.text = _response!.result!.userCity??"";
            zipEditingController.text = _response!.result!.userZip??"";
            userProfile = _response!.result!.userProfileImage;
            _signUpProvider!.imageBytes = (_response!.result!.userProfileImage != null && _response!.result!.userProfileImage!.isNotEmpty
                ? List<int>.from(base64Decode(_response!.result!.userProfileImage!))
                : []);

            // CodeSnippet.instance.showMsg(MyStrings.signInSuccess);
            // totalContact = _listContactProvider.getTotalContact.toString();
          });
        }
        /*else if (_response.status == Constants.failed) {
          // CodeSnippet.instance.showMsg("Server is not responding");
        } else {
          // CodeSnippet.instance.showMsg("Server is not responding");
        }*/
        break;
      case ResponseIds.SIGNUP_SCREEN:
        SignUpResponse _response = any as SignUpResponse;
        if (_response.responseResult == Constants.success) {
          SharedPrefManager.instance.setStringAsync(
              Constants.userEmail, _response.result!.userEmailID!);
          SharedPrefManager.instance.setStringAsync(
              Constants.userIdNo, _response.result!.userIdNo.toString());
          Navigator.of(context).pop();
          Navigation.navigateTo(context, MyRoutes.userProfileScreen);

          // Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 0);

        } else if (_response.responseResult == Constants.failed) {
          //CodeSnippet.instance.showMsg(MyStrings.alreadyAccount);
        } else {
          // CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
    }
    super.onSuccess(any, reqId:0);
  }

  @override
  void initState() {
    super.initState();

    _playerProfileProvider =
        Provider.of<PlayerProfileProvider>(context, listen: false);
    _selectTeamProvider =
        Provider.of<SelectTeamProvider>(context, listen: false);
    _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    _signUpProvider!.initialProvider();
    // _scrollController.addListener(() => setState(() {}));
    // getTeamList();
    getRoleAsync();
    getCountryCodeAsync();
  }

  @override
  void dispose() {
    super.dispose();
    nameEditingController.dispose();
    lastNameEditingController.dispose();
    genderEditingController.dispose();
    phoneEditingController.dispose();
    dobEditingController.dispose();
    addressEditingController.dispose();
  }

  Widget build(BuildContext context) {
    if (_isEditingText && count == 0)
      Future.delayed(Duration.zero, () {
        setState(() {
          count++;
        });
      });
    final double screenHeight = MediaQuery.of(context).size.height * .87;
    final double screenHeights = MediaQuery.of(context).size.height;

      _isEditingText == true && _webDatePicker == true
        ? _isShowDial = false
        : null;

    // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        if(_isEditingText){
          Future.delayed(Duration.zero, () {
            setState(() {
              _isEditingText=false;
            });
          });
          return Future.value(false);
        }else {
          return Future.value(true);
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: MyColors.white,
          appBar: getValueForScreenType<bool>(
            context: context,
            mobile: false,
            tablet: false,
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
            child: Consumer<SignUpProvider>(builder: (context, provider, _) {
              return Form(
                key: _formKey,
                //             //Future Purpose
                //             // autovalidateMode: !provider.getAutoValidate
                //             //     ? AutovalidateMode.disabled
                //             //     : AutovalidateMode.always,
                //             autovalidate: !provider.getAutoValidate ? false : true,
                child: SafeArea(
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
                          child: SizedBox(
                            height: getValueForScreenType<bool>(
                              context: context,
                              mobile: true,
                              tablet: false,
                              desktop: false,
                            )
                                ? screenHeights
                                : getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: false,
                                    desktop: true,
                                  )
                                    ? screenHeight
                                    : null,
                            child: Scaffold(
                                backgroundColor: MyColors.white,
                                body: CustomScrollView(
                                  slivers: <Widget>[
                                    SliverAppBar(
                                      pinned: _pinned,
                                      snap: _snap,
                                      floating: _floating,
                                      expandedHeight: 255.0,
                                      flexibleSpace: FlexibleSpaceBar(
                                        centerTitle: true,
                                        background: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          color: MyColors.kPrimaryColor,
                                          child: Stack(children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  16.0),
                                              child: Stack(
                                                alignment:
                                                    Alignment.topCenter,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                      top: 120 / 2.0,
                                                    ),

                                                    ///here we create space for the circle avatar to get ut of the box
                                                    child: Container(
                                                      height: 300.0,
                                                      decoration:
                                                          BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    15.0),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .black26,
                                                            blurRadius: 8.0,
                                                            offset: Offset(
                                                                0.0, 5.0),
                                                          ),
                                                        ],
                                                      ),
                                                      width:
                                                          double.infinity,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15.0,
                                                                  bottom:
                                                                      15.0),
                                                          child: Column(
                                                            children: <
                                                                Widget>[
                                                              SizedBox(
                                                                height:
                                                                    110 / 2,
                                                              ),
                                                              Text(
                                                                profileName ==
                                                                        null
                                                                    ? ""
                                                                    : profileName!,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      24.0,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              //SizedBox(height: 110/2,),
                                                              Text(
                                                                emailEditingController
                                                                        .text
                                                                        .isEmpty
                                                                    ? ""
                                                                    : emailEditingController
                                                                        .text,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14.0),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),

                                                  Container(
                                                    width: 140,
                                                    height: 140,
                                                    decoration:
                                                        ShapeDecoration(
                                                            shape:
                                                                CircleBorder(),
                                                            color: Colors
                                                                .white),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(
                                                              8.0),
                                                      child:userProfile !=
              null && userProfile!.isNotEmpty? DecoratedBox(
                                                        decoration:
                                                            ShapeDecoration(
                                                                shape:
                                                                    CircleBorder(),
                                                                image:
                                                                    DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: MemoryImage(
                                                                          base64Decode(userProfile!),
                                                                        )
                                                                      ,
                                                                )),
                                                      ): DecoratedBox(
                                                        decoration:
                                                        ShapeDecoration(
                                                            shape:
                                                            CircleBorder(),
                                                            image:
                                                            DecorationImage(
                                                              fit: BoxFit
                                                                  .cover,
                                                              image: AssetImage(
                                                                MyImages.noImageData,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                        ),
                                        // Container(
                                        //   child:userProfile != null?Image.memory(base64Decode(userProfile),fit: BoxFit.cover,) :Image.asset(
                                        //     MyImages.noImageData,
                                        //     fit: BoxFit.fill,
                                        //   ),
                                        // ),
                                        // title: Column(
                                        //
                                        //   mainAxisAlignment:
                                        //   MainAxisAlignment.end,
                                        //   children: [
                                        //     Container(
                                        //         decoration: BoxDecoration(
                                        //         borderRadius: BorderRadius.circular(20.0),
                                        //         color: MyColors.kPrimaryColor,
                                        //       ),
                                        //       child: Padding(
                                        //         padding: const EdgeInsets.all(8.0),
                                        //         child: Text(nameEditingController.text == null
                                        //             ? ""
                                        //             : nameEditingController.text+" "+lastNameEditingController.text,
                                        //             style: TextStyle(
                                        //               fontSize:
                                        //               getValueForScreenType<
                                        //                   bool>(
                                        //                 context: context,
                                        //                 mobile: false,
                                        //                 tablet: false,
                                        //                 desktop: true,)
                                        //                   ? FontSize
                                        //                   .footerFontSize6
                                        //                   : FontSize
                                        //                   .footerFontSize6,
                                        //             )
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     /* Text(
                                        //         nameEditingController.text == null
                                        //             ? ""
                                        //             : nameEditingController.text,
                                        //         style: TextStyle(
                                        //           fontSize:
                                        //               getValueForScreenType<
                                        //                       bool>(
                                        //             context: context,
                                        //             mobile: false,
                                        //             tablet: false,
                                        //             desktop: true,
                                        //           )
                                        //                   ? FontSize
                                        //                       .footerFontSize6
                                        //                   : FontSize
                                        //                       .footerFontSize6,
                                        //         )),*/
                                        //   ],
                                        // ),

                                        // background: Image.network("https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1331&q=80",fit: BoxFit.cover,
                                      ),
                                      actions: [
                                        _isEditingText == true
                                            ? IconButton(
                                                icon: Icon(Icons.done),
                                                tooltip: MyStrings.save,
                                                onPressed: () {
                                                  _putProfile();
                                                },
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                    SliverList(
                                      delegate: SliverChildListDelegate([
                                        SingleChildScrollView(
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: MarginSize
                                                    .headerMarginVertical1,
                                                horizontal: MarginSize
                                                    .headerMarginVertical1),
                                            child:
                                                getValueForScreenType<bool>(
                                              context: context,
                                              mobile: false,
                                              tablet: true,
                                              desktop: true,
                                            )
                                                    ? Column(
                                                        children: <Widget>[
                                                          Row(
                                                              children: <
                                                                  Widget>[
                                                                _isEditingText ==
                                                                        true
                                                                    ? Expanded(
                                                                        child:
                                                                            Focus(
                                                                          focusNode:
                                                                              _node,
                                                                          onFocusChange:
                                                                              (bool focus) {
                                                                            if (kIsWeb) {
                                                                              setState(() {
                                                                                _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Listener(
                                                                            onPointerDown: (_) {
                                                                             // FocusScope.of(context).requestFocus(_node);
                                                                            },
                                                                            child: PlayerProfileDetailCardEdit(
                                                                                validator: ValidateInput.requiredFieldsFirstName,
                                                                                prefixIcon: MyIcons.username,
                                                                                inputFormatter: [
                                                                                  new LengthLimitingTextInputFormatter(25),
                                                                                ],
                                                                                labelText: MyStrings.firstName,
                                                                                height: Dimens.standard_80,
                                                                                calendarImageString: MyIcons.username,
                                                                                groupText: MyStrings.firstName,
                                                                                editingController: nameEditingController,
                                                                                // titleText: _dobController,
                                                                                titleText: nameEditingController.text),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Expanded(
                                                                        child:
                                                                            PlayerProfileDetailCard(
                                                                          calendarImageString:
                                                                              MyIcons.username,
                                                                          groupText:
                                                                              MyStrings.firstName,
                                                                          titleText:
                                                                              nameEditingController.text,
                                                                        ),
                                                                      ),
                                                                SizedBox(
                                                                    width:
                                                                        20),
                                                                /* _isEditingText == true
                                                    ? Expanded(
                                                  child:
                                                  Focus(
                                                    focusNode: _node,
                                                    onFocusChange: (bool focus) {
                                                      setState(() {

                                                        _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;

                                                      });
                                                    },
                                                    child: Listener(
                                                      onPointerDown: (_) {
                                                        FocusScope.of(context)
                                                            .requestFocus(_node);
                                                      },
                                                      child: PlayerProfileDetailCardEdit(

                                                        validator:
                                                        ValidateInput
                                                            .validateEmail,
                                                        inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                                        height: Dimens
                                                            .standard_80,
                                                        prefixIcon:
                                                        MyIcons.mail,
                                                        labelText:
                                                        MyStrings.email,
                                                        calendarImageString:
                                                        MyIcons.mail,
                                                        groupText:
                                                        MyStrings.email,
                                                        editingController:
                                                        emailEditingController,
                                                        // titleText: _dobController,
                                                        titleText:emailEditingController.text,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                    : Expanded(
                                                  child:
                                                  PlayerProfileDetailCard(
                                                    calendarImageString:
                                                    MyIcons.mail,
                                                    groupText:
                                                    MyStrings.email,
                                                    titleText:emailEditingController.text,
                                                    // titleText: _phoneController,
                                                  ),
                                                ),*/
                                                                _isEditingText ==
                                                                        true
                                                                    ? Expanded(
                                                                        child:
                                                                            Focus(
                                                                          focusNode:
                                                                              _node,
                                                                          onFocusChange:
                                                                              (bool focus) {
                                                                            if (kIsWeb) {
                                                                              setState(() {
                                                                                _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Listener(
                                                                            onPointerDown: (_) {
                                                                             // FocusScope.of(context).requestFocus(_node);
                                                                            },
                                                                            child: PlayerProfileDetailCardEdit(
                                                                              validator: ValidateInput.requiredFieldsLastName,
                                                                              inputFormatter: [
                                                                                new LengthLimitingTextInputFormatter(25),
                                                                              ],
                                                                              height: Dimens.standard_80,
                                                                              prefixIcon: MyIcons.username,
                                                                              labelText: MyStrings.lastName,
                                                                              calendarImageString: MyIcons.username,
                                                                              groupText: MyStrings.lastName,
                                                                              editingController: lastNameEditingController,
                                                                              // titleText: _dobController,
                                                                              titleText: lastNameEditingController.text,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Expanded(
                                                                        child:
                                                                            PlayerProfileDetailCard(
                                                                          calendarImageString:
                                                                              MyIcons.username,
                                                                          groupText:
                                                                              MyStrings.lastName,
                                                                          titleText:
                                                                              lastNameEditingController.text,
                                                                          // titleText: _phoneController,
                                                                        ),
                                                                      ),
                                                              ]),

                                                          Stack(children: [
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        _isEditingText == true
                                                                            ?
                                                                            // Expanded(
                                                                            //         child: PlayerProfileDetailCardEdit(
                                                                            //                 validator: ValidateInput.verifyDOB,
                                                                            //                 prefixIcon: MyIcons.cake,
                                                                            //                 labelText: MyStrings.dob,
                                                                            //                 editingController: dobEditingController,
                                                                            //                 // titleText: _dobController,
                                                                            //                 height: Dimens.standard_80,
                                                                            //                 suffixIcon: MyIcons.calendar,
                                                                            //                 onClick: (){
                                                                            //                   setState(() {
                                                                            //                     _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
                                                                            //                   });
                                                                            //                 },
                                                                            //                 titleText: _dobController),
                                                                            //       )
                                                                            Expanded(
                                                                                child: Column(
                                                                                  children: [
                                                                                    DatePickerTextfieldWidget(
                                                                                      height: Dimens.standard_80,
                                                                                      prefixIcon: null,
                                                                                      labelText: MyStrings.dob,
                                                                                      suffixIcon: MyIcons.calendar,
                                                                                      controller: dobEditingController,
                                                                                      inputAction: TextInputAction.next,
                                                                                      onFieldSubmit: (v){
                                                                                        FocusScope.of(context).requestFocus(_phonenode);

                                                                                      },
                                                                                      validator: ValidateInput.verifyDOB,
                                                                                      onTab: () {
                                                                                        setState(() {
                                                                                          _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
                                                                                        });
                                                                                      },
                                                                                      onSave: (value) {
                                                                                        dobEditingController.text = value!;
                                                                                        // print(provider.startDateController.text);

                                                                                        print(value);
                                                                                      },
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            : Expanded(
                                                                                child: PlayerProfileDetailCard(
                                                                                    calendarImageString: MyIcons.cake,
                                                                                    groupText: MyStrings.dob,
                                                                                    // titleText: _dobController,
                                                                                    titleText: dobEditingController.text),
                                                                              ),
                                                                        SizedBox(
                                                                            width: 20),
                                                                        _isEditingText == true
                                                                            ?
                                                                            // Container(
                                                                            //         height: Dimens.standard_80,
                                                                            //         child: DropdownBelow(
                                                                            //           boxDecoration: BoxDecoration(color: MyColors.white, border: Border.all(color: MyColors.colorGray_818181)),
                                                                            //           itemWidth: WidgetCustomSize.boxDecorationwidth,
                                                                            //           icon: MyIcons.arrowdownIos,
                                                                            //           itemTextstyle: TextStyle(wordSpacing: 4, fontSize: FontSize.headerFontSize2, height: WidgetCustomSize.dropdownItemHeight, fontWeight: FontWeights.headerFontWeight2, color: Colors.black),
                                                                            //           boxTextstyle: TextStyle(decorationColor: MyColors.white, backgroundColor: MyColors.white, fontSize: FontSize.footerFontSize5, fontWeight: FontWeight.w400, color: MyColors.black),
                                                                            //           boxPadding: EdgeInsets.fromLTRB(PaddingSize.boxPaddingLeft, PaddingSize.boxPaddingTop, PaddingSize.boxPaddingRight, PaddingSize.boxPaddingBottom),
                                                                            //           boxWidth: WidgetCustomSize.boxDecorationwidth,
                                                                            //           boxHeight: WidgetCustomSize.dropdownBoxHeight,
                                                                            //           hint: Text(MyStrings.chooseRole, style: Theme.of(context).textTheme.bodyText2),
                                                                            //           value: genderEditingController.text.isEmpty ? null : genderEditingController.text,
                                                                            //           items: getGender.map((Gender gen) {
                                                                            //             return new DropdownMenuItem<String>(
                                                                            //               value: gen.name,
                                                                            //               child: new Text(gen.name, style: Theme.of(context).textTheme.bodyText2),
                                                                            //             );
                                                                            //           }).toList(),
                                                                            //           onChanged: (val) {
                                                                            //             setState(() => gender = val);
                                                                            //             genderEditingController.text = val;
                                                                            //           },
                                                                            //         )
                                                                            //
                                                                            //         )

                                                                            Expanded(
                                                                                child: Container(
                                                                                  height: Dimens.standard_80,
                                                                                  child: Focus(
                                                                                    focusNode: _node,
                                                                                    onFocusChange: (bool focus) {
                                                                                      if (kIsWeb) {
                                                                                        setState(() {
                                                                                          _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                                        });
                                                                                      }
                                                                                    },
                                                                                    child: Listener(
                                                                                      onPointerDown: (_) {
                                                                                        FocusScope.of(context).requestFocus(_node);
                                                                                      },
                                                                                      child: DropdownBelow(
                                                                                        boxDecoration: BoxDecoration(
                                                                                            // color: MyColors.white,
                                                                                            border: Border.all(color: MyColors.colorGray_818181)),
                                                                                        itemWidth: getValueForScreenType<bool>(
                                                                                          context: context,
                                                                                          mobile: true,
                                                                                          tablet: false,
                                                                                          desktop: false,
                                                                                        )
                                                                                            ? size.width * 0.4
                                                                                            : getValueForScreenType<bool>(
                                                                                                context: context,
                                                                                                mobile: false,
                                                                                                tablet: true,
                                                                                                desktop: false,
                                                                                              )
                                                                                                ? size.width * 0.2
                                                                                                : size.width * 0.21,
                                                                                        icon: MyIcons.arrowdownIos,
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
                                                                                        boxPadding: EdgeInsets.fromLTRB(PaddingSize.boxPaddingLeft, PaddingSize.boxPaddingTop, PaddingSize.boxPaddingRight, PaddingSize.boxPaddingBottom),
                                                                                        boxWidth: size.width * WidgetCustomSize.dropdownBoxWidth,
                                                                                        boxHeight: WidgetCustomSize.dropdownBoxHeight,
                                                                                        hint: Text(MyStrings.gender,
                                                                                            style: TextStyle(
                                                                                              color: MyColors.colorGray_818181,
                                                                                              fontFamily: 'OswaldLight',
                                                                                              fontSize: 16,
                                                                                              height: 1,
                                                                                            )),
                                                                                        value: genderEditingController.text.isEmpty ? null : genderEditingController.text,
                                                                                        items: getGender.map((Gender gen) {
                                                                                          return new DropdownMenuItem<String>(
                                                                                            value: gen.name,
                                                                                            child: new Text(gen.name, style: Theme.of(context).textTheme.bodyText2),
                                                                                          );
                                                                                        }).toList(),
                                                                                        onChanged: (val) {
                                                                                          setState(() => gender = val.toString());
                                                                                          genderEditingController.text = val.toString();
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )

                                                                            //
                                                                            //
                                                                            //
                                                                            // Expanded(
                                                                            //         child:
                                                                            //             PlayerProfileDetailCardEdit(
                                                                            //               validator: ValidateInput.validateName,
                                                                            //           height: Dimens
                                                                            //               .standard_80,
                                                                            //               prefixIcon: MyIcons.face,
                                                                            //               labelText: MyStrings.gender,
                                                                            //           calendarImageString:
                                                                            //               MyIcons.face,
                                                                            //           groupText:
                                                                            //               MyStrings
                                                                            //                   .gender,
                                                                            //           editingController:
                                                                            //               genderEditingController,
                                                                            //           // titleText: _dobController,
                                                                            //           titleText:
                                                                            //               _genderController ==
                                                                            //                       "M"
                                                                            //                   ? MyStrings
                                                                            //                       .male
                                                                            //                   : MyStrings
                                                                            //                       .male,
                                                                            //         ),
                                                                            //       )
                                                                            : Expanded(
                                                                                child: PlayerProfileDetailCard(
                                                                                  calendarImageString: MyIcons.face,
                                                                                  groupText: MyStrings.gender,
                                                                                  titleText: genderEditingController.text,
                                                                                ),
                                                                              ),
                                                                      ]),
                                                                ),
                                                                // DropdownButtonFormField(
                                                                //   isExpanded: true,
                                                                //   items: getGender
                                                                //       .map((Gender gen) => DropdownMenuItem<String>(
                                                                //       value: gen.name, child: Text( gen.name)))
                                                                //       .toList(),
                                                                //   decoration: InputDecoration(
                                                                //     border: OutlineInputBorder(),
                                                                //     labelText: 'State',
                                                                //   ),
                                                                //   onChanged: (val) {
                                                                //     setState(() {
                                                                //       setState(() =>
                                                                //       gender = val);
                                                                //       genderEditingController
                                                                //           .text =
                                                                //           val;
                                                                //     });
                                                                //   },
                                                                // ),
                                                                Row(children: <
                                                                    Widget>[
                                                                  _isEditingText ==
                                                                          true
                                                                      ? Expanded(
                                                                          child:
                                                                              Focus(
                                                                            focusNode: _node,
                                                                            onFocusChange: (bool focus) {
                                                                              if (kIsWeb) {
                                                                                setState(() {
                                                                                  _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Listener(
                                                                              onPointerDown: (_) {
                                                                              //  FocusScope.of(context).requestFocus(_node);
                                                                              },
                                                                              child: PlayerProfileDetailCardEdit(
                                                                                hintText: MyStrings.noFormat,
                                                                                validator: ValidateInput.validateMobile,
                                                                                focusNode: _phonenode,
                                                                                inputFormatter: <TextInputFormatter>[
                                                                                  FilteringTextInputFormatter.digitsOnly,
                                                                                  new LengthLimitingTextInputFormatter(10)
                                                                                ],
                                                                                prefixIcon: MyIcons.phone,
                                                                                labelText: MyStrings.contactPhone,
                                                                                height: Dimens.standard_80,
                                                                                editingController: phoneEditingController,
                                                                                /* helperText:
                                                                        phoneEditingController.text,*/
                                                                                // titleText: _dobController,
                                                                                /*prefix:
                                                                        _phoneController,*/
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PlayerProfileDetailCard(
                                                                            calendarImageString: MyIcons.phone,
                                                                            groupText: MyStrings.contactPhone,
                                                                            titleText: phoneEditingController.text,
                                                                            // titleText: _phoneController,
                                                                          ),
                                                                        ),
                                                                  SizedBox(
                                                                      width:
                                                                          20),
                                                                  _isEditingText ==
                                                                          true
                                                                      ? Expanded(
                                                                          child:
                                                                              Focus(
                                                                            focusNode: _node,
                                                                            onFocusChange: (bool focus) {
                                                                              if (kIsWeb) {
                                                                                setState(() {
                                                                                  _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Listener(
                                                                              onPointerDown: (_) {
                                                                               // FocusScope.of(context).requestFocus(_node);
                                                                              },
                                                                              child: PlayerProfileDetailCardEdit(
                                                                                height: Dimens.standard_80,
                                                                                calendarImageString: MyIcons.cancelj,
                                                                                inputFormatter: [
                                                                                  new LengthLimitingTextInputFormatter(50),
                                                                                ],
                                                                                prefixIcon: MyIcons.cancelj,
                                                                                labelText: MyStrings.address1,
                                                                                groupText: MyStrings.address1,
                                                                                editingController: addressEditingController,
                                                                                titleText: addressEditingController.text,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PlayerProfileDetailCard(
                                                                            calendarImageString: MyIcons.cancelj,
                                                                            groupText: MyStrings.address1,
                                                                            titleText: addressEditingController.text,
                                                                          ),
                                                                        ),
                                                                ]),

                                                                Row(children: <
                                                                    Widget>[
                                                                  _isEditingText ==
                                                                          true
                                                                      ? Expanded(
                                                                          child:
                                                                              Focus(
                                                                            focusNode: _node,
                                                                            onFocusChange: (bool focus) {
                                                                              if (kIsWeb) {
                                                                                setState(() {
                                                                                  _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Listener(
                                                                              onPointerDown: (_) {
                                                                              //  FocusScope.of(context).requestFocus(_node);
                                                                              },
                                                                              child: PlayerProfileDetailCardEdit(
                                                                                height: Dimens.standard_80,
                                                                                calendarImageString: MyIcons.cancelj,
                                                                                inputFormatter: [
                                                                                  new LengthLimitingTextInputFormatter(50),
                                                                                ],
                                                                                prefixIcon: MyIcons.cancelj,
                                                                                labelText: MyStrings.altaddress,
                                                                                groupText: MyStrings.altaddress,
                                                                                editingController: altaddressEditingController,
                                                                                titleText: altaddressEditingController.text,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PlayerProfileDetailCard(
                                                                            calendarImageString: MyIcons.cancelj,
                                                                            groupText: MyStrings.altaddress,
                                                                            titleText: altaddressEditingController.text,
                                                                            // titleText: _phoneController,
                                                                          ),
                                                                        ),
                                                                  SizedBox(
                                                                      width:
                                                                          20),
                                                                  _isEditingText ==
                                                                          true
                                                                      ? Expanded(
                                                                          child:
                                                                              Focus(
                                                                            focusNode: _node,
                                                                            onFocusChange: (bool focus) {
                                                                              if (kIsWeb) {
                                                                                setState(() {
                                                                                  _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Listener(
                                                                              onPointerDown: (_) {
                                                                              //  FocusScope.of(context).requestFocus(_node);
                                                                              },
                                                                              child: PlayerProfileDetailCardEdit(
                                                                                height: Dimens.standard_80,
                                                                                calendarImageString: MyIcons.cancelj,
                                                                                inputFormatter: [
                                                                                  new LengthLimitingTextInputFormatter(25),
                                                                                ],
                                                                                prefixIcon: MyIcons.cancelj,
                                                                                labelText: MyStrings.city,
                                                                                groupText: MyStrings.city,
                                                                                editingController: cityEditingController,
                                                                                titleText: cityEditingController.text,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PlayerProfileDetailCard(
                                                                            calendarImageString: MyIcons.cancelj,
                                                                            groupText: MyStrings.city,
                                                                            titleText: cityEditingController.text,
                                                                            // titleText: _phoneController,
                                                                          ),
                                                                        ),
                                                                ]),

                                                                Row(children: <
                                                                    Widget>[
                                                                  _isEditingText ==
                                                                          true
                                                                      ? Expanded(
                                                                          child:
                                                                              Focus(
                                                                            focusNode: _node,
                                                                            onFocusChange: (bool focus) {
                                                                              if (kIsWeb) {
                                                                                setState(() {
                                                                                  _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Listener(
                                                                              onPointerDown: (_) {
                                                                              //  FocusScope.of(context).requestFocus(_node);
                                                                              },
                                                                              child: PlayerProfileDetailCardEdit(
                                                                                height: Dimens.standard_80,
                                                                                calendarImageString: MyIcons.cancelj,
                                                                                inputFormatter: [
                                                                                  new LengthLimitingTextInputFormatter(25),
                                                                                ],
                                                                                prefixIcon: MyIcons.cancelj,
                                                                                labelText: MyStrings.state,
                                                                                groupText: MyStrings.state,
                                                                                inputAction: TextInputAction.next,
                                                                                onFieldSubmit: (v){
                                                                                  FocusScope.of(context).requestFocus(_zipnode);
                                                                                },
                                                                                editingController: sateEditingController,
                                                                                titleText: sateEditingController.text,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PlayerProfileDetailCard(
                                                                            calendarImageString: MyIcons.cancelj,
                                                                            groupText: MyStrings.state,
                                                                            titleText: sateEditingController.text,
                                                                          ),
                                                                        ),
                                                                  SizedBox(
                                                                      width:
                                                                          20),
                                                                  _isEditingText ==
                                                                          true
                                                                      ? Expanded(
                                                                          child:
                                                                              Focus(
                                                                            focusNode: _node,
                                                                            onFocusChange: (bool focus) {
                                                                              if (kIsWeb) {
                                                                                setState(() {
                                                                                  _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;
                                                                                });
                                                                              }
                                                                            },
                                                                            child: Listener(
                                                                              onPointerDown: (_) {
                                                                              //  FocusScope.of(context).requestFocus(_node);
                                                                              },
                                                                              child: PlayerProfileDetailCardEdit(
                                                                                height: Dimens.standard_80,
                                                                                calendarImageString: MyIcons.cancelj,
                                                                                inputFormatter: [
                                                                                  new LengthLimitingTextInputFormatter(10),
                                                                                ],
                                                                                prefixIcon: MyIcons.cancelj,
                                                                                focusNode: _zipnode,
                                                                                labelText: MyStrings.zipcode,
                                                                                groupText: MyStrings.zipcode,
                                                                                isLast: true,
                                                                                inputAction: TextInputAction.done,
                                                                                editingController: zipEditingController,
                                                                                titleText: zipEditingController.text,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Expanded(
                                                                          child:
                                                                              PlayerProfileDetailCard(
                                                                            calendarImageString: MyIcons.cancelj,
                                                                            groupText: MyStrings.zipcode,
                                                                            titleText: zipEditingController.text,
                                                                          ),
                                                                        ),
                                                                ]),
                                                              ],
                                                            ),
                                                            _isEditingText ==
                                                                        true &&
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
                                                                    child:
                                                                        Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Card(
                                                                            margin: const EdgeInsets.only(right: 8.0, left: 0.0, top: 50.0, bottom: 0),
                                                                            elevation: 10,
                                                                            shadowColor: MyColors.colorGray_666BC,
                                                                            child: SfDateRangePicker(
                                                                            initialSelectedDate: _selectedDate,
                                                                              initialDisplayDate: _selectedDate,
                                                                              view: DateRangePickerView.month,
                                                                              todayHighlightColor: MyColors.red,
                                                                              allowViewNavigation: true,
                                                                              showNavigationArrow: true,
                                                                              navigationMode: DateRangePickerNavigationMode.snap,
                                                                              endRangeSelectionColor: MyColors.kPrimaryColor,
                                                                              rangeSelectionColor: MyColors.kPrimaryColor,
                                                                              selectionColor: MyColors.kPrimaryColor,
                                                                              startRangeSelectionColor: MyColors.kPrimaryColor,
                                                                              onSelectionChanged: _onSelectionChanged,
                                                                              selectionMode: DateRangePickerSelectionMode.single,
                                                                              onSubmit: (value) {
                                                                                setState(() {
                                                                                  dobEditingController.text = value.toString();
                                                                                });
                                                                                // Navigator.pop(context);
                                                                              },
                                                                              initialSelectedRange: PickerDateRange(DateTime.now().subtract(const Duration(days: 4)), DateTime.now().add(const Duration(days: 3))),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child: SizedBox(
                                                                          width:
                                                                              300,
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                          ]),

                                                          // _isEditingText == false ? Column(
                                                          //   children: [
                                                          //     Text(
                                                          //       MyStrings.selectTeam,
                                                          //       style: TextStyle(
                                                          //           fontSize: 22,
                                                          //           fontWeight:
                                                          //           FontWeight.w500),
                                                          //     ),
                                                          //     _selectTeamProvider
                                                          //         .getTeamList !=
                                                          //         null &&
                                                          //         _selectTeamProvider
                                                          //             .getTeamList
                                                          //             .length >
                                                          //             0
                                                          //         ? ListView.builder(
                                                          //       physics:
                                                          //       NeverScrollableScrollPhysics(),
                                                          //       shrinkWrap:
                                                          //       true, // new
                                                          //       itemCount: _selectTeamProvider
                                                          //           .getTeamList
                                                          //           .length ==
                                                          //           null
                                                          //           ? 0
                                                          //           : _selectTeamProvider
                                                          //           .getTeamList
                                                          //           .length,
                                                          //       itemBuilder:
                                                          //           (BuildContext
                                                          //       context,
                                                          //           int index) {
                                                          //         return MenuScreenCard(
                                                          //           icon:
                                                          //           MyIcons.sport,
                                                          //           title:
                                                          //           "${_selectTeamProvider
                                                          //               .getTeamList[index].teamName}",
                                                          //           onPressed: () {
                                                          //             SharedPrefManager
                                                          //                 .instance
                                                          //                 .setStringAsync(
                                                          //                 Constants
                                                          //                     .teamName,
                                                          //                 _selectTeamProvider
                                                          //                     .getTeamList[index]
                                                          //                     .teamName);
                                                          //             Navigation
                                                          //                 .navigateWithArgument(
                                                          //                 context,
                                                          //                 MyRoutes
                                                          //                     .homeScreen,
                                                          //                 0);
                                                          //             //Navigation.navigateWithArgument(context, MyRoutes.homeScreen,_selectTeamProvider.getTeamList[index].teamName);
                                                          //           },
                                                          //         );
                                                          //       },
                                                          //     )
                                                          //         : Container(
                                                          //         child: Column(
                                                          //           mainAxisAlignment:
                                                          //           MainAxisAlignment
                                                          //               .center,
                                                          //           crossAxisAlignment:
                                                          //           CrossAxisAlignment
                                                          //               .center,
                                                          //           children: [
                                                          //             Text(
                                                          //               MyStrings
                                                          //                   .noTeamsAvailable,
                                                          //               style: TextStyle(
                                                          //                 fontSize: FontSize
                                                          //                     .headerFontSize4,
                                                          //               ),
                                                          //             ),
                                                          //           ],
                                                          //         ))
                                                          //   ],
                                                          // ) : SizedBox(),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: <Widget>[
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                    /*  FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child: PlayerProfileDetailCardEdit(
                                                                        validator: ValidateInput.requiredFieldsFirstName,
                                                                        inputFormatter: [
                                                                          new LengthLimitingTextInputFormatter(25),
                                                                        ],
                                                                        prefixIcon: MyIcons.username,
                                                                        labelText: MyStrings.firstName,
                                                                        height: Dimens.standard_80,
                                                                        calendarImageString: MyIcons.username,
                                                                        groupText: MyStrings.firstName,
                                                                        editingController: nameEditingController,
                                                                        // titleText: _dobController,
                                                                        titleText: nameEditingController.text),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .username,
                                                                  groupText:
                                                                      MyStrings
                                                                          .firstName,
                                                                  titleText:
                                                                      nameEditingController
                                                                          .text,
                                                                ),
                                                          /*_isEditingText == true
                                                  ? Expanded(
                                                child:
                                                Focus(
                                                  focusNode: _node,
                                                  onFocusChange: (bool focus) {
                                                    setState(() {

                                                      _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;

                                                    });
                                                  },
                                                  child: Listener(
                                                    onPointerDown: (_) {
                                                      FocusScope.of(context)
                                                          .requestFocus(_node);
                                                    },
                                                    child: PlayerProfileDetailCardEdit(

                                                      validator:
                                                      ValidateInput
                                                          .validateEmail,
                                                      inputFormatter: [new LengthLimitingTextInputFormatter(100),],

                                                      height: Dimens
                                                          .standard_80,
                                                      prefixIcon:
                                                      MyIcons.mail,
                                                      labelText:
                                                      MyStrings.email,
                                                      calendarImageString:
                                                      MyIcons.mail,
                                                      groupText:
                                                      MyStrings.email,
                                                      editingController:
                                                      emailEditingController,
                                                      // titleText: _dobController,
                                                      titleText:emailEditingController.text,
                                                    ),
                                                  ),
                                                ),
                                              )
                                                  : Expanded(
                                                child:
                                                PlayerProfileDetailCard(
                                                  calendarImageString:
                                                  MyIcons.mail,
                                                  groupText:
                                                  MyStrings.email,
                                                  titleText:emailEditingController.text,
                                                  // titleText: _phoneController,
                                                ),
                                              ),
*/
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                     /* FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child:
                                                                        PlayerProfileDetailCardEdit(
                                                                      validator:
                                                                          ValidateInput.requiredFieldsLastName,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            25),
                                                                      ],

                                                                      height:
                                                                          Dimens.standard_80,
                                                                      prefixIcon:
                                                                          MyIcons.username,
                                                                      labelText:
                                                                          MyStrings.lastName,
                                                                      calendarImageString:
                                                                          MyIcons.username,
                                                                      groupText:
                                                                          MyStrings.lastName,
                                                                      editingController:
                                                                          lastNameEditingController,
                                                                      // titleText: _dobController,
                                                                      titleText:
                                                                          lastNameEditingController.text,
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .username,
                                                                  groupText:
                                                                      MyStrings
                                                                          .lastName,
                                                                  titleText:
                                                                      lastNameEditingController
                                                                          .text,
                                                                  // titleText: _phoneController,
                                                                ),
                                                          _isEditingText ==
                                                                  true
                                                              ? Column(
                                                                  children: [
                                                                    DatePickerTextfieldWidget(
                                                                      height:
                                                                          Dimens.standard_80,
                                                                      prefixIcon:
                                                                          null,
                                                                      labelText:
                                                                          MyStrings.dob,
                                                                      suffixIcon:
                                                                          MyIcons.calendar,
                                                                      controller:
                                                                          dobEditingController,
                                                                      onFieldSubmit: (v){
                                                                        FocusScope.of(context).requestFocus(_phonenode2);

                                                                      },
                                                                      validator:
                                                                          ValidateInput.verifyDOB,
                                                                      onTab:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          _webDatePicker == true
                                                                              ? _webDatePicker = false
                                                                              : _webDatePicker = true;
                                                                        });
                                                                      },
                                                                      onSave:
                                                                          (value) {
                                                                        dobEditingController.text =
                                                                            value!;
                                                                        // print(provider.startDateController.text);

                                                                        print(
                                                                            value);
                                                                      },
                                                                    ),
                                                                  ],
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .cake,
                                                                  groupText:
                                                                      MyStrings
                                                                          .dob,
                                                                  // titleText: _dobController,
                                                                  titleText:
                                                                      dobEditingController
                                                                          .text),
                                                          _isEditingText ==
                                                                  true
                                                              ? Container(
                                                                  height: Dimens
                                                                      .standard_80,
                                                                  child:
                                                                      Focus(
                                                                    focusNode:
                                                                        _node,
                                                                    onFocusChange:
                                                                        (bool
                                                                            focus) {
                                                                      if (kIsWeb) {
                                                                        setState(
                                                                            () {
                                                                          _webDatePicker == true
                                                                              ? _webDatePicker = false
                                                                              : _webDatePicker = false;
                                                                        });
                                                                      }
                                                                    },
                                                                    child:
                                                                        Listener(
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
                                                                        itemWidth: getValueForScreenType<bool>(
                                                                          context:
                                                                              context,
                                                                          mobile:
                                                                              true,
                                                                          tablet:
                                                                              false,
                                                                          desktop:
                                                                              false,
                                                                        )
                                                                            ? size.width - 38
                                                                            : getValueForScreenType<bool>(
                                                                                context: context,
                                                                                mobile: false,
                                                                                tablet: true,
                                                                                desktop: false,
                                                                              )
                                                                                ? size.width * 0.2
                                                                                : size.width * 0.21,
                                                                        icon:
                                                                            MyIcons.arrowdownIos,
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
                                                                            size.width * WidgetCustomSize.dropdownBoxWidth,
                                                                        boxHeight:
                                                                            WidgetCustomSize.dropdownBoxHeight,
                                                                        hint: Text(
                                                                            MyStrings.gender,
                                                                            style: TextStyle(
                                                                              color: MyColors.colorGray_818181,
                                                                              fontFamily: 'OswaldLight',
                                                                              fontSize: 16,
                                                                              height: 1,
                                                                            )),
                                                                        value: genderEditingController.text.isEmpty
                                                                            ? null
                                                                            : genderEditingController.text,
                                                                        items:
                                                                            getGender.map((Gender gen) {
                                                                          return new DropdownMenuItem<String>(
                                                                            value: gen.name,
                                                                            child: new Text(gen.name, style: Theme.of(context).textTheme.bodyText2),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (val) {
                                                                          setState(() =>
                                                                              gender = val.toString());
                                                                          genderEditingController.text =
                                                                              val.toString();
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .face,
                                                                  groupText:
                                                                      MyStrings
                                                                          .gender,
                                                                  titleText:
                                                                      genderEditingController
                                                                          .text,
                                                                ),
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                     /* FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child:
                                                                        PlayerProfileDetailCardEdit(
                                                                      hintText:
                                                                          MyStrings.noFormat,
                                                                      validator:
                                                                          ValidateInput.validateMobile,
                                                                      prefixIcon:
                                                                          MyIcons.phone,
                                                                      inputFormatter: <
                                                                          TextInputFormatter>[
                                                                        FilteringTextInputFormatter
                                                                            .digitsOnly,
                                                                        new LengthLimitingTextInputFormatter(10)

                                                                      ],
                                                                      labelText:
                                                                          MyStrings.contactPhone,
                                                                      focusNode: _phonenode2,
                                                                      height:
                                                                          Dimens.standard_80,
                                                                      editingController:
                                                                          phoneEditingController,
                                                                      /* helperText:
                                                                  phoneEditingController.text,*/
                                                                      // titleText: _dobController,
                                                                      /*prefix:
                                                                  _phoneController,*/
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .phone,
                                                                  groupText:
                                                                      MyStrings
                                                                          .contactPhone,
                                                                  titleText:
                                                                      phoneEditingController
                                                                          .text,
                                                                  // titleText: _phoneController,
                                                                ),
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                     /* FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child:
                                                                        PlayerProfileDetailCardEdit(
                                                                      height:
                                                                          Dimens.standard_80,

                                                                      prefixIcon:
                                                                          MyIcons.cancelj,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            50),
                                                                      ],
                                                                      labelText:
                                                                          MyStrings.address1,

                                                                      editingController:
                                                                          addressEditingController,
                                                                      //hintText: MyStrings.noFormat,
                                                                      // titleText:
                                                                      // addressEditingController.text,
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .cancelj,
                                                                  groupText:
                                                                      MyStrings
                                                                          .address1,
                                                                  titleText:
                                                                      addressEditingController
                                                                          .text,
                                                                ),
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                     /* FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child:
                                                                        PlayerProfileDetailCardEdit(
                                                                      height:
                                                                          Dimens.standard_80,

                                                                      prefixIcon:
                                                                          MyIcons.cancelj,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            50),
                                                                      ],
                                                                      labelText:
                                                                          MyStrings.altaddress,

                                                                      editingController:
                                                                          altaddressEditingController,
                                                                      //hintText: MyStrings.noFormat,
                                                                      // titleText:
                                                                      // addressEditingController.text,
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .cancelj,
                                                                  groupText:
                                                                      MyStrings
                                                                          .altaddress,
                                                                  titleText:
                                                                      altaddressEditingController
                                                                          .text,
                                                                ),
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                     /* FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child:
                                                                        PlayerProfileDetailCardEdit(
                                                                      height:
                                                                          Dimens.standard_80,

                                                                      prefixIcon:
                                                                          MyIcons.cancelj,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            25),
                                                                      ],
                                                                      labelText:
                                                                          MyStrings.city,

                                                                      editingController:
                                                                          cityEditingController,
                                                                      //hintText: MyStrings.noFormat,
                                                                      // titleText:
                                                                      // addressEditingController.text,
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .cancelj,
                                                                  groupText:
                                                                      MyStrings
                                                                          .city,
                                                                  titleText:
                                                                      cityEditingController
                                                                          .text,
                                                                ),
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                     /* FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child:
                                                                        PlayerProfileDetailCardEdit(
                                                                      height:
                                                                          Dimens.standard_80,

                                                                      prefixIcon:
                                                                          MyIcons.cancelj,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            25),
                                                                      ],
                                                                      labelText:
                                                                          MyStrings.state,
                                                                      inputAction: TextInputAction.next,
                                                                      onFieldSubmit: (v){
                                                                       FocusScope.of(context).requestFocus(_zipnode);
                                                                      },
                                                                      editingController:
                                                                          sateEditingController,
                                                                      //hintText: MyStrings.noFormat,
                                                                      // titleText:
                                                                      // addressEditingController.text,
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .cancelj,
                                                                  groupText:
                                                                      MyStrings
                                                                          .state,
                                                                  titleText:
                                                                      sateEditingController
                                                                          .text,
                                                                ),
                                                          _isEditingText ==
                                                                  true
                                                              ? Focus(
                                                                  focusNode:
                                                                      _node,
                                                                  onFocusChange:
                                                                      (bool
                                                                          focus) {
                                                                    if (kIsWeb) {
                                                                      setState(
                                                                          () {
                                                                        _webDatePicker == true
                                                                            ? _webDatePicker = false
                                                                            : _webDatePicker = false;
                                                                      });
                                                                    }
                                                                  },
                                                                  child:
                                                                      Listener(
                                                                    onPointerDown:
                                                                        (_) {
                                                                     /* FocusScope.of(context)
                                                                          .requestFocus(_node);*/
                                                                    },
                                                                    child:
                                                                        PlayerProfileDetailCardEdit(
                                                                      height:
                                                                          Dimens.standard_80,

                                                                      prefixIcon:
                                                                          MyIcons.cancelj,
                                                                          focusNode: _zipnode,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            10),
                                                                      ],
                                                                      labelText:
                                                                          MyStrings.zipcode,
                                                                      isLast: true,
                                                                      inputAction: TextInputAction.done,
                                                                      editingController:
                                                                          zipEditingController,
                                                                      //hintText: MyStrings.noFormat,
                                                                      // titleText:
                                                                      // addressEditingController.text,
                                                                    ),
                                                                  ),
                                                                )
                                                              : PlayerProfileDetailCard(
                                                                  calendarImageString:
                                                                      MyIcons
                                                                          .cancelj,
                                                                  groupText:
                                                                      MyStrings
                                                                          .zipcode,
                                                                  titleText:
                                                                      zipEditingController
                                                                          .text,
                                                                ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      ),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                                floatingActionButton: Visibility(
                                  visible: getValueForScreenType<bool>(
                                    context: context,
                                    mobile: false,
                                    tablet: true,
                                    desktop: true,
                                  )
                                      ? _isShowDial
                                      : false,
                                  child: FloatingActionButton(
                                    backgroundColor: MyColors.kPrimaryColor,
                                    tooltip: MyStrings.editPlayer,
                                    child: MyIcons.edit_white,
                                    onPressed: () {
                                      setState(() {
                                        _isEditingText = true;
                                        _isShowDial = false;
                                      });
                                      // Navigation.navigateWithArgument(context, MyRoutes.editPlayersScreen, widget.userId);
                                    },
                                  ),
                                )
                                // floatingActionButton:
                                // _getFloatingActionButton(),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          floatingActionButton: Visibility(
            visible: getValueForScreenType<bool>(
              context: context,
              mobile: true,
              tablet: false,
              desktop: false,
            )
                ? _isShowDial
                : false,
            child: FloatingActionButton(
              backgroundColor: MyColors.kPrimaryColor,
              tooltip: MyStrings.editPlayer,
              child: MyIcons.edit_white,
              onPressed: () {
                setState(() {
                  _isEditingText = true;
                  _isShowDial = false;
                });

                // Navigation.navigateWithArgument(context, MyRoutes.editPlayersScreen, widget.userId);
              },
            ),
          )),
    );
  }

  Widget _getFloatingActionButton() {
    return SpeedDialMenuButton(
      isEnableAnimation: true,
      //if needed to close the menu after clicking sub-FAB
      isShowSpeedDial: _isShowDial,
      //manually open or close menu
      updateSpeedDialStatus: (isShow) {
        //return any open or close change within the widget
        this._isShowDial = isShow;
      },
      //general init
      isMainFABMini: false,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
          mini: false,
          child: MyIcons.more_vert,
          onPressed: () {},
          closeMenuChild: Icon(Icons.close),
          closeMenuForegroundColor: MyColors.white,
          closeMenuBackgroundColor: MyColors.kPrimaryColor),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
        FloatingActionButton(
          tooltip: MyStrings.editPlayer,
          mini: true,
          child: MyIcons.edit,
          onPressed: () {
            setState(() {
              _isEditingText = true;
              _isShowDial = false;
            });
            // Navigation.navigateWithArgument(context, MyRoutes.editPlayersScreen, widget.userId);
          },
        ),
        FloatingActionButton(
          tooltip: MyStrings.createTeam,
          mini: true,
          disabledElevation: 3,
          child: MyIcons.add,
          onPressed: () {
            setState(() {
              _isShowDial = false;
            });
            Navigation.navigateTo(context, MyRoutes.createTeamScreen);
          },
        )
      ],
      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 50.0,
    );
  }
}

class Language {
  final int id;
  final String name;

  const Language(
    this.id,
    this.name,
  );
}

List<S2Choice<String>> _choiceRepeat = [
  S2Choice<String>(value: '-10001', title: MyStrings.managerRole),
  S2Choice<String>(value: '-10002', title: MyStrings.playerRole),

  //Future Purpose

  /* S2Choice<String>(value: '-10001', title: MyStrings.ownerRole),
   S2Choice<String>(value: '-10003', title: MyStrings.nonPlayerRole),
  S2Choice<String>(value: '-10004', title: MyStrings.familyRole),*/
];
const List<Language> getLanguages = <Language>[
  Language(
    -10001,
    'Coach/Manager',
  ),
  Language(
    -10002,
    'Player',
  ),
  //Future Purpose

  /* Language(
    -10003,
    'Nonplayer',
  ),
  Language(
    -10004,
    'Family',
  ),*/
];

// import 'package:dropdown_below/dropdown_below.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
// import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:smart_select/smart_select.dart';
// import 'package:spaid/base/base_state.dart';
// import 'package:spaid/model/response/base_response.dart';
// import 'package:spaid/model/response/select_team_response/select_team_response.dart';
// import 'package:spaid/service/exception_error_util.dart';
// import 'package:spaid/support/colors.dart';
// import 'package:spaid/support/constants.dart';
// import 'package:spaid/support/dimens.dart';
// import 'package:spaid/support/icons.dart';
// import 'package:spaid/support/images.dart';
// import 'package:spaid/support/response_ids.dart';
// import 'package:spaid/support/routes.dart';
// import 'package:spaid/support/strings.dart';
// import 'package:spaid/support/style_sizes.dart';
// import 'package:spaid/support/validate_input.dart';
// import 'package:spaid/ui/add_player_screen/add_player_screen.dart';
// import 'package:spaid/ui/player_profile_screen/player_profile_screen_provider.dart';
// import 'package:spaid/ui/select_team_screen/select_team_screen_provider.dart';
// import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
// import 'package:spaid/utils/code_snippet.dart';
// import 'package:spaid/utils/navigation.dart';
// import 'package:spaid/utils/shared_pref_manager.dart';
// import 'package:spaid/widgets/custom_appbar.dart';
// import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
// import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
// import 'package:spaid/widgets/custom_datepicker.dart';
// import 'package:spaid/widgets/custom_editable_text.dart';
// import 'package:spaid/widgets/custom_simple_appbar.dart';
// import 'package:spaid/widgets/menu_screen_card.dart';
// import 'package:spaid/widgets/player_profile_detail_card.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   final int userId;
//
//   UserProfileScreen(this.userId);
//
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// String role;
//
// String initialText = "Arivu";
//
// class _UserProfileScreenState extends BaseState<UserProfileScreen> {
//   @override
//   List userdata;
//   bool _pinned = true;
//   bool _snap = false;
//   bool _floating = false;
//   bool _isShowDial = true;
//   bool _webDatePicker = false;
//   bool _isEditingText = false;
//   final _formKey = GlobalKey<FormState>();
//   DateTime _selectedDate = DateTime.now();
//   String _dateCount = '';
//   String _range = '';
//   String _rangeCount = '';
//   PlayerProfileProvider _playerProfileProvider;
//   SignUpProvider _signUpProvider;
//   String _firstNameController,
//       _dobController,
//       _phoneController,
//       _addressController,
//       _genderController;
//   String dateformat, first;
//   FocusNode _node = new FocusNode();
//   String gender;
//
//   getTeamList() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // ProgressBar.instance.showProgressbar(context);
//     });
//     _playerProfileProvider.listener = this;
//     _playerProfileProvider.getSelectTeamAsync(0);
//   }
//
//   void _putProfile() async {
//     FocusScope.of(context).requestFocus(FocusNode());
//     if (_formKey.currentState.validate()) {
//       _formKey.currentState.save();
//       Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 0);
//       // _signUpProvider.performSignup();
//     }
//   }
//
//   void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
//     setState(() {
//       if (args.value is PickerDateRange) {
//         _range =
//             DateFormat('dd/mm/yyyy').format(args.value.startDate).toString() +
//                 ' - ' +
//                 DateFormat('dd/mm/yyyy')
//                     .format(args.value.endDate ?? args.value.startDate)
//                     .toString();
//       } else if (args.value is DateTime) {
//         _selectedDate = args.value;
//         // DatepickerController.text = _selectedDate.toString();
//         DatepickerController
//           ..text = dateformat == "US"
//               ? DateFormat("mm/dd/yyyy").format(_selectedDate)
//               : dateformat == "CA"
//               ? DateFormat("yyyy/mm/dd").format(_selectedDate)
//               : DateFormat("dd/mm/yyyy").format(_selectedDate)
//           ..selection = TextSelection.fromPosition(TextPosition(
//               offset: DatepickerController.text.length,
//               affinity: TextAffinity.upstream));
//
//         print("ll" + _selectedDate.toString());
//       } else if (args.value is List<DateTime>) {
//         _dateCount = args.value.length.toString();
//       } else {
//         _rangeCount = args.value.length.toString();
//       }
//       _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
//     });
//   }
//
//   @override
//   void onFailure(BaseResponse error) {
//     // ProgressBar.instance.stopProgressBar();
//     // CodeSnippet.instance.showMsg(error.errorMessage);
//   }
//
//   SelectTeamProvider _selectTeamProvider;
//   ScrollController _scrollController;
//   TextEditingController nameEditingController = TextEditingController();
//   TextEditingController genderEditingController = TextEditingController();
//   TextEditingController phoneEditingController = TextEditingController();
//   TextEditingController emailEditingController = TextEditingController();
//   TextEditingController dobEditingController = TextEditingController();
//   TextEditingController addressEditingController = TextEditingController();
//   TextEditingController DatepickerController = TextEditingController();
//
//   //endregion
//
//   getTeamsList() {
//     //Future Purpose
//
//     /* WidgetsBinding.instance.addPostFrameCallback((_) {
//       ProgressBar.instance.showProgressbar(context);
//     });*/
//     _selectTeamProvider.listener = this;
//     _selectTeamProvider.getSelectTeamAsync(context);
//   }
//
//   /*
// Return Type:
// Input Parameters: SharedPrefManager used
// Use: getRoleAsync with role getting.
//  */
//   getRoleAsync() async {
//     try {
//       role = await SharedPrefManager.instance.getStringAsync(Constants.roleId);
//       getTeamList();
//       getTeamsList();
//       setState(() {});
//     } catch (e) {
//       _selectTeamProvider.listener
//           .onFailure(ExceptionErrorUtil.handleErrors(e));
//     } //
//   }
//
//   Future<void> getCountryCodeAsync() async {
//     first =
//     "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
//     setState(() {
//       dateformat = first;
//       print(dateformat);
//     });
//   }
//
//   @override
//   void onSuccess(any, {int reqId}) {
//     // ProgressBar.instance.stopProgressBar();
//     switch (reqId) {
//       case ResponseIds.GET_USER_TEAM:
//         SelectTeamResponse _response = any as SelectTeamResponse;
//         if (_response.status == Constants.success) {
//           _playerProfileProvider.setMemberList(_response.user.members);
//           setState(() {
//             _firstNameController = _response.user.userFirstName;
//             _genderController = _response.user.userGender;
//             DateFormat formatter = new DateFormat('yyyy-mm-dd');
//             DateTime dateTime = formatter.parse(
//                 _response.user.userDOB != null ? _response.user.userDOB : "");
//             _dobController = DateFormat('dd/mm/yyyy').format(dateTime);
//             _phoneController = _response.user.userPrimaryPhone.toString();
//             _addressController = _response.user.userCountry;
//
//             // CodeSnippet.instance.showMsg(MyStrings.signInSuccess);
//             // totalContact = _listContactProvider.getTotalContact.toString();
//           });
//         } else if (_response.status == Constants.failed) {
//           // CodeSnippet.instance.showMsg("Server is not responding");
//         } else {
//           // CodeSnippet.instance.showMsg("Server is not responding");
//         }
//         break;
//       case ResponseIds.GET_USER_TEAM:
//         SelectTeamResponse response = any as SelectTeamResponse;
//         if (response.status == Constants.success) {
//           //_selectTeamProvider.setTeamList(response.user.team);
//           print(_selectTeamProvider.getTeamList.length);
//           setState(() {
//             //Future Purpose
//
//             // CodeSnippet.instance.showMsg(MyStrings.signInSuccess);
//             // totalContact = _listContactProvider.getTotalContact.toString();
//           });
//         } else if (response.status == Constants.failed) {
//           // CodeSnippet.instance.showMsg("Server is not responding");
//         } else {
//           // CodeSnippet.instance.showMsg("Server is not responding");
//         }
//         break;
//     }
//     super.onSuccess(any);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     nameEditingController = TextEditingController();
//     genderEditingController = TextEditingController();
//     emailEditingController = TextEditingController();
//     phoneEditingController = TextEditingController();
//     dobEditingController = TextEditingController();
//     addressEditingController = TextEditingController();
//
//     _playerProfileProvider =
//         Provider.of<PlayerProfileProvider>(context, listen: false);
//     _selectTeamProvider =
//         Provider.of<SelectTeamProvider>(context, listen: false);
//     _signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
//     _scrollController = new ScrollController();
//     _scrollController.addListener(() => setState(() {}));
//     //getTeamList();
//     getRoleAsync();
//     getCountryCodeAsync();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     nameEditingController.dispose();
//     genderEditingController.dispose();
//     phoneEditingController.dispose();
//     dobEditingController.dispose();
//     addressEditingController.dispose();
//     _scrollController.dispose();
//   }
//
//   Widget build(BuildContext context) {
//     final double screenHeight = MediaQuery.of(context).size.height * .87;
//     final double screenHeights = MediaQuery.of(context).size.height * .90;
//
//     _isEditingText == true && _webDatePicker == true
//         ? _isShowDial = false
//         : null;
//
//     // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: MyColors.white,
//       appBar: getValueForScreenType<bool>(
//         context: context,
//         mobile: false,
//         tablet: false,
//         desktop: true,
//       )
//           ? CustomSimpleAppBar(
//         title: MyStrings.appName,
//         iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
//         iconRight: MyIcons.done,
//         onClickRightImage: () {
//           Navigator.of(context).pop();
//         },
//         onClickLeftImage: () {
//           Navigator.of(context).pop();
//         },
//       )
//           : null,
//       body: TopBar(
//         child: Consumer<SignUpProvider>(builder: (context, provider, _) {
//           return Form(
//             key: _formKey,
//             //             //Future Purpose
//             //             // autovalidateMode: !provider.getAutoValidate
//             //             //     ? AutovalidateMode.disabled
//             //             //     : AutovalidateMode.always,
//             //             autovalidate: !provider.getAutoValidate ? false : true,
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 child: Row(
//                   children: <Widget>[
//                     if (getValueForScreenType<bool>(
//                       context: context,
//                       mobile: false,
//                       tablet: true,
//                       desktop: true,
//                     ))
//                       Expanded(
//                         child: Image.asset(
//                           MyImages.signin,
//                           height: size.height * ImageSize.signInImageSize,
//                         ),
//                       ),
//                     Expanded(
//                       child: WebCard(
//                         marginVertical: 20,
//                         marginhorizontal: 40,
//                         child: SizedBox(
//                           height: getValueForScreenType<bool>(
//                             context: context,
//                             mobile: true,
//                             tablet: false,
//                             desktop: false,
//                           )
//                               ? screenHeights
//                               : getValueForScreenType<bool>(
//                             context: context,
//                             mobile: false,
//                             tablet: false,
//                             desktop: true,
//                           )
//                               ? screenHeight
//                               : null,
//                           child: Scaffold(
//                               backgroundColor: MyColors.white,
//                               body: Stack(
//                                 children: [
//                                   CustomScrollView(
//                                     controller: _scrollController,
//                                     slivers: <Widget>[
//                                       SliverAppBar(
//                                         pinned: _pinned,
//                                         snap: _snap,
//                                         floating: _floating,
//                                         expandedHeight: 280.0,
//                                         flexibleSpace: FlexibleSpaceBar(
//                                           centerTitle: true,
//                                           background: Container(
//                                             child: Image.network(
//                                               "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1331&q=80",
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           title: Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                             children: [
//                                               Text(_firstNameController == null
//                                                   ? "Arivu"
//                                                   : _firstNameController),
//                                               Text(
//                                                   _firstNameController == null
//                                                       ? "arivumani04@gmail.com"
//                                                       : _firstNameController,
//                                                   style: TextStyle(
//                                                     fontSize:
//                                                     getValueForScreenType<
//                                                         bool>(
//                                                       context: context,
//                                                       mobile: false,
//                                                       tablet: false,
//                                                       desktop: true,
//                                                     )
//                                                         ? FontSize
//                                                         .footerFontSize6
//                                                         : FontSize
//                                                         .footerFontSize6,
//                                                   )),
//                                             ],
//                                           ),
//
//                                           // background: Image.network("https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1331&q=80",fit: BoxFit.cover,
//                                         ),
//                                         actions: [
//                                           _isEditingText == true
//                                               ? IconButton(
//                                             icon: Icon(Icons.done),
//                                             tooltip:
//                                             MyStrings.tooltipSaveTodo,
//                                             onPressed: () {
//                                               _putProfile();
//                                             },
//                                           )
//                                               : SizedBox()
//                                         ],
//                                       ),
//                                       SliverList(
//                                         delegate: SliverChildListDelegate([
//                                           Container(
//                                             margin: EdgeInsets.symmetric(
//                                                 vertical: MarginSize
//                                                     .headerMarginVertical1,
//                                                 horizontal: MarginSize
//                                                     .headerMarginVertical1),
//                                             child: Column(
//                                               children: <Widget>[
//                                                 Row(children: <Widget>[
//                                                   _isEditingText == true
//                                                       ? Expanded(
//                                                     child:
//                                                     PlayerProfileDetailCardEdit(
//                                                         validator:
//                                                         ValidateInput
//                                                             .validateName,
//                                                         prefixIcon:
//                                                         MyIcons
//                                                             .username,
//                                                         labelText:
//                                                         MyStrings
//                                                             .userName,
//                                                         height: Dimens
//                                                             .standard_80,
//                                                         calendarImageString:
//                                                         MyIcons
//                                                             .username,
//                                                         groupText:
//                                                         MyStrings
//                                                             .userName,
//                                                         editingController:
//                                                         nameEditingController,
//                                                         // titleText: _dobController,
//                                                         titleText:
//                                                         _firstNameController),
//                                                   )
//                                                       : Expanded(
//                                                     child:
//                                                     PlayerProfileDetailCard(
//                                                       calendarImageString:
//                                                       MyIcons
//                                                           .username,
//                                                       groupText: MyStrings
//                                                           .userName,
//                                                       titleText:
//                                                       _firstNameController,
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 20),
//                                                   _isEditingText == true
//                                                       ? Expanded(
//                                                     child:
//                                                     PlayerProfileDetailCardEdit(
//                                                       validator:
//                                                       ValidateInput
//                                                           .validateEmail,
//                                                       height: Dimens.standard_80,
//                                                       prefixIcon:
//                                                       MyIcons.mail,
//                                                       labelText:
//                                                       MyStrings.email,
//                                                       calendarImageString:
//                                                       MyIcons.mail,
//                                                       groupText:
//                                                       MyStrings.email,
//                                                       editingController:
//                                                       emailEditingController,
//                                                       // titleText: _dobController,
//                                                       titleText:
//                                                       "arivumani04@gmail.com",
//                                                     ),
//                                                   )
//                                                       : Expanded(
//                                                     child:
//                                                     PlayerProfileDetailCard(
//                                                       calendarImageString:
//                                                       MyIcons.mail,
//                                                       groupText:
//                                                       MyStrings.email,
//                                                       titleText:
//                                                       "arivumani04@gmail.com",
//                                                       // titleText: _phoneController,
//                                                     ),
//                                                   ),
//                                                 ]),
//
//                                                 Stack(children: [
//                                                   Column(
//                                                     children: [
//                                                       Container(
//                                                         child: Row(
//                                                             children: <Widget>[
//                                                               _isEditingText ==
//                                                                   true
//                                                                   ?
//                                                               // Expanded(
//                                                               //         child: PlayerProfileDetailCardEdit(
//                                                               //                 validator: ValidateInput.verifyDOB,
//                                                               //                 prefixIcon: MyIcons.cake,
//                                                               //                 labelText: MyStrings.dob,
//                                                               //                 editingController: dobEditingController,
//                                                               //                 // titleText: _dobController,
//                                                               //                 height: Dimens.standard_80,
//                                                               //                 suffixIcon: MyIcons.calendar,
//                                                               //                 onClick: (){
//                                                               //                   setState(() {
//                                                               //                     _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
//                                                               //                   });
//                                                               //                 },
//                                                               //                 titleText: _dobController),
//                                                               //       )
//                                                               Expanded(
//                                                                 child:
//                                                                 Column(
//                                                                   children: [
//                                                                     DatePickerTextfieldWidget(
//                                                                       height:
//                                                                       Dimens.standard_80,
//                                                                       prefixIcon:
//                                                                       null,
//                                                                       labelText:
//                                                                       MyStrings.dob,
//                                                                       suffixIcon:
//                                                                       MyIcons.calendar,
//                                                                       controller:
//                                                                       DatepickerController,
//                                                                       inputAction:
//                                                                       TextInputAction.next,
//                                                                       validator:
//                                                                       ValidateInput.verifyDOB,
//                                                                       onTab:
//                                                                           () {
//                                                                         setState(() {
//                                                                           _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
//                                                                         });
//                                                                       },
//                                                                       onSave:
//                                                                           (value) {
//                                                                         DatepickerController.text = value;
//                                                                         // print(provider.startDateController.text);
//
//                                                                         print(value);
//                                                                       },
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                                   : Expanded(
//                                                                 child: PlayerProfileDetailCard(
//                                                                     calendarImageString: MyIcons.cake,
//                                                                     groupText: MyStrings.dob,
//                                                                     // titleText: _dobController,
//                                                                     titleText: _dobController),
//                                                               ),
//                                                               SizedBox(
//                                                                   width: 20),
//                                                               _isEditingText == true ?
//                                                               // Container(
//                                                               //         height: Dimens.standard_80,
//                                                               //         child: DropdownBelow(
//                                                               //           boxDecoration: BoxDecoration(color: MyColors.white, border: Border.all(color: MyColors.colorGray_818181)),
//                                                               //           itemWidth: WidgetCustomSize.boxDecorationwidth,
//                                                               //           icon: MyIcons.arrowdownIos,
//                                                               //           itemTextstyle: TextStyle(wordSpacing: 4, fontSize: FontSize.headerFontSize2, height: WidgetCustomSize.dropdownItemHeight, fontWeight: FontWeights.headerFontWeight2, color: Colors.black),
//                                                               //           boxTextstyle: TextStyle(decorationColor: MyColors.white, backgroundColor: MyColors.white, fontSize: FontSize.footerFontSize5, fontWeight: FontWeight.w400, color: MyColors.black),
//                                                               //           boxPadding: EdgeInsets.fromLTRB(PaddingSize.boxPaddingLeft, PaddingSize.boxPaddingTop, PaddingSize.boxPaddingRight, PaddingSize.boxPaddingBottom),
//                                                               //           boxWidth: WidgetCustomSize.boxDecorationwidth,
//                                                               //           boxHeight: WidgetCustomSize.dropdownBoxHeight,
//                                                               //           hint: Text(MyStrings.chooseRole, style: Theme.of(context).textTheme.bodyText2),
//                                                               //           value: genderEditingController.text.isEmpty ? null : genderEditingController.text,
//                                                               //           items: getGender.map((Gender gen) {
//                                                               //             return new DropdownMenuItem<String>(
//                                                               //               value: gen.name,
//                                                               //               child: new Text(gen.name, style: Theme.of(context).textTheme.bodyText2),
//                                                               //             );
//                                                               //           }).toList(),
//                                                               //           onChanged: (val) {
//                                                               //             setState(() => gender = val);
//                                                               //             genderEditingController.text = val;
//                                                               //           },
//                                                               //         )
//                                                               //
//                                                               //         )
//
//                                                               Expanded(
//                                                                 child: Container(
//                                                                   height: Dimens.standard_80,
//                                                                   child: DropdownBelow(
//
//                                                                     boxDecoration: BoxDecoration(
//                                                                       // color: MyColors.white,
//                                                                         border: Border.all(
//                                                                             color: MyColors
//                                                                                 .colorGray_818181)),
//                                                                     itemWidth: getValueForScreenType<
//                                                                         bool>(
//                                                                       context: context,
//                                                                       mobile: true,
//                                                                       tablet: false,
//                                                                       desktop: false,)
//                                                                         ? size.width * 0.4
//                                                                         : getValueForScreenType<
//                                                                         bool>(
//                                                                       context: context,
//                                                                       mobile: false,
//                                                                       tablet: true,
//                                                                       desktop: false,)
//                                                                         ? size.width * 0.2
//                                                                         : size.width * 0.21,
//                                                                     icon: MyIcons
//                                                                         .arrowdownIos,
//
//                                                                     itemTextstyle: TextStyle(
//                                                                         wordSpacing: 4,
//                                                                         // fontSize: 34,
//                                                                         height: WidgetCustomSize
//                                                                             .dropdownItemHeight,
//                                                                         // fontWeight: FontWeight.w400,
//                                                                         color: MyColors
//                                                                             .colorGray_818181),
//
//                                                                     boxTextstyle: TextStyle(
//                                                                         decorationColor: MyColors
//                                                                             .white,
//                                                                         //backgroundColor: MyColors.white,
//                                                                         // fontSize: 14,
//                                                                         // fontWeight: FontWeight.w400,
//                                                                         color: MyColors
//                                                                             .colorGray_818181),
//                                                                     boxPadding: EdgeInsets
//                                                                         .fromLTRB(
//                                                                         PaddingSize
//                                                                             .boxPaddingLeft,
//                                                                         PaddingSize
//                                                                             .boxPaddingTop,
//                                                                         PaddingSize
//                                                                             .boxPaddingRight,
//                                                                         PaddingSize
//                                                                             .boxPaddingBottom),
//                                                                     boxWidth: size.width *
//                                                                         WidgetCustomSize
//                                                                             .dropdownBoxWidth,
//                                                                     boxHeight: WidgetCustomSize
//                                                                         .dropdownBoxHeight,
//                                                                     hint: Text(
//                                                                         MyStrings.gender),
//                                                                     value: genderEditingController
//                                                                         .text.isEmpty
//                                                                         ? null
//                                                                         : genderEditingController
//                                                                         .text,
//                                                                     items: getGender
//                                                                         .map((Gender gen) {
//                                                                       return new DropdownMenuItem<
//                                                                           String>(
//                                                                         value: gen.name,
//                                                                         child: new Text(
//                                                                             gen.name,
//                                                                             style: Theme
//                                                                                 .of(context)
//                                                                                 .textTheme
//                                                                                 .bodyText2),
//                                                                       );
//                                                                     }).toList(),
//                                                                     onChanged: (val) {
//                                                                       setState(() =>
//                                                                       gender = val);
//                                                                       genderEditingController
//                                                                           .text =
//                                                                           val;
//                                                                     },
//                                                                   ),
//                                                                 ),
//                                                               )
//
//                                                               //
//                                                               //
//                                                               //
//                                                               // Expanded(
//                                                               //         child:
//                                                               //             PlayerProfileDetailCardEdit(
//                                                               //               validator: ValidateInput.validateName,
//                                                               //           height: Dimens
//                                                               //               .standard_80,
//                                                               //               prefixIcon: MyIcons.face,
//                                                               //               labelText: MyStrings.gender,
//                                                               //           calendarImageString:
//                                                               //               MyIcons.face,
//                                                               //           groupText:
//                                                               //               MyStrings
//                                                               //                   .gender,
//                                                               //           editingController:
//                                                               //               genderEditingController,
//                                                               //           // titleText: _dobController,
//                                                               //           titleText:
//                                                               //               _genderController ==
//                                                               //                       "M"
//                                                               //                   ? MyStrings
//                                                               //                       .male
//                                                               //                   : MyStrings
//                                                               //                       .male,
//                                                               //         ),
//                                                               //       )
//                                                                   : Expanded(
//                                                                 child:
//                                                                 PlayerProfileDetailCard(
//                                                                   calendarImageString:
//                                                                   MyIcons.face,
//                                                                   groupText:
//                                                                   MyStrings.gender,
//                                                                   titleText: _genderController ==
//                                                                       "M"
//                                                                       ? MyStrings.male
//                                                                       : MyStrings.male,
//                                                                 ),
//                                                               ),
//                                                             ]),
//                                                       ),
//                                                       // DropdownButtonFormField(
//                                                       //   isExpanded: true,
//                                                       //   items: getGender
//                                                       //       .map((Gender gen) => DropdownMenuItem<String>(
//                                                       //       value: gen.name, child: Text( gen.name)))
//                                                       //       .toList(),
//                                                       //   decoration: InputDecoration(
//                                                       //     border: OutlineInputBorder(),
//                                                       //     labelText: 'State',
//                                                       //   ),
//                                                       //   onChanged: (val) {
//                                                       //     setState(() {
//                                                       //       setState(() =>
//                                                       //       gender = val);
//                                                       //       genderEditingController
//                                                       //           .text =
//                                                       //           val;
//                                                       //     });
//                                                       //   },
//                                                       // ),
//                                                       Row(children: <Widget>[
//                                                         _isEditingText == true
//                                                             ? Expanded(
//                                                           child:
//                                                           PlayerProfileDetailCardEdit(
//                                                             validator:
//                                                             ValidateInput
//                                                                 .validateMobile,
//                                                             prefixIcon:
//                                                             MyIcons
//                                                                 .phone,
//                                                             labelText:
//                                                             MyStrings
//                                                                 .contactPhone,
//                                                             height: Dimens
//                                                                 .standard_80,
//                                                             editingController:
//                                                             phoneEditingController,
//                                                             helperText:
//                                                             _phoneController,
//                                                             // titleText: _dobController,
//                                                             prefix:
//                                                             _phoneController,
//                                                           ),
//                                                         )
//                                                             : Expanded(
//                                                           child:
//                                                           PlayerProfileDetailCard(
//                                                             calendarImageString:
//                                                             MyIcons
//                                                                 .phone,
//                                                             groupText:
//                                                             MyStrings
//                                                                 .contactPhone,
//                                                             titleText:
//                                                             _phoneController,
//                                                             // titleText: _phoneController,
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: 20),
//                                                         _isEditingText == true
//                                                             ? Expanded(
//                                                           child:
//                                                           PlayerProfileDetailCardEdit(
//                                                             height: Dimens
//                                                                 .standard_80,
//                                                             calendarImageString:
//                                                             MyIcons
//                                                                 .cancelj,
//                                                             prefixIcon:
//                                                             MyIcons
//                                                                 .cancelj,
//                                                             labelText:
//                                                             MyStrings
//                                                                 .address,
//                                                             groupText:
//                                                             MyStrings
//                                                                 .address,
//                                                             editingController:
//                                                             addressEditingController,
//                                                             titleText:
//                                                             _addressController,
//                                                           ),
//                                                         )
//                                                             : Expanded(
//                                                           child:
//                                                           PlayerProfileDetailCard(
//                                                             calendarImageString:
//                                                             MyIcons
//                                                                 .cancelj,
//                                                             groupText:
//                                                             MyStrings
//                                                                 .address,
//                                                             titleText:
//                                                             _addressController,
//                                                           ),
//                                                         ),
//                                                       ]),
//                                                     ],
//                                                   ),
//                                                   _isEditingText == true &&
//                                                       _webDatePicker ==
//                                                           true &&
//                                                       getValueForScreenType<
//                                                           bool>(
//                                                         context: context,
//                                                         mobile: false,
//                                                         tablet: false,
//                                                         desktop: true,
//                                                       )
//                                                       ? Container(
//                                                     child: Row(
//                                                       children: [
//                                                         Expanded(
//                                                           child: Card(
//                                                             margin: const EdgeInsets
//                                                                 .only(
//                                                                 right:
//                                                                 8.0,
//                                                                 left: 0.0,
//                                                                 top: 50.0,
//                                                                 bottom:
//                                                                 0),
//                                                             elevation: 10,
//                                                             shadowColor:
//                                                             MyColors
//                                                                 .colorGray_666BC,
//                                                             child:
//                                                             SfDateRangePicker(
//                                                               view: DateRangePickerView
//                                                                   .month,
//                                                               todayHighlightColor:
//                                                               MyColors
//                                                                   .red,
//                                                               allowViewNavigation:
//                                                               true,
//                                                               showNavigationArrow:
//                                                               true,
//                                                               navigationMode:
//                                                               DateRangePickerNavigationMode
//                                                                   .snap,
//                                                               endRangeSelectionColor:
//                                                               MyColors
//                                                                   .kPrimaryColor,
//                                                               rangeSelectionColor:
//                                                               MyColors
//                                                                   .kPrimaryColor,
//                                                               selectionColor:
//                                                               MyColors
//                                                                   .kPrimaryColor,
//                                                               startRangeSelectionColor:
//                                                               MyColors
//                                                                   .kPrimaryColor,
//                                                               onSelectionChanged:
//                                                               _onSelectionChanged,
//                                                               selectionMode:
//                                                               DateRangePickerSelectionMode
//                                                                   .single,
//                                                               onSubmit:
//                                                                   (value) {
//                                                                 setState(
//                                                                         () {
//                                                                       DatepickerController.text =
//                                                                           value;
//                                                                     });
//                                                                 // Navigator.pop(context);
//                                                               },
//                                                               initialSelectedRange: PickerDateRange(
//                                                                   DateTime.now().subtract(const Duration(
//                                                                       days:
//                                                                       4)),
//                                                                   DateTime.now().add(const Duration(
//                                                                       days:
//                                                                       3))),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         Expanded(
//                                                             child:
//                                                             SizedBox(
//                                                               width: 300,
//                                                             ))
//                                                       ],
//                                                     ),
//                                                   )
//                                                       : SizedBox(),
//                                                 ]),
//
//                                                 // _isEditingText == false ? Column(
//                                                 //   children: [
//                                                 //     Text(
//                                                 //       MyStrings.selectTeam,
//                                                 //       style: TextStyle(
//                                                 //           fontSize: 22,
//                                                 //           fontWeight:
//                                                 //           FontWeight.w500),
//                                                 //     ),
//                                                 //     _selectTeamProvider
//                                                 //         .getTeamList !=
//                                                 //         null &&
//                                                 //         _selectTeamProvider
//                                                 //             .getTeamList
//                                                 //             .length >
//                                                 //             0
//                                                 //         ? ListView.builder(
//                                                 //       physics:
//                                                 //       NeverScrollableScrollPhysics(),
//                                                 //       shrinkWrap:
//                                                 //       true, // new
//                                                 //       itemCount: _selectTeamProvider
//                                                 //           .getTeamList
//                                                 //           .length ==
//                                                 //           null
//                                                 //           ? 0
//                                                 //           : _selectTeamProvider
//                                                 //           .getTeamList
//                                                 //           .length,
//                                                 //       itemBuilder:
//                                                 //           (BuildContext
//                                                 //       context,
//                                                 //           int index) {
//                                                 //         return MenuScreenCard(
//                                                 //           icon:
//                                                 //           MyIcons.sport,
//                                                 //           title:
//                                                 //           "${_selectTeamProvider
//                                                 //               .getTeamList[index].teamName}",
//                                                 //           onPressed: () {
//                                                 //             SharedPrefManager
//                                                 //                 .instance
//                                                 //                 .setStringAsync(
//                                                 //                 Constants
//                                                 //                     .teamName,
//                                                 //                 _selectTeamProvider
//                                                 //                     .getTeamList[index]
//                                                 //                     .teamName);
//                                                 //             Navigation
//                                                 //                 .navigateWithArgument(
//                                                 //                 context,
//                                                 //                 MyRoutes
//                                                 //                     .homeScreen,
//                                                 //                 0);
//                                                 //             //Navigation.navigateWithArgument(context, MyRoutes.homeScreen,_selectTeamProvider.getTeamList[index].teamName);
//                                                 //           },
//                                                 //         );
//                                                 //       },
//                                                 //     )
//                                                 //         : Container(
//                                                 //         child: Column(
//                                                 //           mainAxisAlignment:
//                                                 //           MainAxisAlignment
//                                                 //               .center,
//                                                 //           crossAxisAlignment:
//                                                 //           CrossAxisAlignment
//                                                 //               .center,
//                                                 //           children: [
//                                                 //             Text(
//                                                 //               MyStrings
//                                                 //                   .noTeamsAvailable,
//                                                 //               style: TextStyle(
//                                                 //                 fontSize: FontSize
//                                                 //                     .headerFontSize4,
//                                                 //               ),
//                                                 //             ),
//                                                 //           ],
//                                                 //         ))
//                                                 //   ],
//                                                 // ) : SizedBox(),
//                                               ],
//                                             ),
//                                           ),
//                                         ]),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               floatingActionButton: Visibility(
//                                 visible: _isShowDial,
//                                 child: FloatingActionButton(
//                                   tooltip: MyStrings.editPlayer,
//                                   child: MyIcons.edit,
//                                   onPressed: () {
//                                     setState(() {
//                                       _isEditingText = true;
//                                       _isShowDial = false;
//                                     });
//                                     // Navigation.navigateWithArgument(context, MyRoutes.editPlayersScreen, widget.userId);
//                                   },
//                                 ),
//                               )
//                             // floatingActionButton:
//                             // _getFloatingActionButton(),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget _getFloatingActionButton() {
//     return SpeedDialMenuButton(
//       isEnableAnimation: true,
//       //if needed to close the menu after clicking sub-FAB
//       isShowSpeedDial: _isShowDial,
//       //manually open or close menu
//       updateSpeedDialStatus: (isShow) {
//         //return any open or close change within the widget
//         this._isShowDial = isShow;
//       },
//       //general init
//       isMainFABMini: false,
//       mainMenuFloatingActionButton: MainMenuFloatingActionButton(
//           mini: false,
//           child: MyIcons.more_vert,
//           onPressed: () {},
//           closeMenuChild: Icon(Icons.close),
//           closeMenuForegroundColor: MyColors.white,
//           closeMenuBackgroundColor: MyColors.kPrimaryColor),
//       floatingActionButtonWidgetChildren: <FloatingActionButton>[
//         FloatingActionButton(
//           tooltip: MyStrings.editPlayer,
//           mini: true,
//           child: MyIcons.edit,
//           onPressed: () {
//             setState(() {
//               _isEditingText = true;
//               _isShowDial = false;
//             });
//             // Navigation.navigateWithArgument(context, MyRoutes.editPlayersScreen, widget.userId);
//           },
//         ),
//         FloatingActionButton(
//           tooltip: MyStrings.createTeam,
//           mini: true,
//           disabledElevation: 3,
//           child: MyIcons.add,
//           onPressed: () {
//             setState(() {
//               _isShowDial = false;
//             });
//             Navigation.navigateTo(context, MyRoutes.createTeamScreen);
//           },
//         )
//       ],
//       isSpeedDialFABsMini: true,
//       paddingBtwSpeedDialButton: 50.0,
//     );
//   }
// }
//
// class Language {
//   final int id;
//   final String name;
//
//   const Language(
//       this.id,
//       this.name,
//       );
// }
//
// List<S2Choice<String>> _choiceRepeat = [
//   S2Choice<String>(value: '-10001', title: MyStrings.managerRole),
//   S2Choice<String>(value: '-10002', title: MyStrings.playerRole),
//
//   //Future Purpose
//
//   /* S2Choice<String>(value: '-10001', title: MyStrings.ownerRole),
//    S2Choice<String>(value: '-10003', title: MyStrings.nonPlayerRole),
//   S2Choice<String>(value: '-10004', title: MyStrings.familyRole),*/
// ];
// const List<Language> getLanguages = <Language>[
//   Language(
//     -10001,
//     'Coach/Manager',
//   ),
//   Language(
//     -10002,
//     'Player',
//   ),
//   //Future Purpose
//
//   /* Language(
//     -10003,
//     'Nonplayer',
//   ),
//   Language(
//     -10004,
//     'Family',
//   ),*/
// ];
