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

class HomeMenuScreen extends StatefulWidget {
  @override
  _HomeMenuScreenState createState() => _HomeMenuScreenState();
}

class _HomeMenuScreenState extends BaseState<HomeMenuScreen> {
  @override
  //region Private Members

  List? userdata;
  final _formKey = GlobalKey<FormState>();
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
                  Padding(
                    padding: const EdgeInsets.only(
                        // top: PaddingSize.boxPaddingLeft,
                        left: PaddingSize.boxPaddingTop,
                        right: PaddingSize.boxPaddingRight,
                        bottom: PaddingSize.boxPaddingBottom),
                    child: Container(
                        width: Dimens.standard_300,
                        height: Dimens.dp_50,
                        decoration: BoxDecoration(
                          color: MyColors.kPrimaryColor,
                          // border: new Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(
                              PaddingSize.circleRadiusSmall),
                        ),
                        child: ListTile(
                          leading: MyIcons.group,
                          title: Text(
                            teamName == null ? "Team Name" : teamName!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: Dimens.letterSpacing_25,
                                color: MyColors.white),
                          ),
                        )),
                  ),
                  /* MenuScreenCard(
    title: MyStrings.selectTeam,
    icon: Icon(Icons.group),
    color: MyColors.kPrimaryMidiumColor,
    onPressed: () {
    Navigation.navigateWithArgument(
        context, MyRoutes.selectTeamScreen, Constants.navigateIdOne);
    },
    ),
    MenuScreenCard(
    title: MyStrings.availability,
    icon: Icon(Icons.event_available),
    color: MyColors.kPrimaryMidiumColor,
    onPressed: () {
    Navigation.navigateTo(context, MyRoutes.availabilityScreen);
    },
    ),*/
                  Column(
                    children: [
                      MenuScreenCard(
                        title: MyStrings.uploads,
                        icon: Icon(
                          Icons.perm_media,
                          color: MyColors.black,
                        ),
                        color: MyColors.kPrimaryColor,
                        onPressed: () {
                          Navigation.navigateWithArgument(
                              context, MyRoutes.mediaListScreen, 0);
                        },
                      ),
                      MenuScreenCard(
                        title: MyStrings.videos,
                        icon: Icon(
                          Icons.video_call_outlined,
                          color: MyColors.black,
                        ),
                        color: MyColors.kPrimaryColor,
                        onPressed: () {
                          Navigation.navigateTo(
                              context, MyRoutes.VideoPlayerListScreen);
                        },
                      ),
                      if (!kIsWeb)
                        MenuScreenCard(
                          title: MyStrings.notifiPrefer,
                          icon: Icon(
                            Icons.settings,
                            color: MyColors.black,
                          ),
                          color: MyColors.kPrimaryColor,
                          onPressed: () {
                            Navigation.navigateTo(context,
                                MyRoutes.NotificationPreferencesScreen);
                          },
                        ),
                      // MenuScreenCard(
                      //   title: MyStrings.sharedDrill,
                      //   icon: Icon(
                      //     Icons.list_alt,
                      //     color: MyColors.black,
                      //   ),
                      //   color: MyColors.kPrimaryColor,
                      //   onPressed: () {
                      //     Navigation.navigateTo(
                      //         context, MyRoutes.sharedDrillScreen);
                      //   },
                      // ),
                      // if (int.parse(roleId == null ? "0" : roleId) ==
                      //         Constants.owner ||
                      //     int.parse(roleId == null ? "0" : roleId) ==
                      //         Constants.coachorManager)
                      //   MenuScreenCard(
                      //     title: MyStrings.drill,
                      //     icon: Icon(
                      //       Icons.view_list,
                      //       color: MyColors.black,
                      //     ),
                      //     color: MyColors.kPrimaryColor,
                      //     onPressed: () {
                      //       Constant.isEditDrill = 0;
                      //       Navigation.navigateTo(
                      //           context, MyRoutes.selectDrillScreen);
                      //     },
                      //   ),
                      // if (int.parse(roleId == null ? "0" : roleId) ==
                      //         Constants.owner ||
                      //     int.parse(roleId == null ? "0" : roleId) ==
                      //         Constants.coachorManager)
                        // MenuScreenCard(
                        //   title: MyStrings.createDrill,
                        //   icon: Icon(
                        //     Icons.sports_hockey,
                        //     color: MyColors.black,
                        //   ),
                        //   color: MyColors.kPrimaryColor,
                        //   onPressed: () {
                        //     Constant.isEditDrill = 1;
                        //     Navigation.navigateWithArgument(
                        //         context, MyRoutes.coachHomeScreen, 1);
                        //   },
                        // ),
                      // MenuScreenCard(
                      //   title: MyStrings.removevolunteer,
                      //   icon: Icon(Icons.accessibility_new_sharp,color: MyColors.black,),
                      //   color: MyColors.kPrimaryColor,
                      //   onPressed: () {
                      //     Navigation.navigateTo(context, MyRoutes.VolunteerSuperAdminScreen);
                      //   },
                      //
                      // ),
                      userEmail == Constants.systemUser
                          ? MenuScreenCard(
                              title: MyStrings.removevolunteer,
                              icon: Icon(
                                Icons.accessibility_new_sharp,
                                color: MyColors.black,
                              ),
                              color: MyColors.kPrimaryColor,
                              onPressed: () {
                                Navigation.navigateTo(context,
                                    MyRoutes.VolunteerSuperAdminScreen);
                              },
                            )
                          : Container(),
                      // MenuScreenCard(
                      //   title: MyStrings.volunteer,
                      //   icon: Icon(Icons.accessibility_new_sharp,color: MyColors.black,),
                      //   color: MyColors.kPrimaryColor,
                      //   onPressed: () {
                      //     Navigation.navigateTo(context, MyRoutes.VolunteerSuperAdminScreen);
                      //   },
                      //
                      // ),

                      /* MenuScreenCard(
                    title: MyStrings.inviteorrequest,
                    icon: Icon(Icons.outgoing_mail),
                    color: MyColors.kPrimaryMidiumColor,
                    onPressed: () {
                      Navigation.navigateWithArgument(context, MyRoutes.inviteCoachScreen, Constants.navigateIdOne);
                    },
                  ),*/
                      getValueForScreenType<bool>(
                        context: context,
                        mobile: false,
                        tablet: false,
                        desktop: true,
                      )
                          ? MenuScreenCard(
                              title: MyStrings.changePassword,
                              icon: Icon(
                                Icons.password,
                                color: MyColors.black,
                              ),
                              color: MyColors.kPrimaryColor,
                              onPressed: () {
                                Navigation.navigateWithArgument(context,
                                    MyRoutes.resetPasswordScreen, [""]);
                              },
                            )
                          : SizedBox()
                      /* MenuScreenCard(
    title: MyStrings.logOut,
    icon: MyIcons.logout,
    color: MyColors.kPrimaryMidiumColor,
    onPressed: () {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => FancyDialog(
              gifPath: MyImages.team,


              okFun: () => {
                SharedPrefManager.instance
                    .setStringAsync(Constants.userEmail, null),
                SharedPrefManager.instance
                    .setStringAsync(Constants.roleId, null),
                SharedPrefManager.instance
                    .setStringAsync(Constants.teamName, null),
                SharedPrefManager.instance
                    .setStringAsync(Constants.userIdNo, null),
                Navigator.of(context).pop(),
                Navigation.navigatePushNamedAndRemoveAll(
                    context, MyRoutes.signIn),
              },
              cancelFun: () => {Navigator.of(context).pop()},
              title: MyStrings.wantLogout,
        ));
    },
    ),*/
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
}
