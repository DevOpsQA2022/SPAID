import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/model/response/game_event_response/volunteer_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/add_event_screen/volunteer_screen/volunteer_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/menu_screen_card.dart';

class RemoveVolunteerScreen extends StatefulWidget {
  @override
  _RemoveVolunteerScreenState createState() => _RemoveVolunteerScreenState();
}

class _RemoveVolunteerScreenState extends BaseState<RemoveVolunteerScreen> {
  //region Private Members
  VolunteerProvider? _volunteerProvider;
  VolunteerResponse? _volunteerResponse;
  String? userID;
  bool? isLoading;

//endregion

  @override
  void initState() {
    super.initState();

    _volunteerProvider = Provider.of<VolunteerProvider>(context, listen: false);
    _volunteerProvider?.listener = this;
    _volunteerProvider?.getVolunteerAsync();
    _getDataAsync();
    isLoading = true;
  }

  _getDataAsync() async {
    try {
      userID =
          await SharedPrefManager.instance.getStringAsync(Constants.userIdNo);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onSuccess(any, {required int reqId}) {
    isLoading = false;
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.GET_VOLUNTEER:
        setState(() {
          _volunteerResponse = any as VolunteerResponse;
          /* for (int i = 0; i < _volunteerResponse.voluenteerList.length-1; i++) {
            print("Marlen2");
            _namecontroller.add(TextEditingController());
            _nameIDcontroller.add(TextEditingController());
            List<TextEditingController> name=[];
            _volunteerPlayernamecontroller.add(name);
            _namecontroller[i].text = _volunteerResponse.voluenteerList[i].voluenteerTypeName;
            _nameIDcontroller[i].text = _volunteerResponse.voluenteerList[i].voluenteerTypeId.toString();
            _checckboxcontroller.add(TextEditingController());
            _checckboxcontroller[i].text = "false";
          }*/
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

  @override
  Widget build(BuildContext context) {
    final double screenHeights = MediaQuery.of(context).size.height - 150;
    return TopBar(
      child: WebCard(
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
          child: Scaffold(
            backgroundColor: MyColors.white,
            appBar: CustomAppBar(
              title: MyStrings.removevolunteer,
              // iconRight: MyIcons.done,
              iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
             // tooltipMessageRight: MyStrings.save,

            ),
            body: SizedBox(
              height: getValueForScreenType<bool>(
                context: context,
                mobile: true,
                tablet: false,
                desktop: false,
              )
                  ? screenHeights
                  : null,
              child: SafeArea(
                child: isLoading!
                    ? SkeletonListView()
                    : _volunteerResponse == null ||
                            _volunteerResponse!.result!.voluenteerList!.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: EmptyWidget(
                              image: null,
                              packageImage: PackageImage.Image_3,
                              title: 'No Volunteer',
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
                        : SingleChildScrollView(
                            child: Column(
                              // mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _volunteerResponse == null ||
                                          _volunteerResponse!.result!.voluenteerList ==
                                              null
                                      ? 0
                                      : _volunteerResponse!.result!.voluenteerList!.length -
                                          1,
                                  // itemCount: response.length != null?response.length:0,
                                  itemBuilder: (context, index) {
                                    return Slidable(
                                      key: Key(_volunteerResponse!
                                          .result!.voluenteerList![index]
                                          .voluenteerTypeName!),

                                      endActionPane: ActionPane(
                                        motion: ScrollMotion(),
                                        children: [
                                          SlidableAction(
                                            //onPressed:removeNotification(context,_notificationResponse.userNotificationList[index].notificationId),
                                            onPressed: (context) {
                                              //_notificationProvider.removeNotificationAsync(_notificationResponse.userNotificationList[index].notificationId);
                                            },
                                            backgroundColor: Color(0xFFFE4A49),
                                            foregroundColor: Colors.white,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),

                                      // The child of the Slidable is what the user sees when the
                                      // component is not dragged.
                                      child: MenuScreenCard(
                                        title: _volunteerResponse!
                                            .result!.voluenteerList![index]
                                            .voluenteerTypeName,
                                        //icon: Icon(Icons.settings,color: MyColors.black,),
                                        color: MyColors.kPrimaryColor,
                                        onPressed: () {
                                          // Navigation.navigateTo(context, MyRoutes.NotificationPreferencesScreen);
                                        },
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
        ),
      ),
    );
  }
}
