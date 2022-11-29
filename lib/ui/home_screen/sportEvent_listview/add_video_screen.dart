import 'dart:io';


import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/ui/home_screen/sportEvent_listview/add_video_screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/ProgressBar.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';


class AddVideoScreen extends StatefulWidget {
  @override
  _AddVideoScreenState createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends BaseState<AddVideoScreen> {
  //region Private Members
  final _formKey = GlobalKey<FormState>();
  AddVideoProvider? _addvideoProvider;
  VideoPlayerController? _controller;
  ChewieController? chewieController;

  //endregion

  @override
  void initState() {
    super.initState();
    _addvideoProvider = Provider.of<AddVideoProvider>(context, listen: false);
    _addvideoProvider!.initialProvider();
    _addvideoProvider!.listener = this;
  }

  @override
  void onSuccess(any, {required int reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    super.onSuccess(any,reqId: 0);
    switch (reqId) {
      case ResponseIds.ADD_PLAYER_SCREEN:
        AddPlayerResponse _response = any as AddPlayerResponse;
        if (_response.responseResult == Constants.success) {
          Navigation.navigateWithArgument(
              context, MyRoutes.homeScreen, Constants.navigateIdOne);

          // CodeSnippet.instance.showMsg(MyStrings.signUpSuccess);
        } else if (_response.responseResult == Constants.failed) {
          CodeSnippet.instance.showMsg(_response.errorMessage!);
          print("400");
        } else {
          CodeSnippet.instance.showMsg(_response.errorMessage!);
          print("else");
        }
        break;
    }
  }

  @override
  void onFailure(BaseResponse error) {
    ProgressBar.instance.stopProgressBar(context);
    CodeSnippet.instance.showMsg(error.errorMessage!);
  }

  selectFileAsync() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowCompression: true,
      // allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      //print(result.files);
      PlatformFile file = result.files.first;

      print(file.name);
      //print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      setState(() {
        if(kIsWeb){

          _addvideoProvider!.videoPath!.text=file.name;
          //File.fromRawPath(file.bytes);
          final blob = html.Blob(file.bytes,"video",file.extension);
          print(blob);
          final url = html.Url.createObjectUrlFromBlob(blob);
          print(url);
          initPlayer(url);
          // _controller = VideoPlayerController.network(
          //     url)
          //   ..initialize().then((_) {
          //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          //     setState(() {});
          //   });
          // chewieController = ChewieController(
          //   videoPlayerController: _controller,
          //   autoPlay: true,
          //   looping: true,
          // );
        }else{
          _addvideoProvider!.videoPath!.text=file.path;
          File videofile = new File(file.path);
          initPlayerFile(videofile);
          // _controller = VideoPlayerController.file(
          //     videofile)
          //   ..initialize().then((_) {
          //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          //     setState(() {});
          //   });
          // chewieController = ChewieController(
          //   videoPlayerController: _controller,
          //   autoPlay: true,
          //   looping: true,
          // );
        }
      });

    } else {
      // User canceled the picker
    }
  }
  Future<void> initPlayerFile(File videofile) async {
    try {
      VideoPlayerController _oldCon = _controller!;
      _oldCon.dispose();
      _controller = null;
      chewieController = null;
    } catch (e) {

    }
    Future.delayed(Duration(milliseconds: 500));
    _controller =new VideoPlayerController.file(
        videofile,videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    await _controller!.initialize();
    chewieController =new ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: true,
    );
    setState(() {

    });
  }
  Future<void> initPlayer(String url) async {
    try {
      VideoPlayerController _oldCon = _controller!;
      _oldCon.dispose();
      _controller = null;
      chewieController = null;
    } catch (e) {

    }
    Future.delayed(Duration(milliseconds: 500));
    _controller =new VideoPlayerController.network(
        url,videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
    await _controller!.initialize();
    chewieController =new ChewieController(
      videoPlayerController: _controller!,
      autoPlay: true,
      looping: true,
    );
    setState(() {

    });
  }
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TopBar(
      child: Container(
        width: size.width,
        constraints: BoxConstraints(minHeight: size.height -30),
        child: Container(
          /*margin: EdgeInsets.symmetric(
              vertical: MarginSize.headerMarginVertical1,
              horizontal: MarginSize.headerMarginVertical1),*/
          child: Row(
            children: <Widget>[
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
                      appBar: CustomAppBar(
                        title: MyStrings.addVideo,
                        iconRight: MyIcons.done,tooltipMessageRight: MyStrings.save,
                        iconLeft: MyIcons.cancel, tooltipMessageLeft: MyStrings.cancel,
                        onClickRightImage: () {
                          //Navigation.navigateTo(context, MyRoutes.homeScreen);
                        },
                      ),
                      body: SingleChildScrollView(
                        child: Consumer<AddVideoProvider>(
                            builder: (context, provider, _) {
                          return Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SafeArea(
                              child: Container(
                                width: size.width,
                                constraints:
                                    BoxConstraints(minHeight: size.height),
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                 // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,
                                      )
                                          ? null
                                          : EdgeInsets.symmetric(
                                              vertical: MarginSize
                                                  .headerMarginVertical1,
                                              horizontal: MarginSize
                                                  .headerMarginHorizontal1),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.only(
                                                right: getValueForScreenType<
                                                        bool>(
                                              context: context,
                                              mobile: false,
                                              tablet: true,
                                              desktop: true,
                                            )
                                                    ? PaddingSize
                                                        .headerPadding2
                                                    : PaddingSize
                                                        .headerPadding2),
                                            child: Column(
                                              /*mainAxisAlignment: !isMobile(context)
                                              ? MainAxisAlignment.start
                                              : MainAxisAlignment.center,
                                          crossAxisAlignment: !isMobile(context)
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.center,*/
                                              children: <Widget>[
                                                // if (isMobile(context))
                                                Padding(
                                                  padding: EdgeInsets.all(
                                                      getValueForScreenType<
                                                              bool>(
                                                    context: context,
                                                    mobile: false,
                                                    tablet: true,
                                                    desktop: true,
                                                  )
                                                          ? PaddingSize
                                                              .headerPadding1
                                                          : PaddingSize
                                                              .headerPadding2),
                                                  child: Column(
                                                    children: [
                                                      // SizedBox(
                                                      //   height: SizedBoxSize
                                                      //       .standardSizedBoxHeight,
                                                      //   width: SizedBoxSize
                                                      //       .standardSizedBoxWidth,
                                                      // ),
                                                      CustomizeTextFormField(
                                                        labelText: MyStrings
                                                            .videotitle,
                                                        inputFormatter: [new LengthLimitingTextInputFormatter(50),],
                                                        controller:
                                                            provider.title,
                                                        inputAction:
                                                            TextInputAction
                                                                .next,
                                                        // suffixImage: MyImages.dropDown,
                                                        isEnabled: true,
                                                        validator: ValidateInput
                                                            .requiredFieldsFirstName,
                                                        onSave: (value) {
                                                          provider.title!
                                                              .text = value!;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: SizedBoxSize
                                                            .standardSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .standardSizedBoxWidth,
                                                      ),
                                                      CustomizeTextFormField(
                                                        labelText: MyStrings
                                                            .videodescription,
                                                        inputFormatter: [new LengthLimitingTextInputFormatter(100),],
                                                        controller: provider
                                                            .description,
                                                        // suffixImage: MyImages.dropDown,
                                                        inputAction:
                                                            TextInputAction
                                                                .next,
                                                        validator: ValidateInput
                                                            .requiredFieldsLastName,
                                                        isEnabled: true,
                                                        onSave: (value) {
                                                          provider.description!
                                                              .text = value!;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: SizedBoxSize
                                                            .standardSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .standardSizedBoxWidth,
                                                      ),
                                                      CustomizeTextFormField(
                                                        labelText:kIsWeb?MyStrings.videoName: MyStrings
                                                            .videopath,
                                                        controller: provider
                                                            .videoPath,

                                                        suffixIcon:IconButton(
                                                          tooltip: MyStrings.tooltipChoose,
                                                          splashRadius: 1,
                                                          icon:MyIcons.file_add,
                                                          onPressed: () {
                                                            selectFileAsync();
                                                          },
                                                        ),
                                                        inputAction:
                                                            TextInputAction
                                                                .next,
                                                        validator: ValidateInput
                                                            .requiredFieldsLastName,
                                                        isEnabled: true,
                                                        onSave: (value) {
                                                          provider.videoPath!
                                                              .text = value!;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: SizedBoxSize
                                                            .standardSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .standardSizedBoxWidth,
                                                      ),
                                                      _controller != null && _controller!.value.isInitialized
                                                          ? AspectRatio(
                                                        aspectRatio: _controller!.value.aspectRatio,
                                                        child: Chewie(controller: chewieController!),
                                                      )
                                                          : Container(),
                                                    ],
                                                  ),
                                                )
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
                          );
                        }),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
    chewieController!.dispose();
  }
}
