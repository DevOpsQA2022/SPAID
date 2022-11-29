
import 'dart:convert';

import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/volunteer_list_card.dart';

class VolunteerScreen extends StatefulWidget {
  @override
  _VolunteerScreenState createState() =>
      _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {
  //region Private Members
  String _selectedVolunteer = '';
  String? _playerchosenValue;
  List<S2Choice<String>> _volunteerSelect = [];
  List<TextEditingController> _namecontroller = [];
  List<TextEditingController> _checckboxcontroller = [];
  String id = "";

  //endregion

  @override
  initState() {
    super.initState();
    for (int i = 0; i < volunteerChoice.length; i++) {
      if (volunteerChoice[i].isDelete == false) {
        _namecontroller.add(TextEditingController());
        _namecontroller[i].text = volunteerChoice[i].name!;
        _checckboxcontroller.add(TextEditingController());
        _checckboxcontroller[i].text = "false";
      }
      _getJsonVolunteerAsync();
    }
  }

  // Fetch content from the json file
  Future<void> _getJsonVolunteerAsync() async {
    final String response =
    await rootBundle.loadString('assets/json/multi/volunteer_picker.json');
    final data = await json.decode(response);

    _volunteerSelect = S2Choice.listFrom<String, dynamic>(
      source: data[MyStrings.volunteer],
      group: (index, item) => item["index"].toString(),
      value: (index, item) => item[MyStrings.id],
      title: (index, item) => item[MyStrings.name],
      subtitle: (index, item) => item[MyStrings.description],
    );
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TopBar(
      child: Expanded(
        child: WebCard(
          marginVertical: 20,
          marginhorizontal: 40,
          child: Scaffold(
            backgroundColor: MyColors.white,
            appBar: CustomAppBar(
              title: MyStrings.volunteer,
              iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
              iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
              onClickRightImage: () {
                Navigation.navigateWithArgument(context,
                    MyRoutes.homeScreen, 0);
              },
              onClickLeftImage: (){
                Navigation.navigateWithArgument(
                    context,
                    MyRoutes.homeScreen, 0);
              },
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  constraints: BoxConstraints(minHeight: size.height -30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: MarginSize.headerMarginVertical3,
                            horizontal: 50),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,)
                                          ? PaddingSize.headerPadding1
                                          : PaddingSize.headerPadding2),
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
                                        height: 180,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            child: Column(
                                              children: _volunteerSelect
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
                                                        _selectedVolunteer = data.title;
                                                        id = data.group;
                                                      });
                                                    },
                                                  )).toList(),
                                            ),
                                          ),
                                        ),
                                      ),

                                        // SmartSelect<String>.single(
                                        //   title: MyStrings.volunteer,
                                        //   placeholder: MyStrings.selectOne,
                                        //   value: _selectedVolunteer,
                                        //   modalType: S2ModalType.fullPage,
                                        //   choiceType: S2ChoiceType.radios,
                                        //   onChange: (state) =>
                                        //       setState(() => _selectedVolunteer = state.value),
                                        //   choiceItems: _volunteerSelect,
                                        //   choiceDivider: true,
                                        // ),
                                      /*  ),
                                      ),
                                      ),*/
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
            ),

            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     setState(() {
            //       _namecontroller.add(TextEditingController());
            //       _checckboxcontroller.add(TextEditingController());
            //
            //       // penalty.add('Penalty ${penalty.length}');
            //     });
            //   },
            //   backgroundColor: MyColors.kPrimaryColor,
            //   child: const Icon(Icons.add),
            // ),
          ),
        ),
      ),
    );
  }
}
/*
Return Type:
Input Parameters:
Use: This is the temporary class to load static data.
 */

class Choice {
  Choice({this.name, this.isDelete, this.isChecked});

  final String? name;
  bool? isDelete;
  bool? isChecked;
}

List<Choice> volunteerChoice = <Choice>[
  Choice(
    name: "Water",
    isDelete: true,
    isChecked: false,
  ),
  Choice(
    name: "Cloth",
    isDelete: true,
    isChecked: false,
  ),
  Choice(
    name: "Contact",
    isDelete: true,
    isChecked: false,
  ),
  Choice(
    name: "Help",
    isDelete: true,
    isChecked: false,
  ),
  Choice(
    name: "Photo",
    isDelete: true,
    isChecked: false,
  ),
  Choice(
    name: "Emergency",
    isDelete: true,
    isChecked: false,
  ),
];
