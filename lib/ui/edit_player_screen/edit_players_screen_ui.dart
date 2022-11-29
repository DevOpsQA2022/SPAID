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
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/edit_players_details_response/family_members_response.dart';
import 'package:spaid/model/response/roaster_listview_response/team_members_details_response.dart';
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
import 'package:spaid/ui/add_player_screen/add_player_screen.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/ui/player_profile_screen/player_profile_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/add_family_card.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:spaid/widgets/custom_raised_button.dart';
import 'package:spaid/widgets/custom_simple_appbar.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:spaid/widgets/home_eventSport_card.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'edit_players_screen_provider.dart';

class EditPlayersScreen extends StatefulWidget {
  //region Private Members
  final int userId;

  //endregion

  EditPlayersScreen(this.userId);

  @override
  _EditPlayersScreenState createState() => _EditPlayersScreenState();
}

class _EditPlayersScreenState extends BaseState<EditPlayersScreen> {
  //region Private Members
  EditPlayerProvider? _editplayerProvider;
  FocusNode _node = new FocusNode();
  FocusNode _notenode = new FocusNode();

  String? gender;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();

  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollControllerMain = new ScrollController();
  bool _webDatePicker = false;
  bool isEmailEdited = false;
  bool isMemberExist = false;
  DateTime _selectedDate = DateTime.now();
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String? dateformat, first;
  List<int>? imageBytes;
  String? imgFilePath;
  String imageB64 = "";
  int? teamIDNo;
  String? role;
  PlayerProfileProvider? _playerProfileProvider;
  int? userID;
  String? teamName, userName, playerRoleId, fcm, userEmail;
  ScrollController _controllerOne = ScrollController();
  RoasterListViewProvider? _roasterListViewProvider;

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
    getCountryCodeAsyncs();
    _editplayerProvider =
        Provider.of<EditPlayerProvider>(context, listen: false);
    _playerProfileProvider =
        Provider.of<PlayerProfileProvider>(context, listen: false);
    // _roasterListViewProvider =
    //     Provider.of<RoasterListViewProvider>(context, listen: false);
    // _roasterListViewProvider.listener = this;
    _editplayerProvider!.initialProvider(widget.userId, playerRoleId ??"");
    _editplayerProvider!.listener = this;
    _playerProfileProvider!.listener = this;
  }

  Future<void> getCountryCodeAsyncs() async {
    teamIDNo = int.parse(
        "${await SharedPrefManager.instance.getStringAsync(Constants.teamID)}");
    role =
        "${await SharedPrefManager.instance.getStringAsync(Constants.roleId)}";
    userID = int.parse(
        "${await SharedPrefManager.instance.getStringAsync(Constants.userIdNo)}");
    teamName =
        await SharedPrefManager.instance.getStringAsync(Constants.teamName);
    userName =
        await SharedPrefManager.instance.getStringAsync(Constants.userName);
    playerRoleId =
        await SharedPrefManager.instance.getStringAsync(Constants.playerRoleId);
    first =
        "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    userEmail =
        await SharedPrefManager.instance.getStringAsync(Constants.userId);
    fcm = (await SharedPrefManager.instance.getStringAsync(Constants.FCM))
        .toString();
    dateformat = first;
    print(dateformat);
    setState(() {});
  }

  /*
Return Type:
Input Parameters:
Use: Validate user inputs and update player details to server.
 */
  void _updatePlayerDetails() {
    print(_editplayerProvider!.familyFirstnamecontroller);
    FocusScope.of(context).requestFocus(FocusNode());
    // _editplayerProvider.getExistingPlayerByEmail(_editplayerProvider.emailController.text);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Internet.checkInternet().then((value) {
        if (value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ProgressBar.instance.showProgressbar(context);
          });
          Future.delayed(Duration(seconds: 2), () {
            if (int.parse(_editplayerProvider!.roleID!) == Constants.owner) {
              _editplayerProvider!.updatePlayerAsync(
                  imageBytes??[], Constants.owner);
            } else if (_editplayerProvider!.isManager! &&
                _editplayerProvider!.isNonPlayer!) {
              _editplayerProvider!.updatePlayerAsync(
                  imageBytes??[], Constants.coachorManager);
            } else if (_editplayerProvider!.isManager! &&
                !_editplayerProvider!.isNonPlayer!) {
              _editplayerProvider!.updatePlayerAsync(
                  imageBytes??[], Constants.coachorManager);
            } else if (_editplayerProvider!.isNonPlayer! &&
                !_editplayerProvider!.isManager!) {
              _editplayerProvider!.updatePlayerAsync(
                  imageBytes??[], Constants.nonPlayer);
            } else {
              _editplayerProvider!.updatePlayerAsync(
                  imageBytes??[], Constants.teamPlayer);
            }
            /*else if(_editplayerProvider.roleID == (_editplayerProvider.isManager?Constants.coachorManager.toString():"")){
            _editplayerProvider.updatePlayerAsync(imageBytes);
          }else if(_editplayerProvider.roleID == (_editplayerProvider.isNonPlayer?Constants.nonPlayer.toString():"")){
            _editplayerProvider.updatePlayerAsync(imageBytes);
          }else if(_editplayerProvider.roleID == Constants.teamPlayer.toString()){
            if(_editplayerProvider.isManager){
              _editplayerProvider.updatePlayerAsync(imageBytes);
            }
            else if(_editplayerProvider.isNonPlayer){
              _editplayerProvider.updatePlayerAsync(imageBytes);
            }else{
              _editplayerProvider.updatePlayerAsync(imageBytes);
            }
          }else if(_editplayerProvider.roleID == Constants.familyMember.toString()){
            if(_editplayerProvider.isManager){
              _editplayerProvider.updatePlayerAsync(imageBytes);
            }
            else if(_editplayerProvider.isNonPlayer){
              _editplayerProvider.updatePlayerAsync(imageBytes);
            }else{
              _editplayerProvider.updatePlayerAsync(imageBytes);
            }
          }*/
          });
        } else {
          CodeSnippet.instance.showMsg(MyStrings.checkNetwork);
        }
      });
    } else {
      if (_editplayerProvider!.firstNameController!.text.isEmpty) {
        _scrollControllerMain.jumpTo(0);
        // CodeSnippet.instance.showMsg(ValidateInput.requiredFieldsFirstName(_editplayerProvider.firstNameController.text));
      } else if (_editplayerProvider!.lastNameController!.text.isEmpty) {
        _scrollControllerMain.jumpTo(0);
        // CodeSnippet.instance.showMsg(ValidateInput.requiredFieldsLastName(_editplayerProvider.lastNameController.text));
      } else if (ValidateInput.verifyDOB(
              _editplayerProvider!.DatePickerController!.text) !=
          null) {
        _scrollControllerMain.jumpTo(0);
        //CodeSnippet.instance.showMsg(ValidateInput.verifyDOB(_editplayerProvider.DatePickerController.text));
      } else if (ValidateInput.validateEmail(
              _editplayerProvider!.emailController!.text) !=
          null) {
        _scrollControllerMain.jumpTo(700);
        //CodeSnippet.instance.showMsg(ValidateInput.validateEmail(_editplayerProvider.emailController.text));
      }
      if (_editplayerProvider!.familyFirstnamecontroller.length > 0) {
        for (int i = 0;
            i < _editplayerProvider!.familyFirstnamecontroller.length;
            i++) {
          if (_editplayerProvider!.familyFirstnamecontroller[i].text.isEmpty) {
            //_scrollController.position.maxScrollExtent;
            CodeSnippet.instance.showMsg(ValidateInput.requiredFieldsFirstName(
                _editplayerProvider!.familyFirstnamecontroller[i].text)!);
          } else if (_editplayerProvider!
              .familyLastnamecontroller[i].text.isEmpty) {
            // _scrollController.position.maxScrollExtent;
            CodeSnippet.instance.showMsg(ValidateInput.requiredFieldsLastName(
                _editplayerProvider!.familyLastnamecontroller[i].text)!);
          } else if (ValidateInput.validateEmail(
                  _editplayerProvider!.familyEmailcontroller[i].text) !=
              null) {
            // _scrollController.position.maxScrollExtent;
            CodeSnippet.instance.showMsg(ValidateInput.validateEmail(
                _editplayerProvider!.familyEmailcontroller[i].text)!);
          }
        }
      }
    }
  }

  void _addFamily() {
    setState(() {
      addFamilyList();
    });
  }

/*
Return Type:Widget
Input Parameters:
Use: To create Listview Items.
 */
  Widget addFamilyList() {
    return ListView.builder(
        itemCount: _editplayerProvider!.familyFirstnamecontroller.length == null
            ? 0
            : _editplayerProvider!.familyFirstnamecontroller.length,
        shrinkWrap: true,
        controller: _scrollController,
        itemBuilder: (context, index) {
          //return AddFamilyListCard(index,_firstnamecontroller[index]);
          return AddFamilyListCard(
              index,
              _editplayerProvider!.familyFirstnamecontroller[index],
              _editplayerProvider!.familyLastnamecontroller[index],
              _editplayerProvider!.familyEmailcontroller[index],
              _editplayerProvider!.familyContactcontroller[index],
              _editplayerProvider!.familyAddresscontroller[index],
              _editplayerProvider!.familyCitycontroller[index],
              _editplayerProvider!.familyStatecontroller[index],
              _editplayerProvider!.familyuserIDcodecontroller[index],
              _editplayerProvider!.familyZipcodecontroller[index],
              myNumber: (int, familyUserID) {
            setState(() {
              _popupDialog(context, int, familyUserID);
            });
            print(int);
          });
        });
  }

/*
Return Type:
Input Parameters:index
Use: Delete Listview Details.
 */
  void deleteFamilyMember(int index, int familyUserID) {
    setState(() {
      if (familyUserID != -1) {
        _playerProfileProvider!.deleteMemberAsync(
            familyUserID, Constants.familyIds[index], 1);
      }
      _editplayerProvider!.familyFirstnamecontroller.removeAt(index);
      _editplayerProvider!.familyLastnamecontroller.removeAt(index);
      _editplayerProvider!.familyEmailcontroller.removeAt(index);
      _editplayerProvider!.familyContactcontroller.removeAt(index);
      _editplayerProvider!.familyAddresscontroller.removeAt(index);
      _editplayerProvider!.familyCitycontroller.removeAt(index);
      _editplayerProvider!.familyStatecontroller.removeAt(index);
      _editplayerProvider!.familyZipcodecontroller.removeAt(index);
      _editplayerProvider!.familyuserIDcodecontroller.removeAt(index);
      _editplayerProvider!.familyMiddleNamecontroller.removeAt(index);
      _editplayerProvider!.familyDOBcontroller.removeAt(index);
      _editplayerProvider!.familyGendercontroller.removeAt(index);
      _editplayerProvider!.familyCountrycontroller.removeAt(index);
      _editplayerProvider!.familyAddress2controller.removeAt(index);
      _editplayerProvider!.familyAltEmailcontroller.removeAt(index);
      _editplayerProvider!.familyAltContactcontroller.removeAt(index);
      _editplayerProvider!.familyFCMcontroller.removeAt(index);
      _editplayerProvider!.familyPlayerAvailabilitycontroller.removeAt(index);
    });
  }

/*
Return Type:
Input Parameters:context,index
Use: To get conformation message from the user.
 */

  void _popupDialog(BuildContext context, int index, int familyUserID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
              gifPath: MyImages.team,
              ok: "Delete",
              okFun: () => {
                deleteFamilyMember(index, familyUserID),
                Navigator.of(context, rootNavigator: true).pop(),
              },
              cancelColor: MyColors.red,
              cancelFun: () =>
                  {Navigator.of(context, rootNavigator: true).pop()},
              title:
                  "Deleting this person will remove his/her ablity to access the team.\n\nAre you sure?",
            ));

    /*
    Widget cancelButton = FlatButton(
      child: Text(MyStrings.cancel),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Delete"),
      onPressed: () async {
        deleteFamilyMember(index);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      //title: Text(MyStrings.creategroup),
      content: ListTile(
        title: Text(
            "Deleting this person will remove his/her ablity to access the team."),
        subtitle: Text("Are toy sure?"),
      ),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );*/
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
        _editplayerProvider!.DatePickerController!
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedDate)
              : dateformat == "CA"
                  ? DateFormat("yyyy/MM/dd").format(_selectedDate)
                  : DateFormat("dd/MM/yyyy").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _editplayerProvider!.DatePickerController!.text.length,
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
  Future<void> onSuccess(any, {int? reqId}) async {
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.REMOVE_PLAYER:
        ValidateUserResponse _validateUserResponse =
            any as ValidateUserResponse;
        if (_validateUserResponse.responseResult == Constants.success) {
          //Navigation.navigateWithArgument(context, MyRoutes.homeScreen,Constants.navigateIdOne);
          setState(() {});
        } else if (_validateUserResponse.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance
              .showMsg(_validateUserResponse.saveErrors![0].errorMessage!);
        } else {
          //  CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.ADD_FAMILY:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          DynamicLinksService()
              .createDynamicLink(
                  "intro_Screen?username=" + Constants.accept.toString())
              .then((acceptvalue) {
            print(acceptvalue);
            DynamicLinksService()
                .createDynamicLink(
                    "intro_Screen?username=" + Constants.reject.toString())
                .then((declainvalue) {
              print(declainvalue);
              EmailService().invitePlayer(
                  "Team Member Invite",
                  "Invitation",
                  Constants.teamInvite,
                  widget.userId,
                  int.parse(_response.responseMessage!),
                  teamIDNo!,
                  "Player Request notification",
                  _editplayerProvider!.emailController!.text,
                  "name",
                  acceptvalue,
                  declainvalue,
                  "",
                  "");
            });
          });
          Navigator.of(context).pop();
          Navigation.navigateWithArgument(
              context, MyRoutes.playerProfile, widget.userId);
          //Navigation.navigateWithArgument(context, MyRoutes.homeScreen,Constants.navigateIdOne);

        } else if (_response.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else if (_response.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          //  CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.EDIT_PLAYER_SCREENS:
        AddPlayerResponse _response = any as AddPlayerResponse;
        if (_response.responseResult == Constants.success) {
          if (_editplayerProvider!.familyEmailcontroller != null &&
              _editplayerProvider!.familyEmailcontroller.isNotEmpty) {
            for (int i = 0;
                i < _editplayerProvider!.familyEmailcontroller.length;
                i++) {
              if (_editplayerProvider!.familyEmailcontroller.length > 0 &&
                  _editplayerProvider!
                      .familyEmailcontroller[i].text.isNotEmpty &&
                  _editplayerProvider!.familyuserIDcodecontroller[i].text ==
                      "-1") {
                await _editplayerProvider!.AddFamilyAsync(i);

              } else if (_editplayerProvider!.familyEmailcontroller.length > 0 &&
                  _editplayerProvider!
                      .familyEmailcontroller[i].text.isNotEmpty &&
                  _editplayerProvider!.familyuserIDcodecontroller[i].text !=
                      "-1") {
                await _editplayerProvider!.UpdateFamilyAsync(i, widget.userId);
              }
            }
            // if(isEmailEdited && _editplayerProvider.roleID != Constants.owner.toString() && _editplayerProvider.playerAvailabilityStatusId == Constants.mailNotSend) {
            //   DynamicLinksService().createDynamicLink(
            //       "create_Password_Screen?userid=" + _editplayerProvider.UserIDNo.toString() +
            //           "&teamid=" + teamIDNo.toString() + "&email=" +
            //           _editplayerProvider.emailController.text + "&userRoleId=" +
            //           _editplayerProvider.userRoleId.toString() + "&team=" + teamName + "&player=" +
            //           _editplayerProvider.firstNameController.text +
            //           "&manager=" + userName + "&fcm=" + fcm.toString() +
            //           "&isMemberExist=" + isMemberExist.toString() +
            //           "&toMail=" + userEmail.toString() + "&toID=" +
            //           userID.toString()).then((acceptvalue) async {
            //     print(acceptvalue);
            //     DynamicLinksService().createDynamicLink(
            //         "intro_Screen?userid=" + _editplayerProvider.UserIDNo.toString() + "&teamid=" +
            //             teamIDNo.toString() + "&email=" +
            //             _editplayerProvider.emailController.text +
            //             "&userRoleId=" + _editplayerProvider.userRoleId.toString() + "&team=" + teamName +
            //             "&player=" +
            //             _editplayerProvider.firstNameController.text +
            //             "&manager=" + userName + "&fcm=" + fcm.toString() +
            //             "&toMail=" + userEmail.toString() + "&toID=" +
            //             userID.toString()).then((declainvalue) {
            //       print(declainvalue);
            //       EmailService().invitePlayer(
            //           "Invitation mail",
            //           "Invitation",
            //           Constants.teamInvite,
            //           userID,
            //           _editplayerProvider.UserIDNo,
            //           teamIDNo,
            //           "You have been invited to join " + teamName,
            //           _editplayerProvider.emailController.text,
            //           _editplayerProvider.firstNameController.text + " " +
            //               _editplayerProvider.lastNameController.text,
            //           acceptvalue,
            //           declainvalue,
            //           teamName,
            //           userName);
            //     });
            //   });
            // }
            _editplayerProvider!.getExistingPlayerByEmail(
                _editplayerProvider!.emailController!.text);
            // Navigator.of(context).pop();
            // Navigation.navigateWithArgument(
            //     context, MyRoutes.playerProfile, widget.userId);
          } else {
            // if(isEmailEdited && _editplayerProvider.roleID != Constants.owner.toString() && _editplayerProvider.playerAvailabilityStatusId == Constants.mailNotSend) {
            //   DynamicLinksService().createDynamicLink(
            //       "create_Password_Screen?userid=" + _editplayerProvider.UserIDNo.toString() +
            //           "&teamid=" + teamIDNo.toString() + "&email=" +
            //           _editplayerProvider.emailController.text + "&userRoleId=" +
            //           _editplayerProvider.userRoleId.toString() + "&team=" + teamName + "&player=" +
            //           _editplayerProvider.firstNameController.text +
            //           "&manager=" + userName + "&fcm=" + fcm.toString() +
            //           "&isMemberExist=" + isMemberExist.toString() +
            //           "&toMail=" + userEmail.toString() + "&toID=" +
            //           userID.toString()).then((acceptvalue) async {
            //     print(acceptvalue);
            //     DynamicLinksService().createDynamicLink(
            //         "intro_Screen?userid=" + _editplayerProvider.UserIDNo.toString() + "&teamid=" +
            //             teamIDNo.toString() + "&email=" +
            //             _editplayerProvider.emailController.text +
            //             "&userRoleId=" + _editplayerProvider.userRoleId.toString() + "&team=" + teamName +
            //             "&player=" +
            //             _editplayerProvider.firstNameController.text +
            //             "&manager=" + userName + "&fcm=" + fcm.toString() +
            //             "&toMail=" + userEmail.toString() + "&toID=" +
            //             userID.toString()).then((declainvalue) {
            //       print(declainvalue);
            //       EmailService().invitePlayer(
            //           "Invitation mail",
            //           "Invitation",
            //           Constants.teamInvite,
            //           userID,
            //           _editplayerProvider.UserIDNo,
            //           teamIDNo,
            //           "You have been invited to join " + teamName,
            //           _editplayerProvider.emailController.text,
            //           _editplayerProvider.firstNameController.text + " " +
            //               _editplayerProvider.lastNameController.text,
            //           acceptvalue,
            //           declainvalue,
            //           teamName,
            //           userName);
            //     });
            //   });
            // }
            _editplayerProvider!.getExistingPlayerByEmail(
                _editplayerProvider!.emailController!.text);

            // Navigator.of(context).pop();
            // Navigation.navigateWithArgument(
            //     context, MyRoutes.playerProfile, widget.userId);
            //Navigation.navigateWithArgument(context, MyRoutes.homeScreen,Constants.navigateIdOne);

          }
        } else {
          CodeSnippet.instance.showMsg(_response.errorMessage!);
        }
        break;
      case ResponseIds.GET_FAMILY_MEMBERS:
        FamilyMembersResponse _familyMembersResponse =
            any as FamilyMembersResponse;
        if (_familyMembersResponse.result!.userIdNo != Constants.success) {
          setState(() {
            if (_familyMembersResponse.result!.familyMemberList != null) {
              for (int i = 0;
                  i < _familyMembersResponse.result!.familyMemberList!.length;
                  i++) {
                _editplayerProvider!.familyFirstnamecontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyLastnamecontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyEmailcontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyContactcontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyAddresscontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyCitycontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyStatecontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyZipcodecontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyuserIDcodecontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyMiddleNamecontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyDOBcontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyGendercontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyCountrycontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyAddress2controller
                    .add(TextEditingController());
                _editplayerProvider!.familyAltEmailcontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyAltContactcontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyFCMcontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyPlayerAvailabilitycontroller
                    .add(TextEditingController());
                _editplayerProvider!.familyFirstnamecontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userFirstName??"";
                _editplayerProvider!.familyLastnamecontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userLastName??"";
                _editplayerProvider!.familyEmailcontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userEmailID??"";
                _editplayerProvider!.familyContactcontroller[i].text =
                    _familyMembersResponse
                                .result!.familyMemberList![i].userPrimaryPhone! ==
                            "0"
                        ? ""
                        : _familyMembersResponse
                            .result!.familyMemberList![i].userPrimaryPhone!;
                _editplayerProvider!.familyAddresscontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userAddress1??"";
                _editplayerProvider!.familyCitycontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userCity??"";
                _editplayerProvider!.familyStatecontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userState??"";
                _editplayerProvider!.familyZipcodecontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userZip??"";
                _editplayerProvider!.familyuserIDcodecontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userIdNo
                        .toString();
                _editplayerProvider!.familyMiddleNamecontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userMiddleName??"";
                _editplayerProvider!.familyDOBcontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userDOB??"";
                _editplayerProvider!.familyGendercontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userGender??"";
                _editplayerProvider!.familyCountrycontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userCountry??"";
                _editplayerProvider!.familyAddress2controller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].userAddress2??"";
                _editplayerProvider!.familyAltEmailcontroller[i].text =
                    _familyMembersResponse
                        .result!.familyMemberList![i].userAlternateEmailID??"";
                _editplayerProvider!.familyAltContactcontroller[i].text =
                _familyMembersResponse.result != null && _familyMembersResponse.result!.familyMemberList![i].userAlternatePhone ==
                            "0"
                        ? ""
                        : _familyMembersResponse
                            .result!.familyMemberList![i].userAlternatePhone!;
                _editplayerProvider!.familyFCMcontroller[i].text =
                    _familyMembersResponse.result!.familyMemberList![i].fCMTokenID??"";
                _editplayerProvider!.familyPlayerAvailabilitycontroller[i].text =
                    _familyMembersResponse
                        .result!.familyMemberList![i].PlayerAvailabilityStatusId
                        .toString();
              }
            }
          });
        }
        break;
      case ResponseIds.EDIT_PLAYER_SCREEN:
        TeamMembersDetailsResponse _response =
            any as TeamMembersDetailsResponse;
        print(_response.result!.userIdNo);
        if (_response.result!.userIdNo != Constants.success) {
          _playerProfileProvider!.getFamilyMembers(widget.userId, playerRoleId!);
          setState(() {
            _editplayerProvider!.firstNameController!.text =
                _response.result!.userFirstName??"";
            _editplayerProvider!.lastNameController!.text =
                _response.result!.userLastName??"";
            _editplayerProvider!.contactPhoneController!.text =
                _response.result!.userPrimaryPhone != null &&
                        _response.result!.userPrimaryPhone != "0"
                    ? _response.result!.userPrimaryPhone.toString()
                    : "";
            _editplayerProvider!.altcontactPhoneController!.text =
                _response.result!.userAlternatePhone != null &&
                        _response.result!.userAlternatePhone != "0"
                    ? _response.result!.userAlternatePhone.toString()
                    : "";
            _editplayerProvider!.emailController!.text = _response.result!.userEmailID??"";
            _editplayerProvider!.altemailController!.text =
                _response.result!.userAlternateEmailID??"";
            _editplayerProvider!.addressController!.text = _response.result!.userAddress1??"";
            _editplayerProvider!.altaddressController!.text =
                _response.result!.userAddress2??"";
            _editplayerProvider!.cityController!.text = _response.result!.userCity??"";
            _editplayerProvider!.shootController!.text = _response.result!.shoot??"";
            _editplayerProvider!.medicalNoteController!.text =
                _response.result!.medicalNote??"";
            _editplayerProvider!.noteController!.text = _response.result!.note??"";
            DateFormat formatter = new DateFormat('yyyy-MM-dd');
            if (_response.result!.userDOB != null && _response.result!.userDOB!.isNotEmpty) {
              DateTime dateTime = formatter.parse(_response.result!.userDOB!);
              _selectedDate = formatter.parse(_response.result!.userDOB!);
              _editplayerProvider!.DatePickerController!.text = dateformat == "US"
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
              _editplayerProvider!.DatePickerController!.text = "";
            }
            // _editplayerProvider.DatePickerController.text=_response.user.dateOfBirth != null ?_response.user.dateOfBirth : "";
            _editplayerProvider!.zipcodeController!.text = _response.result!.userZip??"";
            _editplayerProvider!.genderController!.text =
                _response.result!.userGender == null
                    ? ""
                    : _response.result!.userGender == "M"
                        ? MyStrings.male
                        : _response.result!.userGender == "F"
                            ? MyStrings.female
                            : MyStrings.others;
            gender = _response.result!.userGender == null
                ? ""
                : _response.result!.userGender == "M"
                    ? MyStrings.male
                    : _response.result!.userGender == "F"
                        ? MyStrings.female
                        : MyStrings.others;
            if (_response.result!.roleIdNo == Constants.owner &&
                _response.result!.playerInd == 2) {
              _editplayerProvider!.setManager(true);
              _editplayerProvider!.setNonPlayer(true);
            } else if (_response.result!.roleIdNo == Constants.owner &&
                _response.result!.playerInd == 3) {
              _editplayerProvider!.setManager(true);
            } else {
              _editplayerProvider!.setManager(
                  _response.result!.roleIdNo == Constants.coachorManager
                      ? true
                      : false);
              _editplayerProvider!
                  .setNonPlayer(_response.result!.playerInd == 1 ? true : false);
            }
            _editplayerProvider!.UserIDNo = _response.result!.userIdNo;
            _editplayerProvider!.playerAvailabilityStatusId =
                _response.result!.playerAvailabilityStatusId;
            imageBytes = _response.result!.userProfileImage != null
                ? base64Decode(_response.result!.userProfileImage!)
                : null;
            _editplayerProvider!.jersetNumberController!.text =
                _response.result!.userJerseyNumber??"";
            _editplayerProvider!.stateController!.text = _response.result!.userState??"";
            _editplayerProvider!.positionController!.text =
                _response.result!.userGamePosition??"";
            _editplayerProvider!.roleID = _response.result!.roleIdNo.toString();
            _editplayerProvider!.userRoleId = _response.result!.UserRoleId;
          });
        }
        /*else if (_response.status == Constants.failed) {
          CodeSnippet.instance.showMsg(_response.errorMessage);
          print("400");
        } else {
          CodeSnippet.instance.showMsg(_response.errorMessage);
          print("else");
        }*/
        break;
      case ResponseIds.ADD_PLAYER_SCREEN:
        ValidateUserResponse _response = any as ValidateUserResponse;
        if (_response.responseResult == Constants.success) {
          var response = _response.responseMessage!.split(",");

          DynamicLinksService()
              .createDynamicLink("create_Password_Screen?userid=" +
                  response.first +
                  "&team=" +
                  await SharedPrefManager.instance
                      .getStringAsync(Constants.teamName) +
                  "&player=" +
                  _editplayerProvider!.firstNameController!.text +
                  "&manager=" +
                  await SharedPrefManager.instance
                      .getStringAsync(Constants.userName) +
                  "&teamid=" +
                  teamIDNo.toString() +
                  "&email=" +
                  _editplayerProvider!.emailController!.text +
                  "&userRoleId=" +
                  response.last +
                  "&fcm=" +
                  (await SharedPrefManager.instance
                          .getStringAsync(Constants.FCM))
                      .toString() +
                  "&toMail=" +
                  (await SharedPrefManager.instance
                          .getStringAsync(Constants.userId))
                      .toString() +
                  "&toID=" +
                  (await SharedPrefManager.instance
                          .getStringAsync(Constants.userIdNo))
                      .toString())
              .then((acceptvalue) async {
            print(acceptvalue);
            DynamicLinksService()
                .createDynamicLink("intro_Screen?userid=" +
                    response.first +
                    "&teamid=" +
                    teamIDNo.toString() +
                    "&email=" +
                    _editplayerProvider!.emailController!.text +
                    "&userRoleId=" +
                    response.last +
                    "&team=" +
                    await SharedPrefManager.instance
                        .getStringAsync(Constants.teamName) +
                    "&player=" +
                    _editplayerProvider!.firstNameController!.text +
                    "&manager=" +
                    await SharedPrefManager.instance
                        .getStringAsync(Constants.userName) +
                    "&fcm=" +
                    (await SharedPrefManager.instance
                            .getStringAsync(Constants.FCM))
                        .toString() +
                    "&toMail=" +
                    (await SharedPrefManager.instance
                            .getStringAsync(Constants.userId))
                        .toString() +
                    "&toID=" +
                    (await SharedPrefManager.instance
                            .getStringAsync(Constants.userIdNo))
                        .toString())
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
                  _editplayerProvider!.emailController!.text,
                  _editplayerProvider!.firstNameController!.text +
                      " " +
                      _editplayerProvider!.lastNameController!.text,
                  acceptvalue,
                  declainvalue,
                  teamName!,
                  userName!);
            });
          });
/*

    DynamicLinksService().createDynamicLink("create_Password_Screen?userid="+response.first+"&teamid="+teamIDNo.toString()+"&email="+_editplayerProvider.emailController.text+"&userRoleId="+response.last).then((acceptvalue){
            print(acceptvalue);
            DynamicLinksService().createDynamicLink("intro_Screen?userid="+response.first+"&teamid="+teamIDNo.toString()+"&email="+_editplayerProvider.emailController.text+"&userRoleId="+response.last).then((declainvalue){
              print(declainvalue);
              EmailService().invitePlayer("Team Member Invite","Invitation",InviteMember.inviteMember.replaceAll("{{playername}}", _editplayerProvider.firstNameController.text).replaceAll("{{acceptlink}}}", acceptvalue).replaceAll("{{declainlink}}}", declainvalue).replaceAll("{{teamname}}", teamName).replaceAll("{{managername}}", userName),Constants.teamInvite,userID,int.parse(response.first),teamIDNo,"You have been invited to join "+teamName, _editplayerProvider.emailController.text);

            });
          });
*/

          Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 1);
        } else if (_response.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else if (_response.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors![0].errorMessage!);
        } else {
          //  CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.ADD_EXISTING_PLAYER:
        AddExistingPlayerResponse _addExistingPlayer =
            any as AddExistingPlayerResponse;
        if (_addExistingPlayer.result != null &&_addExistingPlayer.result!.userIDNo != null &&
            _addExistingPlayer.result!.userIDNo != Constants.success) {
          setState(() {
            isMemberExist = true;
          });
          // showPlayers();
          //Navigation.navigateWithArgument(context, MyRoutes.homeScreen, 1);
        } else if (_addExistingPlayer.result == null && _addExistingPlayer.result!.userIDNo == null) {
          setState(() {
            isMemberExist = false;
          });
          // CodeSnippet.instance.showMsg("No Results were found");
        }
        if (
            _editplayerProvider!.roleID != Constants.owner.toString() &&
            _editplayerProvider!.playerAvailabilityStatusId ==
                Constants.mailNotSend) {
          DynamicLinksService()
              .createDynamicLink("create_Password_Screen?userid=" +
                  _editplayerProvider!.UserIDNo.toString() +
                  "&teamid=" +
                  teamIDNo.toString() +
                  "&email=" +
                  _editplayerProvider!.emailController!.text +
                  "&userRoleId=" +
                  _editplayerProvider!.userRoleId.toString() +
                  "&team=" +
                  teamName! +
                  "&player=" +
                  _editplayerProvider!.firstNameController!.text +
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
                    _editplayerProvider!.UserIDNo.toString() +
                    "&teamid=" +
                    teamIDNo.toString() +
                    "&email=" +
                    _editplayerProvider!.emailController!.text +
                    "&userRoleId=" +
                    _editplayerProvider!.userRoleId.toString() +
                    "&team=" +
                    teamName! +
                    "&player=" +
                    _editplayerProvider!.firstNameController!.text +
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
                  _editplayerProvider!.UserIDNo!,
                  teamIDNo!,
                  "You have been invited to join " + teamName!,
                  _editplayerProvider!.emailController!.text,
                  _editplayerProvider!.firstNameController!.text +
                      " " +
                      _editplayerProvider!.lastNameController!.text,
                  acceptvalue,
                  declainvalue,
                  teamName!,
                  userName!);
            });
          });
        }
        Navigator.of(context).pop();
        Navigation.navigateWithArgument(
            context, MyRoutes.playerProfile, widget.userId);
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
Use:To handle backpress action.
 */
  void _onBackPressed() {
    FocusScope.of(context).requestFocus(FocusNode());
     showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => FancyDialog(
                  gifPath: MyImages.team,
                  okFun: () => {
                    Navigator.of(context).pop(),
                    Navigator.of(context).pop(),
                    Navigation.navigateWithArgument(
                        context, MyRoutes.playerProfile, widget.userId),
                  },
                  cancelFun: () => {Navigator.of(context).pop()},
                  cancelColor: MyColors.red,
                  title: MyStrings.conformDiscardChanges,
                ));
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
        // File imageFile = File(file.path);
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

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: (){_onBackPressed();
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
                          title: MyStrings.editPlayer,
                          iconRight: MyIcons.done,
                          tooltipMessageRight: MyStrings.save,
                          iconLeft: MyIcons.cancel,
                          tooltipMessageLeft: MyStrings.cancel,
                          onClickRightImage: () {
                            _updatePlayerDetails();
                            //Navigation.navigateTo(context, MyRoutes.homeScreen);
                          },
                          onClickLeftImage: () {
                            _onBackPressed();
                          },
                        ),
                        body: SingleChildScrollView(
                            controller: _scrollControllerMain,
                            child: Consumer<EditPlayerProvider>(
                                builder: (context, provider, _) {
                              return Form(
                                key: _formKey,
                                autovalidateMode:AutovalidateMode.disabled,
                                child: SafeArea(
                                  child: Container(
                                    width: size.width,
                                    constraints: BoxConstraints(
                                        minHeight: size.height - 30),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                  /* mainAxisAlignment: !isMobile(context)
                                                  ? MainAxisAlignment.start
                                                  : MainAxisAlignment.center,
                                              crossAxisAlignment: !isMobile(context)
                                                  ? CrossAxisAlignment.start
                                                  : CrossAxisAlignment.center,*/
                                                  children: <Widget>[
                                                    // if (isMobile(context))
                                                    /*   if (getValueForScreenType<bool>(
                              context: context,
                              mobile: false,
                              tablet: true,
                              desktop: true,
                            ))
                                                  CustomAppBar(
                                                  title: MyStrings.editPlayer,
                                                  iconRight: MyIcons.done,
                                                  iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
                                                  onClickRightImage: () {
                                                    _updatePlayerDetails();
                                                    //Navigation.navigateTo(context, MyRoutes.homeScreen);
                                                  },
                                                  onClickLeftImage: () {
                                                    _onBackPressed();
                                                  },
                                                ),*/
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
                                                                  ? CircleAvatar(
                                                                backgroundImage:
                                                                     MemoryImage(
                                                              Uint8List.fromList(imageBytes!))
                                                                        ,

                                                                backgroundColor:
                                                                    MyColors
                                                                        .kPrimaryLightColor,
                                                                radius: Consts
                                                                    .avatarRadius,
                                                              ):CircleAvatar(
                                                                backgroundImage:
                                                                AssetImage(
                                                                  MyImages.noImageData,
                                                                ),

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
                                                                        value:
                                                                            2,
                                                                        child: Text(
                                                                            MyStrings.imageTooltipRemove),
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
                                                                    FontWeight
                                                                        .w700),
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
                                                                labelText: MyStrings
                                                                        .firstName +
                                                                    "*",
                                                                inputFormatter: [
                                                                  new LengthLimitingTextInputFormatter(
                                                                      25),
                                                                ],
                                                                controller: provider
                                                                    .firstNameController,
                                                                inputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                // suffixImage: MyImages.dropDown,
                                                                isEnabled: true,
                                                                validator:
                                                                    ValidateInput
                                                                        .requiredFieldsFirstName,
                                                                onSave:
                                                                    (value) {
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
                                                              onPointerDown:
                                                                  (_) {
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
                                                                inputFormatter: [
                                                                  new LengthLimitingTextInputFormatter(
                                                                      25),
                                                                ],
                                                                controller: provider
                                                                    .lastNameController,
                                                                inputAction:
                                                                    TextInputAction
                                                                        .next,
                                                                // suffixImage: MyImages.dropDown,
                                                                validator:
                                                                    ValidateInput
                                                                        .requiredFieldsLastName,
                                                                isEnabled: true,
                                                                onSave:
                                                                    (value) {
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
                                                          DatePickerTextfieldWidget(
                                                            suffixIcon: MyIcons
                                                                .calendar,
                                                            // suffixIcon: MyIcons.calendar,
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
                                                                    child:
                                                                        Focus(
                                                                      focusNode:
                                                                          _node,
                                                                      onFocusChange:
                                                                          (bool
                                                                              focus) {
                                                                        setState(
                                                                            () {});
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
                                                                              ? size.width - 78
                                                                              : getValueForScreenType<bool>(
                                                                                  context: context,
                                                                                  mobile: false,
                                                                                  tablet: true,
                                                                                  desktop: false,
                                                                                )
                                                                                  ? size.width * 0.4
                                                                                  : size.width * 0.40,
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
                                                                          value: provider.genderController!.text.isEmpty
                                                                              ? null
                                                                              : provider.genderController!.text,
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
                                                                            provider.genderController!.text =
                                                                                val.toString();
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
                                                                  if (role != null &&
                                                                          int.parse(role!) ==
                                                                              Constants
                                                                                  .owner ||
                                                                      int.parse(
                                                                              role??"") ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                  if (role != null &&
                                                                          int.parse(role!) ==
                                                                              Constants
                                                                                  .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    Focus(
                                                                      focusNode:
                                                                          _node,
                                                                      onFocusChange:
                                                                          (bool
                                                                              focus) {
                                                                        setState(
                                                                            () {
                                                                          _webDatePicker == true
                                                                              ? _webDatePicker = false
                                                                              : _webDatePicker = false;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(_node);
                                                                        },
                                                                        child:
                                                                            CustomizeTextFormField(
                                                                          labelText:
                                                                              MyStrings.jerseyNumber,
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                          inputFormatter: <
                                                                              TextInputFormatter>[
                                                                            FilteringTextInputFormatter.digitsOnly,
                                                                            new LengthLimitingTextInputFormatter(10)
                                                                          ],
                                                                          controller:
                                                                              provider.jersetNumberController,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          isEnabled:
                                                                              true,
                                                                          inputAction:
                                                                              TextInputAction.next,
                                                                          onSave:
                                                                              (value) {
                                                                            provider.jersetNumberController!.text =
                                                                                value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    Focus(
                                                                      focusNode:
                                                                          _node,
                                                                      onFocusChange:
                                                                          (bool
                                                                              focus) {
                                                                        setState(
                                                                            () {
                                                                          _webDatePicker == true
                                                                              ? _webDatePicker = false
                                                                              : _webDatePicker = false;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(_node);
                                                                        },
                                                                        child:
                                                                            CustomizeTextFormField(
                                                                          labelText:
                                                                              MyStrings.position,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(25),
                                                                          ],
                                                                          controller:
                                                                              provider.positionController,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          inputAction:
                                                                              TextInputAction.next,
                                                                          isEnabled:
                                                                              true,
                                                                          onSave:
                                                                              (value) {
                                                                            provider.positionController!.text =
                                                                                value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    Focus(
                                                                      focusNode:
                                                                          _node,
                                                                      onFocusChange:
                                                                          (bool
                                                                              focus) {
                                                                        setState(
                                                                            () {
                                                                          _webDatePicker == true
                                                                              ? _webDatePicker = false
                                                                              : _webDatePicker = false;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(_node);
                                                                        },
                                                                        child:
                                                                            CustomizeTextFormField(
                                                                          labelText:
                                                                              MyStrings.shoot,
                                                                          inputFormatter: [
                                                                            new LengthLimitingTextInputFormatter(30),
                                                                          ],
                                                                          controller:
                                                                              provider.shootController,
                                                                          // suffixImage: MyImages.dropDown,
                                                                          inputAction:
                                                                              TextInputAction.next,
                                                                          isEnabled:
                                                                              true,
                                                                          onSave:
                                                                              (value) {
                                                                            provider.shootController!.text =
                                                                                value!;
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    Focus(
                                                                      focusNode:
                                                                          _node,
                                                                      onFocusChange:
                                                                          (bool
                                                                              focus) {
                                                                        setState(
                                                                            () {
                                                                          _webDatePicker == true
                                                                              ? _webDatePicker = false
                                                                              : _webDatePicker = false;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Listener(
                                                                        onPointerDown:
                                                                            (_) {
                                                                          FocusScope.of(context)
                                                                              .requestFocus(_node);
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
                                                                            inputFormatter: [
                                                                              new LengthLimitingTextInputFormatter(100),
                                                                            ],
                                                                            controller:
                                                                                provider.medicalNoteController,
                                                                            minLines:
                                                                                3,
                                                                            maxLines:
                                                                                3,
                                                                            // suffixImage: MyImages.dropDown,
                                                                            keyboardType:
                                                                                TextInputType.multiline,
                                                                            inputAction:
                                                                                TextInputAction.newline,
                                                                            isEnabled:
                                                                                true,
                                                                            onSave:
                                                                                (value) {
                                                                              provider.medicalNoteController!.text = value!;
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
                                                                    SizedBox(
                                                                      height: SizedBoxSize
                                                                          .standardSizedBoxHeight,
                                                                      width: SizedBoxSize
                                                                          .standardSizedBoxWidth,
                                                                    ),
                                                                  if (int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager)
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
                                                                            width:
                                                                                SizedBoxSize.checkSizedBoxWidth,
                                                                            child:
                                                                                Theme(
                                                                              data: ThemeData(
                                                                                unselectedWidgetColor: Colors.black,
                                                                              ),
                                                                              child: Checkbox(
                                                                                hoverColor: MyColors.transparent,
                                                                                focusColor: MyColors.transparent,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(2.0),
                                                                                  side: BorderSide(
                                                                                    color: Colors.grey,
                                                                                    width: 1.5,
                                                                                  ),
                                                                                ),
                                                                                side: BorderSide(
                                                                                  color: Colors.grey,
                                                                                  width: 1.5,
                                                                                ),
                                                                                checkColor: MyColors.black,
                                                                                activeColor: Colors.grey[400],
                                                                                value: provider.getManager,
                                                                                onChanged: (value) {
                                                                                  setState(() {
                                                                                    _webDatePicker == true ? _webDatePicker = false : _webDatePicker = false;

                                                                                    provider.setManager(value!);
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                250,
                                                                            child:
                                                                                ListTile(
                                                                              title: Text(
                                                                                MyStrings.managerAccess,
                                                                              ),
                                                                              subtitle: Text(
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
                                                                      width:
                                                                          330,
                                                                      child:
                                                                          Card(
                                                                        margin: const EdgeInsets.only(
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
                                                                            MyColors.colorGray_666BC,
                                                                        child:
                                                                            SfDateRangePicker(
                                                                          initialDisplayDate: _selectedDate != null
                                                                              ? _selectedDate
                                                                              : DateTime.now(),
                                                                          initialSelectedDate:
                                                                              _selectedDate,
                                                                          view:
                                                                              DateRangePickerView.month,
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
                                                                            setState(() {
                                                                              provider.DatePickerController!.text = value.toString();
                                                                            });
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
                                                          if (int.parse(role!) ==
                                                                  Constants
                                                                      .owner ||
                                                              int.parse(role!) ==
                                                                  Constants
                                                                      .coachorManager)
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Material(
                                                                  child:
                                                                      SizedBox(
                                                                    height: SizedBoxSize
                                                                        .checkSizedBoxHeight,
                                                                    width: SizedBoxSize
                                                                        .checkSizedBoxWidth,
                                                                    child:
                                                                        Checkbox(
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(2.0),
                                                                        side:
                                                                            BorderSide(
                                                                          color:
                                                                              Colors.grey,
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
                                                                          Colors
                                                                              .grey[400],
                                                                      value: provider
                                                                          .getNonPlayer,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          provider
                                                                              .setNonPlayer(value!);
                                                                          _webDatePicker == true
                                                                              ? _webDatePicker = false
                                                                              : _webDatePicker = false;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    width: 250,
                                                                    child:
                                                                        ListTile(
                                                                      title:
                                                                          Text(
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
                                                                    fontSize: getValueForScreenType<bool>(
                                                                      context:
                                                                          context,
                                                                      mobile:
                                                                          false,
                                                                      tablet:
                                                                          false,
                                                                      desktop:
                                                                          true,
                                                                    )
                                                                        ? FontSize.headerFontSize1
                                                                        : FontSize.headerFontSize3,
                                                                    fontWeight: FontWeight.w700),
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
                                                                        MyStrings.email +
                                                                            "*",
                                                                    inputFormatter: [
                                                                      new LengthLimitingTextInputFormatter(
                                                                          100),
                                                                    ],
                                                                    // prefixIcon: MyIcons.mail,
                                                                    controller:
                                                                        provider
                                                                            .emailController,
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .emailAddress,
                                                                    // suffixImage: MyImages.dropDown,
                                                                    validator:
                                                                        ValidateInput
                                                                            .validateEmail,
                                                                    isEnabled:
                                                                        true,
                                                                    onChange:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        isEmailEdited =
                                                                            true;
                                                                      });
                                                                    },
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                    inputFormatter: [
                                                                      new LengthLimitingTextInputFormatter(
                                                                          100),
                                                                    ],
                                                                    // prefixIcon: MyIcons.mail,
                                                                    controller:
                                                                        provider
                                                                            .altemailController,
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                            .contactPhone,
                                                                    hintText:
                                                                        MyStrings
                                                                            .noFormat,
                                                                    controller:
                                                                        provider
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
                                                                    isEnabled:
                                                                        true,
                                                                    onSave:
                                                                        (value) {
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    inputFormatter: <
                                                                        TextInputFormatter>[
                                                                      FilteringTextInputFormatter
                                                                          .digitsOnly,
                                                                      new LengthLimitingTextInputFormatter(10)
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                    // suffixImage: MyImages.dropDown,
                                                                    isEnabled:
                                                                        true,
                                                                    inputFormatter: [
                                                                      new LengthLimitingTextInputFormatter(
                                                                          50),
                                                                    ],
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                    // suffixImage: MyImages.dropDown,
                                                                    isEnabled:
                                                                        true,
                                                                    inputFormatter: [
                                                                      new LengthLimitingTextInputFormatter(
                                                                          50),
                                                                    ],
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                    inputFormatter: [
                                                                      new LengthLimitingTextInputFormatter(
                                                                          25),
                                                                    ],
                                                                    controller:
                                                                        provider
                                                                            .cityController,
                                                                    // suffixImage: MyImages.dropDown,
                                                                    isEnabled:
                                                                        true,
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                    inputFormatter: [
                                                                      new LengthLimitingTextInputFormatter(
                                                                          25),
                                                                    ],
                                                                    controller:
                                                                        provider
                                                                            .stateController,
                                                                    // suffixImage: MyImages.dropDown,
                                                                    isEnabled:
                                                                        true,
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                            .zipcode,
                                                                    inputFormatter: [
                                                                      new LengthLimitingTextInputFormatter(
                                                                          10),
                                                                    ],
                                                                    controller:
                                                                        provider
                                                                            .zipcodeController,
                                                                    // suffixImage: MyImages.dropDown,
                                                                    isEnabled:
                                                                        true,
                                                                    onFieldSubmit: (v){
                                                                      FocusScope.of(context).requestFocus(_notenode);
                                                                    },
                                                                    inputAction:
                                                                        TextInputAction
                                                                            .next,
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
                                                                focusNode:
                                                                    _node,
                                                                onFocusChange:
                                                                    (bool
                                                                        focus) {
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
                                                                      focusNode: _notenode,
                                                                      inputFormatter: [
                                                                        new LengthLimitingTextInputFormatter(
                                                                            100),
                                                                      ],
                                                                      controller:
                                                                          provider
                                                                              .noteController,
                                                                      minLines:
                                                                          3,
                                                                      maxLines:
                                                                          3,
                                                                      inputAction:
                                                                          TextInputAction
                                                                              .newline,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,

                                                                      // suffixImage: MyImages.dropDown,
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
                                                              addFamilyList(),
                                                              SizedBox(
                                                                height: SizedBoxSize
                                                                    .standardSizedBoxHeight,
                                                                width: SizedBoxSize
                                                                    .standardSizedBoxWidth,
                                                              ),
                                                              if ((int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .owner ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .coachorManager ||
                                                                      int.parse(
                                                                              role!) ==
                                                                          Constants
                                                                              .teamPlayer) &&
                                                                  provider.roleID !=
                                                                      Constants
                                                                          .familyMember
                                                                          .toString())
                                                                Container(
                                                                    child:
                                                                        RaisedButtonCustom(
                                                                  buttonColor:
                                                                      MyColors
                                                                          .kPrimaryColor,
                                                                  buttonWidth: getValueForScreenType<
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
                                                                      ? null
                                                                      : size.width *
                                                                          WidgetCustomSize
                                                                              .raisedButtonWebWidth,
                                                                  textColor:
                                                                      MyColors
                                                                          .white,
                                                                  splashColor:
                                                                      Colors
                                                                          .grey,
                                                                  buttonText:
                                                                      MyStrings
                                                                          .addFamily,
                                                                  onPressed:
                                                                      () {
                                                                    //Constants.familyCount++;
                                                                    _editplayerProvider!
                                                                        .familyFirstnamecontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyLastnamecontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyEmailcontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyContactcontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyAddresscontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyCitycontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyStatecontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyZipcodecontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyuserIDcodecontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyMiddleNamecontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyDOBcontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyGendercontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyCountrycontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyAddress2controller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyAltEmailcontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyAltContactcontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyFCMcontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyPlayerAvailabilitycontroller
                                                                        .add(
                                                                            TextEditingController());
                                                                    _editplayerProvider!
                                                                        .familyuserIDcodecontroller
                                                                        .last
                                                                        .text = "-1";
                                                                    _addFamily();
                                                                  },
                                                                ))
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
                            }))),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
