import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/menu_screen_card.dart';

class CoachHomeScreen extends StatefulWidget {
  @override
  _CoachHomeScreenState createState() => _CoachHomeScreenState();
}

class _CoachHomeScreenState extends BaseState<CoachHomeScreen> {
  @override
  //region Private Members

  String? teamName = "", userEmail = "", roleId;

  //endregion

  @override
  void initState() {
    getTeamName();
  }

  void getTeamName() async {
    roleId = await SharedPrefManager.instance.getStringAsync(Constants.roleId);

    teamName =
    await SharedPrefManager.instance.getStringAsync(Constants.teamName);
    userEmail =
    await SharedPrefManager.instance.getStringAsync(Constants.userEmail);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WebCard(
      marginVertical: 20,
      marginhorizontal: 40,
      child: Scaffold(
        backgroundColor: MyColors.white,
        floatingActionButton: _getFAB(),

        body: Padding(
          padding: EdgeInsets.all(getValueForScreenType<bool>(
            context: context,
            mobile: false,
            tablet: true,
            desktop: true,
          )
              ? PaddingSize.headerPadding1
              : PaddingSize.headerPadding2),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    tablet: true,
                    desktop: true,
                  )
                      ? SizedBox(height: 0)
                      : SizedBox(
                    height: SizedBoxSize.standardSizedBoxHeight,
                  ),


                  Column(
                    children: [

                      MenuScreenCard(
                        title: MyStrings.sharedDrill,
                        icon: Icon(
                          Icons.list_alt,
                          color: MyColors.black,
                        ),
                        color: MyColors.kPrimaryColor,
                        onPressed: () {
                          Navigation.navigateTo(
                              context, MyRoutes.sharedDrillScreen);
                        },
                      ),
                      if (int.parse(roleId == null ? "0" : roleId!) ==
                          Constants.owner ||
                          int.parse(roleId == null ? "0" : roleId!) ==
                              Constants.coachorManager)
                        MenuScreenCard(
                          title: MyStrings.drill,
                          icon: Icon(
                            Icons.view_list,
                            color: MyColors.black,
                          ),
                          color: MyColors.kPrimaryColor,
                          onPressed: () {
                            Constant.isEditDrill = 0;
                            Navigation.navigateTo(
                                context, MyRoutes.selectDrillScreen);
                          },
                        ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getFAB() {
    // ignore: unrelated_type_equality_checks
    if (int.parse(roleId != null ? roleId! : "0") == Constants.owner ||
        int.parse(roleId != null ? roleId! : "0") == Constants.coachorManager) {
      return FloatingActionButton(

        tooltip: MyStrings.createDrill,
        onPressed: () => {
        Constant.isEditDrill = 1,
            Navigation.navigateWithArgument(
                context, MyRoutes.coachHomeScreen, 1),
        },
        backgroundColor: MyColors.kPrimaryColor,
        child: MyIcons.add_white,
      );
    } else {
      return Container();
    }
  }

}
