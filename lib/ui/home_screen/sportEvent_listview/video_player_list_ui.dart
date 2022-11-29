import 'dart:io';

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
import 'package:spaid/widgets/video_screen_card.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:universal_html/html.dart' as html;

class VideoPlayerListScreen extends StatefulWidget {
  @override
  _VideoPlayerScreenListState createState() => _VideoPlayerScreenListState();
}

class _VideoPlayerScreenListState extends State<VideoPlayerListScreen> {
  @override
  void initState() {
    //https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4
  }

  Future<File> getVideoThumbnail() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    final file = File(fileName!);
    // filePath = file.path;
    return file;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return TopBar(
      child: WebCard(
        marginVertical: 20,
        marginhorizontal: 40,
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar:  CustomAppBar(
                  title: MyStrings.videoList,
                  iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
                  onClickLeftImage: () {
                    Navigator.of(context).pop();
                  },
                ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(getValueForScreenType<bool>(
                                      context: context,
                                      mobile: false,
                                      tablet: true,
                                      desktop: true,)
                  ? PaddingSize.headerPadding1
                  : PaddingSize.headerPadding2),
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

                                VideoScreenCard(
                                  //getVideoThumbnail(),
                                  videoURL: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                                  title: "Test Video",
                                  onPressed: () {
                                    getValueForScreenType<bool>(
                                      context: context,
                                      mobile: false,
                                      tablet: false,
                                      desktop: true,) ?
                                    html.window.open('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',"_blank"):
                                    Navigation.navigateWithArgument(context, MyRoutes.videoPlayerScreen,"https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4");
                                    },
                                ),
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
         /* floatingActionButton: FloatingActionButton(
            tooltip: MyStrings.addVideo,
            onPressed: () => {
              Navigation.navigateTo(context, MyRoutes.addVideoScreen)
            },
            foregroundColor: MyColors.white,
            backgroundColor: MyColors.kPrimaryColor,
            child: MyIcons.add_white
          ),*/
        ),
      ),
    );
  }
}
