import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  String url;
  VideoPlayerScreen(this.url);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  //region Private Members
  VideoPlayerController? _controller;
  ChewieController? chewieController;

//endregion
  @override
  void initState() {
    initPlayer();
    // Future.delayed(Duration.zero, () {
    //   setState(() {
    //     _controller =new VideoPlayerController.network(
    //         widget.url,videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false));
    //     chewieController =new ChewieController(
    //       videoPlayerController: _controller,
    //       autoPlay: true,
    //       looping: true,
    //     );
    //     _controller.initialize();
    //   });
    // });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      child: WebCard(
        marginVertical: 20,
        marginhorizontal: 40,
        child: Scaffold(
          backgroundColor: MyColors.white,
          appBar:  CustomAppBar(
                  title: MyStrings.videos,
                  //iconRight: MyIcons.exitToApp,
                  iconLeft: MyIcons.backwardArrow,tooltipMessageLeft: MyStrings.back,
                ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(PaddingSize.headerPadding1),
                    child: Column(
                      children: [
                        Center(
                          child:_controller != null? _controller!.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child:new Chewie(controller: chewieController!),
                                )
                              : CircularProgressIndicator():CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if( _controller != null) {
      _controller!.dispose();
    }
    if(chewieController != null){
      chewieController!.dispose();

    }
    super.dispose();

  }

  Future<void> initPlayer() async {
    try {
      VideoPlayerController _oldCon = _controller!;
      _oldCon.dispose();
      _controller = null;
      chewieController = null;
    } catch (e) {

    }
    Future.delayed(Duration(milliseconds: 500));
    _controller =new VideoPlayerController.network(
        widget.url,videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    await _controller!.initialize();
    chewieController =new ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: true,
    );
    setState(() {

    });
  }
}
