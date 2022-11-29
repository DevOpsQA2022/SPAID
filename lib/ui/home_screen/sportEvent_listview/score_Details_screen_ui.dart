import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/model/response/game_event_response/score_details_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/home_screen/event_listview/event_listview_provider.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/score_listview_ui_screen.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_score_tabbar.dart';

class ScoreDetailsScreen extends StatefulWidget {
  @override
  _ScoreDetailsScreenState createState() => _ScoreDetailsScreenState();
}

class _ScoreDetailsScreenState extends State<ScoreDetailsScreen>
    with SingleTickerProviderStateMixin {
  //region Private Members
  TabController? _tabController;
  int _selectedTab = 0;
  bool isEdit = false;
  EventListviewProvider? _eventListviewProvider;
  List<ScoreList> teamAScore=[];
  List<ScoreList> teamBScore=[];

//endregion
  @override
  void initState() {
    _eventListviewProvider =
        Provider.of<EventListviewProvider>(context, listen: false);
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    if (_eventListviewProvider!.scoreResponse!.result!.scoreList!.isNotEmpty) {
      setState(() {
        for (int i = 0; i < _eventListviewProvider!.scoreResponse!.result!.scoreList!.length; i++) {
          if (_eventListviewProvider!.scoreResponse!.result!.scoreList![i].teamId == Constants.teamAId) {
            teamAScore.add(_eventListviewProvider!.scoreResponse!.result!.scoreList![i]);
          }
          if (_eventListviewProvider!.scoreResponse!.result!.scoreList![i].teamId == Constants.teamBId) {
            teamBScore.add(_eventListviewProvider!.scoreResponse!.result!.scoreList![i]);

          }
        }
      });
    }

    _tabController!.addListener(() {
      if (_tabController!.indexIsChanging) {
        setState(() {
          _selectedTab = _tabController!.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TopBar(
      child: Row(
        children: [
           if (getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: false,
                          desktop: false,
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
                appBar: AppBar(
                  leading: IconButton(
                    iconSize: ImageSize.standardIconSize,
                    icon: Icon(
                      Icons.arrow_back,
                      color: MyColors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  centerTitle: true,
                  title: Text(MyStrings.iceHockey),
                  bottom: PreferredSize(
                    preferredSize: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * .1),
                    child: Column(
                      children: <Widget>[
                        Material(
                          color: MyColors.kPrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                PaddingSize.headerMaxPadding,
                                PaddingSize.headerPadding2,
                                PaddingSize.headerMaxPadding,
                                PaddingSize.headerPadding2),
                            child: CustomScoreTabBar(
                              tabController: _tabController,
                              selectedTab: _selectedTab,
                              firstTabName: Constants.teamAName,
                              secondTabName: Constants.teamBName,
                              teamAImage: Constants.teamAImage,
                              teamBImage: Constants.teamBImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              ScoreListviewScreen(teamAScore),
                              ScoreListviewScreen(teamBScore),
                              // SabhaListEvent(_tabController)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
