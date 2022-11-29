
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/player_contact_card.dart';
import 'package:spaid/widgets/video_screen_card.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PlayerContactListScreen extends StatefulWidget {
  PlatformFile file;
  PlayerContactListScreen( this.file);

  @override
  _PlayerContactListScreenState createState() => _PlayerContactListScreenState();
}

class _PlayerContactListScreenState extends State<PlayerContactListScreen> {

  ScrollController _scrollController=ScrollController();
  @override
  void initState() {
    //https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4

   /* for (var table in widget.e+zxcel.tables.keys) {
      print(table); //sheet Name
      print(widget.excel.tables[table].maxCols);
      print(widget.excel.tables[table].maxRows);
      for (var row in widget.excel.tables[table].rows) {
        print("$row");
        print(row[0].toString());
        print(row[1].toString());
        print(row[2].toString());
        print(row[3].toString());
      }
    }*/
  }

  Widget? showPlayerContactList() {
    var excel = Excel.decodeBytes(widget.file.bytes);
   /* var file1 = widget.file.path;
    var bytes = File(file1).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);*/
    for (var table in excel.tables.keys) {
      return ListView.builder(
          itemCount: excel.tables[table]!.maxRows-1,
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            //return AddFamilyListCard(index,_firstnamecontroller[index]);
            return PlayerContactCard(
              title: excel.tables[table]!.rows[index+1][1],
              onPressed: () {
                Navigation.navigateWithArgument(
                    context,
                    MyRoutes.addPlayerScreen,
                    excel.tables[table]!.rows[index+1]);
              },
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
                        )
          ? null
          : CustomAppBar(
              title: MyStrings.contactList,
              iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
              onClickLeftImage: () {
                Navigator.of(context).pop();
              },
            ),
      body: TopBar(
        child: SafeArea(
          child: Row(
            children: [
               if (getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          tablet: true,
                          desktop: true,
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
                  child: Container(
                    width: size.width,
                    constraints: BoxConstraints(minHeight: size.height -30),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            /*margin: EdgeInsets.symmetric(
                                vertical: MarginSize.headerMarginVertical3,
                                horizontal: MarginSize.headerMarginVertical3),*/
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Column(
                                      mainAxisAlignment: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: true,
                                          desktop: true,)
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.center,
                                      crossAxisAlignment: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: true,
                                          desktop: true,)
                                          ? CrossAxisAlignment.start
                                          : CrossAxisAlignment.center,
                                      children: <Widget>[
                                         if (getValueForScreenType<bool>(
                            context: context,
                            mobile: false,
                            tablet: true,
                            desktop: true,
                          ))
                                          CustomAppBar(
                                          title: MyStrings.contactList,
                                          iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
                                          onClickLeftImage: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        Padding(
                                            padding: EdgeInsets.all(getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: true,
                                          desktop: true,)
                                                ? PaddingSize.headerPadding1
                                                : PaddingSize.headerPadding2),child: showPlayerContactList()),

                                      ],
                                    )),
                              ],
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
        ),
      ),
    );
  }
}
