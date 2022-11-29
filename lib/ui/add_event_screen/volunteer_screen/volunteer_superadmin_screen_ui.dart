import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_response.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
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
import 'package:spaid/widgets/volunteer_list_card1.dart';

class VolunteerSuperAdminScreen extends StatefulWidget {
  get index => null;

  @override
  _VolunteerSuperAdminScreenState createState() =>
      _VolunteerSuperAdminScreenState();

  void delete(index) {}
}

class _VolunteerSuperAdminScreenState
    extends BaseState<VolunteerSuperAdminScreen> {
  @override
  //region Private Members
  VolunteerProvider? _volunteerProvider;
  VolunteerResponse? _volunteerResponse;
  String? countryCode;
  final _formKey = GlobalKey<FormState>();


  //endregion

  //region Private Members
  List<TextEditingController> _namecontroller = [];
  List<List<TextEditingController>> _volunteerPlayernamecontroller = [];
  List<TextEditingController> _nameIDcontroller = [];
  bool? isLoading;

  //endregion

  @override
  void initState() {
    super.initState();
    _volunteerProvider = Provider.of<VolunteerProvider>(context, listen: false);

    _volunteerProvider!.listener = this;
    isLoading = true;

    _volunteerProvider!.getVolunteerAsync();

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
            print("Marlen2");
            _namecontroller.add(TextEditingController());
            _nameIDcontroller.add(TextEditingController());
            List<TextEditingController> name = [];
            _volunteerPlayernamecontroller.add(name);
            _namecontroller[i].text =
                _volunteerResponse!.result!.voluenteerList![i].voluenteerTypeName!;
            _nameIDcontroller[i].text = _volunteerResponse!
                .result!.voluenteerList![i].voluenteerTypeId
                .toString();
            // _checckboxcontroller.add(TextEditingController());
            // _checckboxcontroller[i].text = "false";
          }
          isLoading = false;

        });
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

  // bool getValidate() {
  //   if(_checckboxcontroller.isNotEmpty){
  //     for(int i=0;i<_checckboxcontroller.length;i++){
  //       if(_checckboxcontroller[i].text == "true" && _volunteerPlayernamecontroller[i].length<=0){
  //         CodeSnippet.instance.showMsg("Select volunteers");
  //         return false;
  //       }
  //       else if(_namecontroller[i].text.isEmpty){
  //         CodeSnippet.instance.showMsg("Enter volunteer type");
  //         return false;
  //       }
  //     }
  //   }
  //   return true;
  // }
  bool getValidate() {
      for(int i=0;i<_namecontroller.length;i++){

  if(_namecontroller[i].text.isEmpty){
          CodeSnippet.instance.showMsg("Enter volunteer type");
          return false;
        }
      }

    return true;
  }

  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height * .80;
    //final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                Expanded(
                  child: WebCard(
                    marginVertical: 10,
                    marginhorizontal: 10,
                    child: Scaffold(
                      backgroundColor: MyColors.white,
                      appBar: CustomAppBar(
                        title: MyStrings.volunteer,
                        iconRight: MyIcons.done,
                        tooltipMessageRight: MyStrings.save,
                        iconLeft: MyIcons.cancel,
                        tooltipMessageLeft: MyStrings.cancel,
                        onClickRightImage: () {
                          if( getValidate()){
                            for(int i=0;i<_nameIDcontroller.length;i++){
                              if(_nameIDcontroller[i].text.isEmpty){
                                _volunteerProvider!
                                    .addVolunteerAsync(
                                    _namecontroller[i]
                                        .text);
                              }
                            }

                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      body: isLoading!
                          ? SkeletonListView()
                          : SingleChildScrollView(
                              child: SizedBox(
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
                                  child: ScrollConfiguration(
                                    behavior: ScrollConfiguration.of(context)
                                        .copyWith(scrollbars: false),
                                    child: SingleChildScrollView(
                                      //physics: NeverScrollableScrollPhysics(),
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
                                              _volunteerResponse != null
                                                  ? ListView.builder(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true, //
                                                // new

                                                      itemCount: _namecontroller
                                                                  .length ==
                                                              null
                                                          ? 0
                                                          : _namecontroller
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {

                                                        return VolunteerScreenCardAdmin(
                                                            context,
                                                            index,
                                                            _namecontroller[
                                                                index],
                                                            delete: (int) {
                                                          setState(() {
                                                            if(_nameIDcontroller[int].text.isNotEmpty) {
                                                              _volunteerProvider!
                                                                  .deleteVolunteerAsync(
                                                                  _nameIDcontroller[int]
                                                                      .text);
                                                            }
                                                            _namecontroller
                                                                .removeAt(int);
                                                            _volunteerPlayernamecontroller
                                                                .removeAt(int);
                                                            _nameIDcontroller
                                                                .removeAt(int);
                                                          });
                                                        }, myValue:
                                                                (positioned) {
                                                          // setState(() {
                                                          //    _checckboxcontroller[index].text ==
                                                          //        "false"
                                                          //        ? _checckboxcontroller[index].text =
                                                          //    "true"
                                                          //        : _checckboxcontroller[index].text =
                                                          //    "false";
                                                          //   /* _playerSelect
                                                          //        .add(volunteerChoice[index].name);*/
                                                          //  });
                                                          // print(_playerSelect);
                                                        }, refresh: () {
                                                          //setState(() {});
                                                        }
                                                            // icon: MyIcons.sport,

                                                            );
                                                      },
                                                    )
                                                  : Container(),
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
}

// class Language {
//   final int id;
//   final String name;
//
//   const Language(
//     this.id,
//     this.name,
//   );
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
//     'Team Member',
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
