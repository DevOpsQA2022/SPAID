import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/add_game_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/model/response/game_event_response/game_team_response.dart';
import 'package:spaid/model/response/game_event_response/game_volunteers_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_response.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
import 'package:spaid/model/response/signup_response/validate_user_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_provider.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_loader.dart';
import 'package:spaid/widgets/volunteer_list_card.dart';

import 'availability_listview_provider.dart';

class UpdateVolunteerListviewScreen extends StatefulWidget {
  final GameOrEventList eventList;

  UpdateVolunteerListviewScreen(this.eventList);

  @override
  _UpdateVolunteerListviewScreenState createState() =>
      _UpdateVolunteerListviewScreenState();
}

class _UpdateVolunteerListviewScreenState
    extends BaseState<UpdateVolunteerListviewScreen> {
  @override
  //region Private Members
  VolunteerProvider? _volunteerProvider;
  AddEventProvider? _addEventProvider;
  RoasterListViewProvider? _roasterListViewProvider;
  VolunteerResponse? _volunteerResponse;
  String? countryCode;
  String? _rolechosenValue;
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  FocusNode _node = new FocusNode();
  Location location = new Location();
  RoasterListViewResponse? roasterListViewResponse;
  GetEventVoluenteers? getEventVoluenteersResponse;
  bool? isLoading;
  bool? _isShowing;
  BuildContext? popupContext;
  bool isSelected=false;

  //endregion

  //region Private Members
  List<String> _playerSelect = [];
  List<TextEditingController> _namecontroller = [];
  List<TextEditingController> _eventVoluenteerTypeIDNo = [];
  List<List<TextEditingController>> _volunteerPlayernamecontroller = [];
  List<TextEditingController> _nameIDcontroller = [];
  List<TextEditingController> _checckboxcontroller = [];
  AvailabilityListviewProvider? _availabilityListviewProvider;


  //endregion
  @override
  void initState() {
    super.initState();
    _volunteerProvider = Provider.of<VolunteerProvider>(context, listen: false);
    _addEventProvider = Provider.of<AddEventProvider>(context, listen: false);
    _roasterListViewProvider =
        Provider.of<RoasterListViewProvider>(context, listen: false);
    _availabilityListviewProvider =
        Provider.of<AvailabilityListviewProvider>(context, listen: false);
    _volunteerProvider!.listener = this;
    _roasterListViewProvider!.listener = this;
    //_addEventProvider.listener = this;
    isLoading = true;
    _volunteerProvider!.getSharedDataAsyncs();
    _volunteerProvider!.getVolunteerAsync();
    _volunteerProvider!.getTeamMembersEmailAsync();
    _roasterListViewProvider!.getSelectTeamAsync();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ProgressBar.instance.showProgressbar(context);
    // });

    /*for (int i = 0; i < volunteerChoice.length; i++) {
      if (volunteerChoice[i].isDelete == false) {
        _namecontroller.add(TextEditingController());
        _namecontroller[i].text = volunteerChoice[i].name;
        _checckboxcontroller.add(TextEditingController());
        _checckboxcontroller[i].text = "false";
      }
    }*/
  }

  void showProgressbar() {
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        popupContext = context;
        /*if(!_isShowing) {
          Navigator.of(context).pop();
        }*/
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CustomLoader());
      },
    );
  }

  void stopProgressBar() {
    if(popupContext != null)
      Navigator.of(popupContext!).pop();
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_VOLUNTEER:
        setState(() {
          _volunteerResponse = any as VolunteerResponse;
          for (int i = 0;
          i < _volunteerResponse!.result!.voluenteerList!.length ;
          i++) {
            _namecontroller.add(TextEditingController());
            _eventVoluenteerTypeIDNo.add(TextEditingController());
            _nameIDcontroller.add(TextEditingController());
            List<TextEditingController> name = [];
            _volunteerPlayernamecontroller.add(name);
            _namecontroller[i].text =
                _volunteerResponse!.result!.voluenteerList![i].voluenteerTypeName!;
            _nameIDcontroller[i].text = _volunteerResponse!
                .result!.voluenteerList![i].voluenteerTypeId
                .toString();
            _checckboxcontroller.add(TextEditingController());
            _checckboxcontroller[i].text = "false";
          }
        });
        break;
      case ResponseIds.GET_TEAM_MEMBER_SCREEN:
        RoasterListViewResponse _response = any as RoasterListViewResponse;
        if (_response.result!.teamIDNo != null) {
          _volunteerProvider!.getEventVoluenteersAsync(widget.eventList.eventId!);
          setState(() {
            roasterListViewResponse = _response;
          });
        }

        break;
      case ResponseIds.UPDATE_VOLUNTEER_STATUS:
        AddGameResponse _response = any as AddGameResponse;
        if (_response.responseResult == Constants.success) {
          Future.delayed(Duration(seconds: 2), () async {
            stopProgressBar();

            Navigator.of(context).pop();
            try {
              _availabilityListviewProvider!.setRefreshScreen();
              _addEventProvider!.setRefreshScreen();
            } catch (e) {
              _addEventProvider!.setRefreshScreen();
              _availabilityListviewProvider!.setRefreshScreen();
                          }
          });

        } /*else if (_response.responseResult == Constants.failed) {
          // showError(_response.saveErrors[0].errorMessage);
          CodeSnippet.instance.showMsg(_response.saveErrors[0].errorMessage);
        } */else {
          // CodeSnippet.instance.showMsg(MyStrings.signUpFailed);
        }
        break;
      case ResponseIds.UPDATE_VOLUNTEER:
        getEventVoluenteersResponse = any as GetEventVoluenteers;
        if (getEventVoluenteersResponse!.result!.volunteerList!.isNotEmpty) {
          setState(() {
            for (int i = 0; i < _nameIDcontroller.length; i++) {
              for (int j = 0;
              j < getEventVoluenteersResponse!.result!.volunteerList!.length;
              j++) {
                if (_nameIDcontroller[i].text ==
                    getEventVoluenteersResponse!.result!.volunteerList![j].volunteerTypeId
                        .toString()) {
                  _checckboxcontroller[i].text = "true";
                  List<TextEditingController> name = [];
                  List<int> playerVolId=[];
                  for (int k = 0;
                  k <
                      getEventVoluenteersResponse!
                          .result!.volunteerList![j].userIDList!.length;
                  k++) {
                    for (int l = 0;
                    l < roasterListViewResponse!.result!.userDetails!.length;
                    l++) {
                      if (roasterListViewResponse!.result!.userDetails![l].userIdNo ==
                          getEventVoluenteersResponse!
                              .result!.volunteerList![j].userIDList![k]) {
                        if(playerVolId.isEmpty){
                          playerVolId.add( getEventVoluenteersResponse!
                              .result!.volunteerList![j].userIDList![k]);
                          name.add(TextEditingController());
                          name[k].text = roasterListViewResponse!
                              .result!.userDetails![l].userFirstName! +" "+roasterListViewResponse!
                              .result!.userDetails![l].userLastName!;
                        }else{
                          if(!playerVolId.contains(roasterListViewResponse!.result!.userDetails![l].userIdNo)){
                            playerVolId.add( getEventVoluenteersResponse!
                                .result!.volunteerList![j].userIDList![k]);
                            name.add(TextEditingController());
                            name[k].text = roasterListViewResponse!
                                .result!.userDetails![l].userFirstName! +" "+roasterListViewResponse!
                                .result!.userDetails![l].userLastName!;
                          }
                        }

                      }
                    }
                  }
                  _volunteerPlayernamecontroller[i].addAll(name);

                  _eventVoluenteerTypeIDNo[i].text = getEventVoluenteersResponse!
                      .result!.volunteerList![j].eventVoluenteerTypeIDNo
                      .toString();
                }
              }
            }

            for (int j = 0;
            j < getEventVoluenteersResponse!.result!.volunteerList!.length;
            j++) {
              if (getEventVoluenteersResponse!
                  .result!.volunteerList![j].volunteerTypeId! >_volunteerResponse!.result!.voluenteerList!.length) {
                _namecontroller.add(TextEditingController());
                _eventVoluenteerTypeIDNo.add(TextEditingController());
                _nameIDcontroller.add(TextEditingController());
                _checckboxcontroller.add(TextEditingController());
                List<TextEditingController> name = [];
                _volunteerPlayernamecontroller.add(name);
                _namecontroller.last.text = getEventVoluenteersResponse!
                    .result!.volunteerList![j].volunteerTypeName!;
                _checckboxcontroller.last.text = "true";
                _nameIDcontroller.last.text = getEventVoluenteersResponse!
                    .result!.volunteerList![j].volunteerTypeId
                    .toString();
                _eventVoluenteerTypeIDNo.last.text = getEventVoluenteersResponse!
                    .result!.volunteerList![j].eventVoluenteerTypeIDNo
                    .toString();
                List<TextEditingController> names = [];
                List<int> number = [];
                for (int k = 0;
                k <
                    getEventVoluenteersResponse!
                        .result!.volunteerList![j].userIDList!.length;
                k++) {
                  for (int l = 0;
                  l < roasterListViewResponse!.result!.userDetails!.length;
                  l++) {
                    if (roasterListViewResponse!.result!.userDetails![l].userIdNo ==
                        getEventVoluenteersResponse!
                            .result!.volunteerList![j].userIDList![k]) {
                      if (number.isEmpty) {
                        number.add(getEventVoluenteersResponse!
                            .result!.volunteerList![j].userIDList![k]);
                        names.add(TextEditingController());
                        names[k].text =
                            roasterListViewResponse!.result!.userDetails![l]
                                .userFirstName! + " " + roasterListViewResponse!
                                .result!.userDetails![l].userLastName!;
                      } else {
                        if(!number.contains(getEventVoluenteersResponse!
                            .result!.volunteerList![j].userIDList![k])) {
                          number.add(getEventVoluenteersResponse!
                              .result!.volunteerList![j].userIDList![k]);
                          names.add(TextEditingController());
                          names[k].text =
                              roasterListViewResponse!.result!.userDetails![l]
                                  .userFirstName! + " " + roasterListViewResponse!
                                  .result!.userDetails![l].userLastName!;
                        }
                      }
                    }
                  }
                }
                print(_volunteerPlayernamecontroller.length);
                _volunteerPlayernamecontroller[
                _volunteerPlayernamecontroller.length - 1]
                    .addAll(names);
                print(_volunteerPlayernamecontroller.length);
                print(_volunteerPlayernamecontroller.last.length);
              }
            }
          });
        }
        Future.delayed(Duration.zero, () {
          setState(() {
            isLoading = false;
          });
        });
        /*  Future.delayed(Duration.zero, () {
          if(roasterListViewResponse != null){
            setState(() {
              isLoading=false;
            });
          }
        });*/

        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    setState(() {
      isLoading = false;
    });
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;
    // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //   appBar: CustomAppBar(
      //   title: MyStrings.volunteer,
      //   iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
      //   iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
      //   onClickRightImage: () {
      //     Navigator.of(context).pop();
      //   },
      //   onClickLeftImage: () {
      //     Navigator.of(context).pop();
      //   },
      // ),
      body: Consumer<SignUpProvider>(builder: (context, provider, _) {
        return Form(
          key: _formKey,
          //             //Future Purpose
          //             // autovalidateMode: !provider.getAutoValidate
          //             //     ? AutovalidateMode.disabled
          //             //     : AutovalidateMode.always,
          //             autovalidate: !provider.getAutoValidate ? false : true,
          child: TopBar(
            child: Row(
              children: [
                // if (getValueForScreenType<bool>(
                //   context: context,
                //   mobile: false,
                //   tablet: true,
                //   desktop: true,
                // ))Expanded(
                //     child: Image.asset(
                //       MyImages.signin,
                //       height: size.height * ImageSize.signInImageSize,
                //     ),
                //   ),
                Expanded(
                  child: WebCard(
                    marginVertical: 20,
                    marginhorizontal: 40,
                    child: Scaffold(
                      // resizeToAvoidBottomPadding: false,
                      backgroundColor: MyColors.white,
                      appBar: CustomAppBar(
                        title: MyStrings.volunteer,
                        iconRight: MyIcons.done,
                        tooltipMessageRight: MyStrings.save,
                        iconLeft: MyIcons.cancel,
                        tooltipMessageLeft: MyStrings.cancel,
                        onClickRightImage: () {
                          _volunteerProvider!.volunteerCheckBoxController = [];
                          _volunteerProvider!.volunteerIDController = [];
                          _volunteerProvider!.volunteerNameController = [];
                          _volunteerProvider!.eventVoluenteerTypeIDNo = [];
                          _volunteerProvider!.volunteerPlayernamecontroller = [];
                          if( getValidate()){

                            showProgressbar();
                            _volunteerProvider!.volunteerCheckBoxController =
                                _checckboxcontroller;
                            _volunteerProvider!.volunteerIDController =
                                _nameIDcontroller;
                            _volunteerProvider!.volunteerNameController =
                                _namecontroller;
                            _volunteerProvider!.eventVoluenteerTypeIDNo =
                                _eventVoluenteerTypeIDNo;
                            _volunteerProvider!.volunteerPlayernamecontroller =
                                _volunteerPlayernamecontroller;
                            _volunteerProvider!.roasterListViewResponse =
                                roasterListViewResponse!;
                            _addEventProvider!.volSelected=isSelected;
                            // _addEventProvider.setRefreshScreen();
                            _volunteerProvider!.updateVolunteerList(widget.eventList,context);
                            _addEventProvider!.volSelected=isSelected;
                            // _addEventProvider.setRefreshScreen();
                            // Navigator.of(context).pop();
                          }


                          //_addEventProvider.setRefreshScreen();
                        },
                      ),
                      body: isLoading!
                          ? SkeletonListView()
                          : SingleChildScrollView(
                        child: SizedBox(
                          height: getValueForScreenType<bool>(
                            context: context,
                            mobile: false,
                            tablet: false,
                            desktop: false,
                          )
                              ? screenHeight
                              : null,
                          child: Padding(
                            padding: EdgeInsets.all(
                                getValueForScreenType<bool>(
                                  context: context,
                                  mobile: false,
                                  tablet: true,
                                  desktop: true,
                                )
                                    ? PaddingSize.headerPadding1
                                    : PaddingSize.headerPadding2),
                            // EdgeInsets.symmetric(horizontal: PaddingSize.headerCardPadding),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Column(
                                mainAxisAlignment:
                                getValueForScreenType<bool>(
                                  context: context,
                                  mobile: false,
                                  tablet: true,
                                  desktop: true,
                                )
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                    getValueForScreenType<bool>(
                                      context: context,
                                      mobile: false,
                                      tablet: false,
                                      desktop: true,
                                    )
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      ListView.builder(
                                        physics:
                                        NeverScrollableScrollPhysics(),
                                        shrinkWrap: true, // new
                                        itemCount:
                                        _namecontroller.length == null
                                            ? 0
                                            : _namecontroller.length,
                                        itemBuilder:
                                            (BuildContext context,
                                            int index) {
                                          print(_namecontroller[index]
                                              .text);
                                          print(
                                              _checckboxcontroller[index]
                                                  .text);
                                          print(
                                              _volunteerPlayernamecontroller[
                                              index]
                                                  .length);
                                          Future.delayed(
                                              Duration.zero, () {});
                                          List<String> selected = [];
                                          if (_volunteerPlayernamecontroller[
                                          index] !=
                                              null) {
                                            for (int i = 0;
                                            i <
                                                _volunteerPlayernamecontroller[
                                                index]
                                                    .length;
                                            i++) {
                                              selected.add(
                                                  _volunteerPlayernamecontroller[
                                                  index][i]
                                                      .text);
                                            }
                                          }
                                          List<String> names = [];
                                          List<int> userid = [];
                                          if (roasterListViewResponse != null) {
                                            for (int i = 0; i < roasterListViewResponse!.result!.userDetails!.length; i++) {
                                              if (roasterListViewResponse!.result!.userDetails![i].PlayerAvailabilityStatusId ==
                                                  Constants.accept || roasterListViewResponse!.result!.userDetails![i].roleIdNo ==
                                                  Constants.owner) {
                                                if(names.isEmpty) {
                                                  userid.add(roasterListViewResponse!
                                                      .result!.userDetails![i]
                                                      .userIdNo!);
                                                  names.add(
                                                      roasterListViewResponse!
                                                          .result!.userDetails![i]
                                                          .userFirstName! +
                                                          " " +
                                                          roasterListViewResponse!
                                                              .result!.userDetails![i]
                                                              .userLastName!);
                                                }else{
                                                  if(!userid.contains(roasterListViewResponse!.result!.userDetails![i].userIdNo)){
                                                    userid.add(roasterListViewResponse!
                                                        .result!.userDetails![i]
                                                        .userIdNo!);
                                                    names.add(
                                                        roasterListViewResponse!
                                                            .result!.userDetails![i]
                                                            .userFirstName! +
                                                            " " +
                                                            roasterListViewResponse!
                                                                .result!.userDetails![i]
                                                                .userLastName!);

                                                  }
                                                }

                                              }
                                            }
                                          }
                                          return VolunteerScreenCard(
                                              context,
                                              index,
                                              _namecontroller[index],
                                              _nameIDcontroller[index],
                                              _checckboxcontroller[index],
                                              _volunteerPlayernamecontroller[
                                              index],
                                              roasterListViewResponse!,
                                              selected,
                                              names,
                                              delete: (int){
                                                setState(() {
                                                  _namecontroller.removeAt(int);
                                                  _eventVoluenteerTypeIDNo.removeAt(int);
                                                  _checckboxcontroller.removeAt(int);
                                                  _volunteerPlayernamecontroller.removeAt(int);
                                                  _nameIDcontroller.removeAt(int);
                                                });
                                              },
                                              myValue: (positioned) {
                                                setState(() {
                                                  _checckboxcontroller[index]
                                                      .text ==
                                                      "false"
                                                      ? _checckboxcontroller[
                                                  index]
                                                      .text = "true"
                                                      : _checckboxcontroller[
                                                  index]
                                                      .text = "false";
                                                  /* _playerSelect
                                                          .add(volunteerChoice[index].name);*/
                                                });
                                                // print(_playerSelect);
                                              }, refresh: () {
                                            setState(() {});
                                          }
                                            // icon: MyIcons.sport,

                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 50,
                                  )

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        tooltip: MyStrings.tooltipAddVolunteer,
                        onPressed: () {
                          setState(() {
                            _namecontroller.add(TextEditingController());
                            _eventVoluenteerTypeIDNo
                                .add(TextEditingController());
                            _nameIDcontroller.add(TextEditingController());
                            _checckboxcontroller.add(TextEditingController());
                            List<TextEditingController> name = [];
                            _volunteerPlayernamecontroller.add(name);
                            _checckboxcontroller.last.text = "false";
                            // penalty.add('Penalty ${penalty.length}');
                          });
                        },
                        backgroundColor: MyColors.kPrimaryColor,
                        child: const Icon(
                          Icons.add,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool getValidate() {
    bool isChecked=false;
    if(_checckboxcontroller.isNotEmpty){
      for(int i=0;i<_checckboxcontroller.length;i++){
        if (_checckboxcontroller[i].text == "true") {
          isSelected=true;
        }
        if(_checckboxcontroller[i].text == "true"){
          isChecked=true;
        }
        if(_checckboxcontroller[i].text == "true" && _volunteerPlayernamecontroller[i].length<=0){
          CodeSnippet.instance.showMsg("Select volunteers");
          return false;
        }else if(_namecontroller[i].text.isEmpty){
          CodeSnippet.instance.showMsg("Enter volunteer type");
          return false;
        }
      }
      // if(isChecked){
      //   return true;
      //
      // }else {
      //   CodeSnippet.instance.showMsg("Select volunteers");
      //   return false;
      // }

    }
    return true;

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
    'Team Member',
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
