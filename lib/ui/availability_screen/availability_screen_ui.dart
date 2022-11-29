import 'dart:convert';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/game_availablity_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/availability_screen/availability_listview_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/availability_card.dart';
import 'package:spaid/widgets/custom_availability_tabbar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';

class AvailabilityScreen extends StatefulWidget {
  @override
  _AvailabilityScreenState createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends BaseState<AvailabilityScreen> {
  //region Private Members
  List? userdata;
  List? userdatas;
  bool screenChange = false;
  TabController? _tabController;
  int _selectedTab = 0;
  List? player;
  String _userRole = "";
  AvailabilityListviewProvider? _availabilityListviewProvider;

  //GetGameAvailablityResponse _getGameAvailablityResponse;
  bool? isLoading;
  List<TeamEventList> teamEventList = [];
  String? dateformat, first;

  //EventListviewProvider _eventListviewProvider;
//endregion

  @override
  void initState() {
    super.initState();
    _availabilityListviewProvider =
        Provider.of<AvailabilityListviewProvider>(context, listen: false);
    _availabilityListviewProvider!.listener = this;
    isLoading = true;
    getCountryCodeAsyncs();
    _getDataAsync();
    /* _eventListviewProvider =
        Provider.of<EventListviewProvider>(context, listen: false);
    _eventListviewProvider.listener = this;
    _eventListviewProvider.getGameAsync();*/

    _availabilityListviewProvider!.getAvailabilityGameAsync();

    /* _tabController = TabController(initialIndex: 0, length: 4, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController.index;
        });
      }
    });*/
    // _getJsonTimeZoneAsync();
  }

  Future<void> getCountryCodeAsyncs() async {
    first =
        "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  _getDataAsync() async {
    try {
      _userRole =
          await SharedPrefManager.instance.getStringAsync(Constants.roleId);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onSuccess(any, {int? reqId}) {
    setState(() {
      isLoading = false;
    });
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_AVAILABILITY_GAME:
        setState(() {
          // _getGameAvailablityResponse = any as GetGameAvailablityResponse;
          GetGameAvailablityResponse _getGameAvailablityResponse =
              any as GetGameAvailablityResponse;
          if (_getGameAvailablityResponse != null ||
              _getGameAvailablityResponse.teamEventList == null) {
            for (int i = 0;
                i < _getGameAvailablityResponse.teamEventList!.length;
                i++) {
              if (_getGameAvailablityResponse.teamEventList![i].Status ==
                      Constants.upcoming ||
                  _getGameAvailablityResponse.teamEventList![i].Status ==
                      Constants.ongoing) {
                teamEventList.add(_getGameAvailablityResponse.teamEventList![i]);
              }
            }
          }
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

  void _availablePlayer() {
    setState(() {
      availablePlayerTab();
    });
  }

  /*
Return Type:Widget
Input Parameters:
Use: To create Listview Items.
 */
  Widget availablePlayerTab() {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        leading: IconButton(
            iconSize: ImageSize.standardIconSize,
            icon: Icon(
              Icons.arrow_back,
              color: MyColors.white,
            ),
            onPressed: () => {
                  getValueForScreenType<bool>(
                    context: context,
                    mobile: true,
                    tablet: false,
                    desktop: false,
                  )
                      ? Navigator.of(context).pop()
                      : setState(() {
                          screenChange = false;
                        }),
                }),
        centerTitle: true,
        title: Text(MyStrings.availability),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * .1),
          child: Column(
            children: <Widget>[
              Material(
                color: MyColors.kPrimaryColor,
                child: Padding(
                  padding: EdgeInsets.all(PaddingSize.headerPadding2),
                  child: CustomAvailabilityTabBar(
                    tabController: _tabController,
                    selectedTab: _selectedTab,
                    firstTabName: MyStrings.available,
                    secondTabName: MyStrings.notAvailable,
                    thirdTabName: MyStrings.tentative,
                    fourthTabName: MyStrings.notResponded,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  /*AvailablePlayerScreen(player, MyStrings.available),
                  AvailablePlayerScreen(player, MyStrings.notAvailable),
                  AvailablePlayerScreen(player, MyStrings.tentative),
                  AvailablePlayerScreen(player, MyStrings.notResponded),*/
                  // SabhaListEvent(_tabController)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
Return Type:
Input Parameters:Json Data
Use: Read Data from Json File.
 */
  Future<void> _getJsonTimeZoneAsync() async {
    final String response = await rootBundle
        .loadString('assets/json/multi/availability_picker.json');
    final resBody = await json.decode(response);

    setState(() {
      userdata = resBody["availability"];
      print(userdata);
    });
  }

  @override
  Widget build(BuildContext context) {

    return WebCard(
      marginVertical: 20,
      marginhorizontal: 40,
      child: Padding(
        padding: EdgeInsets.all(getValueForScreenType<bool>(
          context: context,
          mobile: false,
          tablet: true,
          desktop: true,
        )
            ? PaddingSize.headerPadding1
            : PaddingSize.headerPadding2),
        child: isLoading!
            ? SkeletonListView()
            : teamEventList == null || teamEventList.isEmpty
                ? Container(
                    alignment: Alignment.center,
                    child: EmptyWidget(
                      image: null,
                      packageImage: PackageImage.Image_3,
                      title: 'No Data',
                      subTitle: null,
                      titleTextStyle: TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ),
                  )
                : Scaffold(
                    backgroundColor: MyColors.white,
                    body: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 0,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: teamEventList == null
                                  ? 0
                                  : teamEventList.length,
                              // itemCount: response.length != null?response.length:0,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      screenChange = true;
                                    });
                                    Navigation.navigateWithArgument(
                                        context,
                                        MyRoutes.availablePlayerScreen,
                                        teamEventList[index]);
                                  },
                                  child: AvailabilityListCard(
                                    titleText: teamEventList[index].eventName,
                                    address: teamEventList[index]
                                                .LocationAddress !=
                                            null
                                        ? teamEventList[index].LocationAddress
                                        : "",
                                    date: teamEventList[index].scheduleDate,
                                    time: teamEventList[index].scheduleTime,
                                    available: teamEventList[index]
                                        .available
                                        .toString(),
                                    reject:
                                        teamEventList[index].reject.toString(),
                                    notRespond: teamEventList[index]
                                        .notRespond
                                        .toString(),
                                    mailNotSend: teamEventList[index]
                                        .mailNotSend
                                        .toString(),
                                    mayBe:
                                        teamEventList[index].MayBe.toString(),
                                    profileImageString:
                                        teamEventList[index].eventType ==
                                                Constants.event
                                            ? MyImages.eventImg
                                            : MyImages.gameImg,
                                    gameid: teamEventList[index].eventId,
                                     role: _userRole,
                                    dateformat: dateformat,
                                    teamEventList: teamEventList[index],
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
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
