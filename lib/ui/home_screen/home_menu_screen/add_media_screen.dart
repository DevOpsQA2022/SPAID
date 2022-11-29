import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/add_player_response/add_player_response.dart';
import 'package:spaid/model/response/base_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
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

class AddMediaScreen extends StatefulWidget {
  int type;
  AddMediaScreen(this.type);

  @override
  _AddMediaScreenState createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends BaseState<AddMediaScreen> {
  //region Private Members
  final _formKey = GlobalKey<FormState>();
  AddVideoProvider? _addvideoProvider;
  VideoPlayerController? _controller;
  List<int>? imageBytes;
  ChewieController? chewieController;
  PlatformFile? file;
  double? progress;
  BuildContext? popupContext;
  bool isUploading=false;
  FocusNode _node = new FocusNode();
  FocusNode _filenode = new FocusNode();

  //endregion

  @override
  void initState() {
    super.initState();
    _addvideoProvider = Provider.of<AddVideoProvider>(context, listen: false);
    _addvideoProvider!.initialProvider();
    _addvideoProvider!.listener = this;
  }

  @override
  void onSuccess(any, {int? reqId}) {
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
      type: FileType.custom,
      allowCompression: true,
       allowedExtensions: widget.type==Constants.images?['jpg', 'jpeg', 'png']:widget.type==Constants.videos?['mp4','mov','mkv','avi']:['xlsx','pdf','doc','docx','ppt'],
    );

    if (result != null) {
      isUploading=false;
      //print(result.files);
      file = result.files.first;

      print(file!.name);
      //print(file.bytes);
      print(file!.size);
      print(file!.extension);
      print(file!.path);
        if (kIsWeb) {

          if(widget.type==Constants.images){
            if(['jpg', 'jpeg', 'png'].contains(file!.extension)){
              _addvideoProvider!.videoPath!.text = file!.name;
              imageBytes = file!.bytes;
              setState(() {
              });
            }else{
              CodeSnippet.instance.showMsg("Selected file ["+file!.name+"] is not supported for upload.");
            }


          }
          if(widget.type==Constants.files){
if(['xlsx','pdf','doc','docx','ppt'].contains(file!.extension)) {
  _addvideoProvider!.videoPath!.text = file!.name;
  setState(() {});
}else{
  CodeSnippet.instance.showMsg("Selected file ["+file!.name+"] is not supported for upload.");
}
          }
          if(widget.type==Constants.videos) {
            //File.fromRawPath(file.bytes);
            if(['mp4','mov','mkv','avi'].contains(file!.extension)) {
              _addvideoProvider!.videoPath!.text = file!.name;
              final blob = html.Blob(file!.bytes, "video", file!.extension);
              print(blob);
              final url = html.Url.createObjectUrlFromBlob(blob);
              print(url);
              initPlayer(url);

              // _controller = VideoPlayerController.network(url)
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
              CodeSnippet.instance.showMsg("Selected file ["+file!.name+"] is not supported for upload.");
            }
          }
        } else {
          if(widget.type==Constants.images){
            if(['jpg', 'jpeg', 'png'].contains(file!.extension)){
              _addvideoProvider!.videoPath!.text = file!.path;
              File imageFile = File(file!.path);
            imageBytes = await testCompressFile(imageFile);
            setState(() {
            });
            }else{
              CodeSnippet.instance.showMsg("Selected file ["+file!.name+"] is not supported for upload.");
            }
          }
          if(widget.type==Constants.files){
            if(['xlsx','pdf','doc','docx','ppt'].contains(file!.extension)) {
              _addvideoProvider!.videoPath!.text = file!.path;
              setState(() {
            });
            }else{
              CodeSnippet.instance.showMsg("Selected file ["+file!.name+"] is not supported for upload.");
            }
          }

          if(widget.type==Constants.videos) {
            if(['mp4','mov','mkv','avi'].contains(file!.extension)) {
              _addvideoProvider!.videoPath!.text = file!.path;
              File videofile = new File(file!.path);
              initPlayerFile(videofile);

            //   _controller = VideoPlayerController.file(videofile)
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
              CodeSnippet.instance.showMsg("Selected file ["+file!.name+"] is not supported for upload.");
            }
          }

        }
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
//  compress file and get Uint8List
  Future<Uint8List> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 400,
      minHeight: 400,
      quality: 10,
    );
    print(file.lengthSync());
    print(result!.length);
    return result;
  }
  Future uploadFile(String path, String name, String extension, Uint8List bytes) async {
    isUploading=true;
    //showProgressbar();
    if(kIsWeb){
      FirebaseStorage storage = FirebaseStorage.instance;

      if (widget.type == Constants.images) {
        Reference ref = storage.ref().child('image/' + name);
        UploadTask uploadTask = ref.putData(
            bytes, SettableMetadata(customMetadata: {
          'title': _addvideoProvider!.title!.text,
          'description': _addvideoProvider!.description!.text,
          'extension': extension
        }));
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progress = event.bytesTransferred.toDouble() /
                event.totalBytes.toDouble();
            print(progress);
          });
        }).onError((error) {
          print(error);
          // do something to handle error
        });
        uploadTask.then((res) async {
          res.ref.getDownloadURL();
          print(await res.ref.getDownloadURL());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigation.navigateWithArgument(context, MyRoutes.mediaListScreen, 0);

          // stopProgressBar();
        });
      } else if (widget.type == Constants.videos) {
        Reference ref = storage.ref().child('video/' + name);
        UploadTask uploadTask = ref.putData(
            bytes, SettableMetadata(customMetadata: {
          'title': _addvideoProvider!.title!.text,
          'description': _addvideoProvider!.description!.text,
          'extension': extension
        }));
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progress = event.bytesTransferred.toDouble() /
                event.totalBytes.toDouble();
            print(progress);
          });
        }).onError((error) {
          print(error);
          // do something to handle error
        });
        uploadTask.then((res) async {
          res.ref.getDownloadURL();
          print(await res.ref.getDownloadURL());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigation.navigateWithArgument(context, MyRoutes.mediaListScreen, 1);
          // stopProgressBar();
        });
      } else {
        Reference ref = storage.ref().child('file/' + name);
        UploadTask uploadTask = ref.putData(
            bytes, SettableMetadata(customMetadata: {
          'title': _addvideoProvider!.title!.text,
          'description': _addvideoProvider!.description!.text,
          'extension': extension
        }));
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progress = event.bytesTransferred.toDouble() /
                event.totalBytes.toDouble();
            print(progress);
          });
        }).onError((error) {
          print(error);
          // do something to handle error
        });

        uploadTask.then((res) async {
          res.ref.getDownloadURL();
          print(await res.ref.getDownloadURL());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigation.navigateWithArgument(context, MyRoutes.mediaListScreen, 2);
          // stopProgressBar();
        });
      }
    }else {
      FirebaseStorage storage = FirebaseStorage.instance;

      if (widget.type == Constants.images) {
        Reference ref = storage.ref().child('image/' + name);
        File imagefile = new File(path);
        UploadTask uploadTask = ref.putFile(
            imagefile, SettableMetadata(customMetadata: {
          'title': _addvideoProvider!.title!.text,
          'description': _addvideoProvider!.description!.text,
          'extension': extension
        }));
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progress = event.bytesTransferred.toDouble() /
                event.totalBytes.toDouble();
            print(progress);
          });
        }).onError((error) {
          print(error);
          // do something to handle error
        });
        uploadTask.then((res) async {
          res.ref.getDownloadURL();
          print(await res.ref.getDownloadURL());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigation.navigateWithArgument(context, MyRoutes.mediaListScreen, 0);

          // stopProgressBar();
        });
      } else if (widget.type == Constants.videos) {
        Reference ref = storage.ref().child('video/' + name);
        File imagefile = new File(path);
        UploadTask uploadTask = ref.putFile(
            imagefile, SettableMetadata(customMetadata: {
          'title': _addvideoProvider!.title!.text,
          'description': _addvideoProvider!.description!.text,
          'extension': extension
        }));
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progress = event.bytesTransferred.toDouble() /
                event.totalBytes.toDouble();
            print(progress);
          });
        }).onError((error) {
          print(error);
          // do something to handle error
        });
        uploadTask.then((res) async {
          res.ref.getDownloadURL();
          print(await res.ref.getDownloadURL());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigation.navigateWithArgument(context, MyRoutes.mediaListScreen, 1);
          // stopProgressBar();
        });
      } else {
        Reference ref = storage.ref().child('file/' + name);
        File imagefile = new File(path);
        UploadTask uploadTask = ref.putFile(
            imagefile, SettableMetadata(customMetadata: {
          'title': _addvideoProvider!.title!.text,
          'description': _addvideoProvider!.description!.text,
          'extension': extension
        }));
        /*uploadTask.events.listen((event) {
        setState(() {
          progress = event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble();
          print(progress);
        });
      }).onError((error) {
        print(error);
      });*/
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            progress = event.bytesTransferred.toDouble() /
                event.totalBytes.toDouble();
            print(progress);
          });
        }).onError((error) {
          print(error);
          // do something to handle error
        });

        uploadTask.then((res) async {
          res.ref.getDownloadURL();
          print(await res.ref.getDownloadURL());
          Navigator.pop(context);
          Navigator.pop(context);
          Navigation.navigateWithArgument(context, MyRoutes.mediaListScreen, 2);
          // stopProgressBar();
        });
      }
    }
  }
  void showProgressbar() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        popupContext = context;
        /*if(!_isShowing) {
          Navigator.of(context).pop();
        }*/
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Center(
                child: Material(
                    borderRadius:
                    BorderRadius.all(Radius.circular(Dimens.standard_5)),
                    color: MyColors.white,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.standard_15,
                            vertical: Dimens.standard_15),
                        child: Container(
                          width: Dimens.standard_15,
                          height: Dimens.standard_15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                MyColors.kPrimaryColor),
                            strokeWidth: Dimens.standard_2,
                          ),
                        )))));
      },
    );
  }

  void stopProgressBar() {
    Navigator.of(popupContext!).pop();
  }

/*  Future<List<Map<String, dynamic>>> loadImages() async {
    List<Map<String, dynamic>> files = [];
    FirebaseStorage storage = FirebaseStorage.instance;

    final ListResult result = await storage.ref().list(null);
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
      });
    });

    return files;
  }*/

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TopBar(
      child: Container(
        width: size.width,
        constraints: BoxConstraints(minHeight: size.height - 30),
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
                          title: widget.type == Constants.images?"Add Image":widget.type==Constants.files?"Add File":widget.type==Constants.videos?"Add Video":"",
                          iconRight: MyIcons.done,
                          tooltipMessageRight: MyStrings.save,
                          iconLeft: MyIcons.cancel,
                          tooltipMessageLeft: MyStrings.cancel,
                          onClickRightImage: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Internet.checkInternet().then((value) {
                                if (value) {
                                  if(!isUploading) {
                                    uploadFile(file!.path, file!.name,file!.extension,file!.bytes);
                                  }
                                } else {
                                  CodeSnippet.instance
                                      .showMsg(MyStrings.checkNetwork);
                                }
                              });
                              //Navigation.navigateTo(context, MyRoutes.homeScreen);
                            }
                          }),
                      body: SingleChildScrollView(
                       // physics: NeverScrollableScrollPhysics(),
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
                                                right:
                                                    getValueForScreenType<bool>(
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
                                                      Focus(
                                                        focusNode:
                                                        _node,
                                                        onFocusChange:
                                                            (bool focus) {

                                                        },
                                                        child: Listener(
                                                          onPointerDown:
                                                              (_) {
                                                            FocusScope.of(
                                                                context)
                                                                .requestFocus(
                                                                _node);
                                                          },

                                                          child: CustomizeTextFormField(
                                                            labelText: MyStrings
                                                                    .videotitle +
                                                                "*",
                                                            inputFormatter: [
                                                              new LengthLimitingTextInputFormatter(
                                                                  50),
                                                            ],
                                                            controller:
                                                                provider.title,
                                                            inputAction:
                                                                TextInputAction
                                                                    .next,
                                                            onFieldSubmit: (v){
                                                              FocusScope.of(context).requestFocus(_filenode);
                                                            },
                                                            // suffixImage: MyImages.dropDown,
                                                            isEnabled: true,
                                                            validator: ValidateInput
                                                                .requiredFieldsTitle,
                                                            onSave: (value) {
                                                              provider.title!.text =
                                                                  value!;
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                     /* SizedBox(
                                                        height: SizedBoxSize
                                                            .standardSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .standardSizedBoxWidth,
                                                      ),
                                                      CustomizeTextFormField(
                                                        labelText: MyStrings
                                                                .videodescription,
                                                        inputFormatter: [
                                                          new LengthLimitingTextInputFormatter(
                                                              100),
                                                        ],
                                                        controller: provider
                                                            .description,
                                                        // suffixImage: MyImages.dropDown,
                                                        inputAction:
                                                            TextInputAction
                                                                .next,
                                                        *//*validator: ValidateInput
                                                            .requiredFieldsDescription,*//*
                                                        isEnabled: true,
                                                        onSave: (value) {
                                                          provider.description
                                                              .text = value;
                                                        },
                                                      ),*/
                                                      SizedBox(
                                                        height: SizedBoxSize
                                                            .standardSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .standardSizedBoxWidth,
                                                      ),
                                                      Focus(
                                                        focusNode:
                                                        _node,
                                                        onFocusChange:
                                                            (bool focus) {

                                                        },
                                                        child: Listener(
                                                          onPointerDown:
                                                              (_) {
                                                            FocusScope.of(
                                                                context)
                                                                .requestFocus(
                                                                _node);
                                                          },
                                                          child: CustomizeTextFormField(
                                                            labelText: kIsWeb
                                                                ? MyStrings
                                                                        .videoName +
                                                                    "*"
                                                                : MyStrings
                                                                        .videopath +
                                                                    "*",
                                                            controller:
                                                                provider.videoPath,
                                                            focusNode: _filenode,
                                                            inputFormatter: [new FilteringTextInputFormatter.deny(RegExp("")),],
                                                            suffixIcon: IconButton(
                                                              tooltip: MyStrings
                                                                  .tooltipChoose,
                                                              splashRadius: 1,
                                                              icon: MyIcons
                                                                  .file_add_black,
                                                              onPressed: () {
                                                                selectFileAsync();
                                                              },
                                                            ),
                                                            onClick: (){
                                                              selectFileAsync();

                                                            },
                                                            inputAction:
                                                                TextInputAction
                                                                    .done,
                                                            isLast: true,
                                                            validator: ValidateInput
                                                                .requiredFieldsFile,
                                                            isEnabled:provider.videoPath!.text.isEmpty?true: false,
                                                            onSave: (value) {
                                                              provider.videoPath!
                                                                  .text = value!;
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: SizedBoxSize
                                                            .standardSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .standardSizedBoxWidth,
                                                      ),
                                                      progress != null?Text('Uploading ${(progress! * 100).toStringAsFixed(2)} %'):Container(),

                                                      progress != null?Container(
                                                        margin: EdgeInsets.all(20),
                                                        child: LinearProgressIndicator(
                                                          backgroundColor: Colors.grey,
                                                          color: Colors.green,
                                                          minHeight: 5,
                                                          value: progress,
                                                        ),
                                                      ):Container(),
                                                      SizedBox(
                                                        height: SizedBoxSize
                                                            .standardSizedBoxHeight,
                                                        width: SizedBoxSize
                                                            .standardSizedBoxWidth,
                                                      ),
                                                      file != null && widget.type==Constants.files?Image.asset(file!.extension=="xlsx"?MyImages.excel:file!.extension=="pdf"?MyImages.pdf:file!.extension=="ppt"?MyImages.ppt:file!.extension=="doc"||file!.extension=="docx"?MyImages.word:""):Container(),
                                                      imageBytes != null?Image.memory(Uint8List.fromList(imageBytes!)): Container(),
                                                      _controller != null &&
                                                              _controller!.value
                                                                  .isInitialized
                                                          ? AspectRatio(
                                                              aspectRatio:
                                                                  _controller!
                                                                      .value
                                                                      .aspectRatio,
                                                              child: Chewie(
                                                                  controller:
                                                                      chewieController!),
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
    if( _controller != null) {
      _controller!.dispose();
    }
    if(chewieController != null){
      chewieController!.dispose();

    }
  }
}
