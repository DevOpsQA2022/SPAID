/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/volunteer_list_card.dart';

class VolunteerListviewDemoScreen extends StatefulWidget {
  @override
  _VolunteerListviewDemoScreenState createState() =>
      _VolunteerListviewDemoScreenState();
}

class _VolunteerListviewDemoScreenState extends State<VolunteerListviewDemoScreen> {
  //region Private Members
  List<String> _playerSelect = [];
  List<TextEditingController> _namecontroller = [];
  List<TextEditingController> _checckboxcontroller = [];

  //endregion

  @override
  initState() {
    super.initState();
    for (int i = 0; i < volunteerChoice.length; i++) {
      if (volunteerChoice[i].isDelete == false) {
        _namecontroller.add(TextEditingController());
        _namecontroller[i].text = volunteerChoice[i].name;
        _checckboxcontroller.add(TextEditingController());
        _checckboxcontroller[i].text = "false";
      }
    }
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
              iconRight: MyIcons.done,
              iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
              onClickRightImage: () {
                Navigator.of(context).pop();
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
                            horizontal: MarginSize.headerMarginVertical3),
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
                                    */
/*mainAxisAlignment: !isMobile(context)
                                      ? MainAxisAlignment.start
                                      : MainAxisAlignment.center,
                                  crossAxisAlignment: !isMobile(context)
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.center,*//*

                                    children: <Widget>[
                                      // if (isMobile(context))
                                      ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true, // new
                                        itemCount: _namecontroller.length == null
                                            ? 0
                                            : _namecontroller.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return VolunteerScreenCard(
                                              context,
                                              index,
                                              _namecontroller[index],
                                              _checckboxcontroller[index],
                                              myValue: (positioned) {
                                                setState(() {
                                                  _checckboxcontroller[index].text ==
                                                      "false"
                                                      ? _checckboxcontroller[index].text =
                                                  "true"
                                                      : _checckboxcontroller[index].text =
                                                  "false";
                                                  _playerSelect
                                                      .add(volunteerChoice[index].name);
                                                });
                                                print(_playerSelect);
                                              }, refresh: () {
                                            setState(() {});
                                          }
                                            // icon: MyIcons.sport,

                                          );
                                        },
                                      ),
                                      */
/*  ),
                                      ),
                                      ),*//*

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

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _namecontroller.add(TextEditingController());
                  _checckboxcontroller.add(TextEditingController());

                  // penalty.add('Penalty ${penalty.length}');
                });
              },
              backgroundColor: MyColors.kPrimaryColor,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
*/
/*
Return Type:
Input Parameters:
Use: This is the temporary class to load static data.
 *//*


class Choice {
  Choice({this.name, this.isDelete, this.isChecked});

  final String name;
  bool isDelete;
  bool isChecked;
}

List<Choice> volunteerChoice = <Choice>[
  Choice(
    name: "Water",
    isDelete: false,
    isChecked: false,
  ),
  Choice(
    name: "Cloth",
    isDelete: false,
    isChecked: false,
  ),
  Choice(
    name: "Contact",
    isDelete: false,
    isChecked: false,
  ),
  Choice(
    name: "Help",
    isDelete: false,
    isChecked: false,
  ),
  Choice(
    name: "Photo",
    isDelete: false,
    isChecked: false,
  ),
  Choice(
    name: "Emergency",
    isDelete: false,
    isChecked: false,
  ),
];
*/
