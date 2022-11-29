import 'package:connectivity/connectivity.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as a;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_response.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
import 'package:spaid/service/exception_error_util.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_listview_screen_ui.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_provider.dart';
import 'package:spaid/ui/home_screen/roasters_listview/roasters_listview_screen_provider.dart';
import 'package:spaid/ui/signup_screen/signup_screen_provider.dart';
import 'package:spaid/ui/volunteer_screen/volunteer_screen_ui.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_password_field.dart';
import 'package:spaid/widgets/custom_raised_button.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:spaid/widgets/volunteer_list_card.dart';

class VolunteerListviewScreen extends StatefulWidget {
  @override
  _VolunteerListviewScreenState createState() => _VolunteerListviewScreenState();
}

class _VolunteerListviewScreenState extends BaseState<VolunteerListviewScreen> {
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
  bool isSelected=false;
  //endregion
  Stream _connectivityStream = Connectivity().onConnectivityChanged;

  //region Private Members
  List<String> _playerSelect = [];
  List<TextEditingController> _namecontroller = [];
  List<List<TextEditingController>> _volunteerPlayernamecontroller = [];
  List<TextEditingController> _nameIDcontroller = [];
  List<TextEditingController> _checckboxcontroller = [];
  bool? isLoading;

  //endregion


  @override
  void initState() {
    super.initState();
    _volunteerProvider = Provider.of<VolunteerProvider>(context, listen: false);
    _addEventProvider = Provider.of<AddEventProvider>(context, listen: false);
    _roasterListViewProvider = Provider.of<RoasterListViewProvider>(context, listen: false);
    _volunteerProvider!.listener = this;
    _roasterListViewProvider!.listener = this;
    isLoading=true;


    for(int i=0;i<_addEventProvider!.volunteerCheckBoxController.length;i++){
      String _name =_addEventProvider!.volunteerNameController[i].text;
      List<TextEditingController> _player = _addEventProvider!.volunteerPlayernamecontroller[i];
      String _id = _addEventProvider!.volunteerIDController[i].text;
      String _checckbox = _addEventProvider!.volunteerCheckBoxController[i].text;
      print(_checckbox);
      _checckboxcontroller.add(TextEditingController(text: _checckbox));
    _nameIDcontroller.add(TextEditingController(text: _id));
    _namecontroller.add(TextEditingController(text: _name));
if(_checckbox=="true") {
  _volunteerPlayernamecontroller.add(_player);
}else{
  List<TextEditingController> name=[];
  _volunteerPlayernamecontroller.add(name);
}
    }



    print(_nameIDcontroller.length);

    _roasterListViewProvider!.getSelectTeamAsync();

    if(_nameIDcontroller.length==0){
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   ProgressBar.instance.showProgressbar(context);
      // });
      _volunteerProvider!.getVolunteerAsync();

    }

    /*for (int i = 0; i < volunteerChoice.length; i++) {
      if (volunteerChoice[i].isDelete == false) {
        _namecontroller.add(TextEditingController());
        _namecontroller[i].text = volunteerChoice[i].name;
        _checckboxcontroller.add(TextEditingController());
        _checckboxcontroller[i].text = "false";
      }
    }*/
  }
  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_VOLUNTEER:
        setState(() {
          _volunteerResponse = any as VolunteerResponse;
          for (int i = 0; i < _volunteerResponse!.result!.voluenteerList!.length; i++) {
            print("Marlen2");
            _namecontroller.add(TextEditingController());
              _nameIDcontroller.add(TextEditingController());
              List<TextEditingController> name=[];
              _volunteerPlayernamecontroller.add(name);
              _namecontroller[i].text = _volunteerResponse!.result!.voluenteerList![i].voluenteerTypeName!;
              _nameIDcontroller[i].text = _volunteerResponse!.result!.voluenteerList![i].voluenteerTypeId.toString();
              _checckboxcontroller.add(TextEditingController());
              _checckboxcontroller[i].text = "false";
          }

        });
        break;
      case ResponseIds.GET_TEAM_MEMBER_SCREEN:
        setState(() {
          isLoading=false;

        });
        RoasterListViewResponse _response = any as RoasterListViewResponse;
        if (_response.result!.teamIDNo != null) {
          setState(() {
            roasterListViewResponse = _response;

          });
        }
        /*if (_response.status == Constants.success) {

        } else if (_response.status == Constants.failed) {
         *//* CodeSnippet.instance.showMsg(MyStrings.createTeamFailed);
          print("400");*//*
        } else {
         *//* CodeSnippet.instance.showMsg(_response.errorMessage);
          print("else");*//*
        }*/
        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    setState(() {
      isLoading=false;

    });
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }
  bool getValidate() {
    if(_checckboxcontroller.isNotEmpty){
      for(int i=0;i<_checckboxcontroller.length;i++){
        if (_checckboxcontroller[i].text == "true") {
          isSelected=true;
        }
        if(_checckboxcontroller[i].text == "true" && _volunteerPlayernamecontroller[i].length<=0){
          CodeSnippet.instance.showMsg("Select volunteers");
          return false;
        }
        else if(_namecontroller[i].text.isEmpty){
          CodeSnippet.instance.showMsg("Enter volunteer type");
          return false;
        }
      }
    }
    return true;
  }



  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;
    // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    return    Scaffold(
      resizeToAvoidBottomInset: false,
      //   appBar: CustomAppBar(
    //   title: MyStrings.volunteer,
    //   iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
    //   iconRight: MyIcons.done,
    //   onClickRightImage: () {
    //     Navigator.of(context).pop();
    //   },
    //   onClickLeftImage: () {
    //     Navigator.of(context).pop();
    //   },
    // ),
     body:  Consumer<SignUpProvider>(builder: (context, provider, _) {
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
                        marginVertical:  20,
                        marginhorizontal: 40,
                        child: Scaffold(
                          backgroundColor: MyColors.white,
                          appBar: CustomAppBar(
                            title: MyStrings.volunteer,
                            iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
                            iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
                            onClickRightImage: () {
                              if( getValidate()){
                                _addEventProvider!.volunteerCheckBoxController=_checckboxcontroller;
                                _addEventProvider!.volunteerIDController=_nameIDcontroller;
                                _addEventProvider!.volunteerNameController=_namecontroller;
                                _addEventProvider!.volunteerPlayernamecontroller=_volunteerPlayernamecontroller;
                                _addEventProvider!.roasterListViewResponse=roasterListViewResponse;
                                _addEventProvider!.volSelected=isSelected;
                                _addEventProvider!.setRefreshScreen();
                                Navigator.of(context).pop();
                              }

                            },
                          ),
                          body:isLoading!?SkeletonListView(): SingleChildScrollView(
                            child: SizedBox(
                              height: getValueForScreenType<bool>(
                                context: context,
                                mobile: false,
                                tablet: false,
                                desktop: true,) ? screenHeight : null,
                              child: Padding(
                                padding: EdgeInsets.all(getValueForScreenType<bool>(
                                  context: context,
                                  mobile: false,
                                  tablet: true,
                                  desktop: true,)
                                    ? PaddingSize.headerPadding1
                                    : PaddingSize.headerPadding2),
                                // EdgeInsets.symmetric(horizontal: PaddingSize.headerCardPadding),
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                  child: SingleChildScrollView(
                                    //physics: NeverScrollableScrollPhysics(),
                                    child: Column(
                                      mainAxisAlignment: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,)
                                          ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: getValueForScreenType<bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: false,
                                            desktop: true,)
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[

                                            roasterListViewResponse !=null? ListView.builder(
                                              physics: NeverScrollableScrollPhysics(),
                                              shrinkWrap: true, // new
                                              itemCount: _namecontroller.length == null
                                                  ? 0
                                                  : _namecontroller.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                Future.delayed(Duration.zero, () {
                                                  // setState(() {
                                                  //
                                                  // });
                                                });
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
                                                if (roasterListViewResponse !=
                                                    null) {
                                                  for (int i = 0;
                                                  i <
                                                      roasterListViewResponse!
                                                          .result!.userDetails!
                                                          .length;
                                                  i++) {
                                                    if (roasterListViewResponse!
                                                        .result!.userDetails![i]
                                                        .PlayerAvailabilityStatusId ==
                                                        Constants.accept ||
                                                        roasterListViewResponse!
                                                            .result!.userDetails![i]
                                                            .roleIdNo ==
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
                                                    _volunteerPlayernamecontroller[index],
                                                    roasterListViewResponse!,
                                                    selected,
                                                    names,
                                                    delete: (int){
                                                      setState(() {
                                                        _namecontroller.removeAt(int);
                                                        _checckboxcontroller.removeAt(int);
                                                        _volunteerPlayernamecontroller.removeAt(int);
                                                        _nameIDcontroller.removeAt(int);
                                                      });
                                                    },
                                                    myValue: (positioned) {
                                                      setState(() {
                                                        _checckboxcontroller[index].text ==
                                                            "false"
                                                            ? _checckboxcontroller[index].text =
                                                        "true"
                                                            : _checckboxcontroller[index].text =
                                                        "false";
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
                                            ):Container(),



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
                          ),
                          floatingActionButton: FloatingActionButton(
                            tooltip: MyStrings.tooltipAddVolunteer,
                            onPressed: () {
                              setState(() {
                                _namecontroller.add(TextEditingController());
                                _nameIDcontroller.add(TextEditingController());
                                _checckboxcontroller.add(TextEditingController());
                                List<TextEditingController> name=[];
                                _volunteerPlayernamecontroller.add(name);
                                _checckboxcontroller.last.text = "false";

                                // penalty.add('Penalty ${penalty.length}');
                              });
                            },
                            backgroundColor: MyColors.kPrimaryColor,
                            child: const Icon(Icons.add,color: MyColors.white,),
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
