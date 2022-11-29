import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/custom_widgets/_paint_over_image.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/internet_check.dart';
import 'package:spaid/support/response_ids.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/SelectDrill_Screen/select_drill_screen_provider.dart';
import 'package:spaid/ui/coaches_corner/home_Screen_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/navigation.dart';
import 'package:spaid/widgets/progressBar.dart';

import '../../support/validate_input.dart';
import '../../widgets/customize_text_field.dart';

class CoachesHomeScreen extends StatefulWidget {
  //region Private Members
  // final int tabId;

//endregion
//   CoachesHomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<CoachesHomeScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();
  String imageURl = MyImages.rink1;
  PaintMode paintMode = PaintMode.freeStyleLateralSkating;
  List<String> getDrillList = [];
  int toogle = 0;
  bool status = false;
  bool timePicker = false;
  bool _validate = false;
  double _kPickerSheetHeight = 216.0;
  SelectDrillProvider? _selectDrillProvider;

  final _formKey = GlobalKey<FormState>();
  HomeScreenProvider? _homeScreenProvider;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? drillImage;
  String? _drillchosenValue;


  /*ImagePainter _imagePainter=ImagePainter.asset(

    MyImages.transparant,
    key: GlobalKey<ImagePainterState>(),
    scalable: true,
    initialStrokeWidth: 0.5,
    // textDelegate: DutchTextDelegate(),
    initialColor: Colors.black,
    initialPaintMode: PaintMode.freeStyleDashline,
    onUndo: (image){
      setState(() {
        imageURl=image;
      });
    },
  );*/

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    _homeScreenProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    _selectDrillProvider =
        Provider.of<SelectDrillProvider>(context, listen: false);
    _homeScreenProvider!.initialProvider(context);
    _homeScreenProvider!.getDrill();
    _homeScreenProvider!.listener = this;
    Constant.paintHistory.clear();
    if (Constant.isEditDrill == 0) {
      _homeScreenProvider!.getAllDrill();
    }
// decodeImageData();
// if(kIsWeb){
//   html.window.onBeforeUnload.listen((event) async{
//     print("Marlen Franto");
//     // Navigator.of(context).pop();
//     // Navigator.of(context).pop();
//       Future.delayed(Duration.zero, () {
//         Navigation.finishAndNavigateWithArgument(context, MyRoutes.homeScreen, 0);
//         // Navigator.of(context)
//         //     .push(MaterialPageRoute(builder: (context) => HomeScreen(0)));
//     });
//   });
// }

    Constant.isImageSelected = false;
    Constant.isTextSelected = false;
    Constant.isImageAction = false;
    Constant.isImageShape = "Drill";
    Constant.initalImage = MyImages.cone;
    Constant.initalPuck = MyImages.puck;
    Constant.initalNet = MyImages.leftNet;
    Constant.initalForward = MyImages.forward1;
    Constant.initalDefense = MyImages.defence1;
    Constant.initalPlayer = MyImages.forward;
    Constant.initalPosition = MyImages.center;
    Constant.initalNumber = MyImages.number1;
    Constant.initalColor = Colors.black;
    Constant.initalShape = PaintMode.circle;
    Constant.initalDrill = PaintMode.freeStyleLateralSkating;

    super.initState();
  }

  @override
  void onSuccess(any, {int? reqId}) {
    ProgressBar.instance.stopProgressBar(context);
    switch (reqId) {
      case ResponseIds.GET_DRILL_CATEGORY_SCREEN:
        setState(() {
          if (_homeScreenProvider!.getDrillCategoryResponse != null &&
              _homeScreenProvider!
                      .getDrillCategoryResponse!.result!.drillCategoryList!.length !=
                  null) {
            for (int i = 0;
                i <
                    _homeScreenProvider!
                        .getDrillCategoryResponse!.result!.drillCategoryList!.length;
                i++) {
              {
                print(_homeScreenProvider!
                    .getDrillCategoryResponse!.result!.drillCategoryList![i].description
                    .toString());

                getDrillList.add(_homeScreenProvider!
                    .getDrillCategoryResponse!.result!.drillCategoryList![i].description
                    .toString());
              }
            }
          }
        });

        break;
      case ResponseIds.GET_DRILL_SCREEN:
        setState(() {
          print("Marlen Franto 1");

          if (_homeScreenProvider!.getDrillPlanResponse != null) {
            //   for (int i = 0; i < _homeScreenProvider!.getDrillCategoryResponse!.drillCategoryList!.length; i++) {
            //     {
            //
            //
            //       getDrillList.add(_homeScreenProvider!.getDrillCategoryResponse!.drillCategoryList![i].description.toString());
            //     }
            //   }
            // }
            decodeImageData(_homeScreenProvider!.getDrillPlanResponse!.result!.planImage!);
          }
        });

        break;
    }
    super.onSuccess(any,reqId: 0);
  }

  // @override
  // void onFailure(BaseResponse error) {
  //   setState(() {
  //     isLoading=false;
  //   });
  //   ProgressBar.instance.stopProgressBar(context);
  //   CodeSnippet.instance.showMsg(error!.errorMessage);
  // }

  void _createDrill() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_homeScreenProvider!.categoryDescriptionController!.text.isEmpty) {
        CodeSnippet.instance.showMsg("Select Drill Category");
      } else {
        Internet.checkInternet().then(
          (value) {
            if (value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // ProgressBar.instance.showProgressbar(context);
              });
              _homeScreenProvider!.createDrillAsync(drillImage!);
              if (kIsWeb) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft
                ]);
              } else if (Device.get().isTablet) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeRight,
                  DeviceOrientation.landscapeLeft
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.portraitUp
                ]);
              }
              Constant.isEditDrill = 1;
              Navigation.finishAndNavigateWithArgument(
                  context, MyRoutes.homeScreen, 4);
              _selectDrillProvider!.setRefreshScreen();
            } else {
              CodeSnippet.instance.showMsg("Check Internet");
            }
          },
        );
      }
    }
  }

  void _updateDrill() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_homeScreenProvider!.categoryDescriptionController!.text.isEmpty) {
        CodeSnippet.instance.showMsg("Select Drill Category");
      } else {
        Internet.checkInternet().then((value) {
          if (value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // ProgressBar.instance.showProgressbar(context);
            });
            ProgressBar.instance.showProgressbar(context);

            _homeScreenProvider!.updateDrillAsync(
                context, drillImage!, _selectDrillProvider!);
            if (kIsWeb) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft
              ]);
            } else if (Device.get().isTablet) {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeLeft
              ]);
            } else {
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp
              ]);
            }
            Constant.isEditDrill = 1;
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();

          } else {
            CodeSnippet.instance.showMsg("Check Internet");
          }
        });
      }
    }
  }

  void saveImage() async {
    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath =
        '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File('$fullPath');
    imgFile.writeAsBytesSync(image);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.only(left: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Image Exported successfully.",
                style: TextStyle(color: Colors.white)),
            TextButton(
              onPressed: () => OpenFile.open("$fullPath"),
              child: Text(
                "Open",
                style: TextStyle(
                  color: Colors.blue[200],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getFloatingActionButton(Size size, String imageURl) {
    return Screenshot(
      controller: screenshotController,
      child: Stack(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            top: 58.0,
          ),
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageURl),
                ),
              ),
              // height:  size.height / 1.5,
              child: null),
        ),
        ImagePainter.asset(
          MyImages.transparant,
          key: GlobalKey<ImagePainterState>(),
          scalable: false,
          initialStrokeWidth: 0.5,
          // textDelegate: DutchTextDelegate(),
          initialColor: Constant.initalColor,
          initialPaintMode: Constant.initalDrill,
          screenshotController: screenshotController,
          // colorIcon: Icon(Icons.color_lens),
          onPaintModeChanged: (paintMode) {
            this.paintMode = paintMode;
          },

          onUndo: (image) {
            setState(() {
              this.imageURl = image;
            });
          },
          setRefresh: () {
            setState(() {});
          },
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(onWillPop: () {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => FancyDialog(
                gifPath: MyImages.team,
                okFun: () => {
                  if (kIsWeb)
                    {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft
                      ]),
                    }
                  else if (Device.get().isTablet)
                    {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.landscapeRight,
                        DeviceOrientation.landscapeLeft
                      ]),
                    }
                  else
                    {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitDown,
                        DeviceOrientation.portraitUp
                      ]),
                    },
                  Constant.isEditDrill = 1,
                  Navigation.finishAndNavigateWithArgument(
                      context, MyRoutes.homeScreen, 4),
                },
                cancelFun: () => {Navigator.of(context).pop()},
                cancelColor: MyColors.red,
                title: MyStrings.conformLeaveApp,
              ));
      return Future.value(false);
    }, child: Consumer<HomeScreenProvider>(builder: (context, provider, _) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _key,
        appBar: AppBar(
          backgroundColor: MyColors.kPrimaryColor,
          leading: IconButton(
              iconSize: ImageSize.standardIconSize,
              icon: Icon(
                Icons.arrow_back,
                color: MyColors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) => FancyDialog(
                          gifPath: MyImages.team,
                          okFun: () => {
                            if (kIsWeb)
                              {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft
                                ]),
                              }
                            else if (Device.get().isTablet)
                              {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeRight,
                                  DeviceOrientation.landscapeLeft
                                ]),
                              }
                            else
                              {
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitDown,
                                  DeviceOrientation.portraitUp
                                ]),
                              },
                            Constant.isEditDrill = 1,
                            Navigation.finishAndNavigateWithArgument(
                                context, MyRoutes.homeScreen, 4),
                          },
                          cancelFun: () => {Navigator.of(context).pop()},
                          cancelColor: MyColors.red,
                          title: MyStrings.conformLeaveApp,
                        ));
              }),
          title: Row(
            children: [
              Image.asset(
                MyImages.spaid_logo,
                width: 70,
              ),
              SizedBox(
                width: 10,
              ),
              Text(TextDelegate.coaches),
            ],
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.save_alt),
          //     onPressed: saveImage,
          //   )
          // ],
        ),
        body: Column(
          children: [
            Container(
                height: getValueForScreenType<bool>(
                  context: context,
                  mobile: false,
                  tablet: true,
                  desktop: true,
                )
                    ? Constant.isEditDrill == 0
                        ? size.height / 1.5
                        : size.height / 1.5
                    : size.height / 1.8,
                child: _getFloatingActionButton(size, imageURl)),
            SizedBox(
              height: 40,
            ),
            Container(
              height: size.height / 8,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: "Full rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              // _imagePainter=ImagePainter.asset(
                              //   MyImages.rink1,
                              //   key: _imageKey,
                              //   scalable: true,
                              //   initialStrokeWidth: 2,
                              //   // textDelegate: DutchTextDelegate(),
                              //   initialColor: Colors.black,
                              //   initialPaintMode: PaintMode.arrow,
                              // );
                              // getRefresh(size, MyImages.rink1);
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink1.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              print(Constant.paintHistory);
                              imageURl = MyImages.rink1.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink1,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "1/2 rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink2.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              print(Constant.paintHistory);
                              imageURl = MyImages.rink2.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink2,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "1/4 rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink3.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              imageURl = MyImages.rink3.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink3,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Tooltip(
                      message: "1/3 rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink5.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              imageURl = MyImages.rink5.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink5,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Tooltip(
                      message: "1/6 rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink6.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              imageURl = MyImages.rink6.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink6,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 17,
                    ),
                    Tooltip(
                      message: "Neutral rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink7.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              imageURl = MyImages.rink7.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink7,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    Tooltip(
                      message: "Studio rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink9.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              imageURl = MyImages.rink9.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink9,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 13,
                    ),
                    Tooltip(
                      message: "Goalie crease",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink8.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              imageURl = MyImages.rink8.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink8,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Tooltip(
                      message: "1/2 rink",
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              PaintInfo painInfo = PaintInfo();
                              painInfo.image = imageURl;
                              painInfo.fromImage = MyImages.rink4.toString();
                              painInfo.isImage = true;
                              if (Constant.paintHistory.isEmpty ||
                                  (Constant.paintHistory.last.image == null ||
                                      (Constant.paintHistory.last.image !=
                                              null &&
                                          Constant.paintHistory.last.image!
                                              .isNotEmpty &&
                                          Constant.paintHistory.last.image !=
                                              imageURl))) {
                                Constant.paintHistory.add(painInfo);
                              }
                              Constant.paintHistoryRedo.clear();

                              imageURl = MyImages.rink4.toString();
                            });
                          },
                          child: Image.asset(
                            MyImages.rink4,
                            width: 150,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: SpeedDial(
          foregroundColor: MyColors.white,
          overlayColor: MyColors.colorGray_818181,
          overlayOpacity: 0.5,
          backgroundColor: MyColors.kPrimaryColor,
          children: [
            SpeedDialChild(
                child: new Icon(
                  Icons.save,
                  color: MyColors.white,
                ),
                backgroundColor: MyColors.kPrimaryColor,
                label: Constant.isEditDrill == 0
                    ? MyStrings.saveAs
                    : MyStrings.save,
                onTap: () {
                  screenshotController.capture().then((Uint8List? image) {
                    drillImage = image;
                  });
                  _homeScreenProvider!.categoryDescriptionController =
                      TextEditingController();
                  _homeScreenProvider!.planDescriptionController =
                      TextEditingController();
                  _homeScreenProvider!.planImageController =
                      TextEditingController();
                  _homeScreenProvider!.planNotesController =
                      TextEditingController();
                  _homeScreenProvider!.durationController = '';
                  print(Constant.paintHistory);
                  timePicker = false;
                  var json = jsonEncode(
                      Constant.paintHistory.map((e) => e.toJson()).toList());
                  print(json);
                  bool noData = false;
                  for (int i = 0; i < Constant.paintHistory.length; i++) {
                    if (Constant.paintHistory[i].isImage == null) {
                      noData = true;
                    }
                  }
                  noData || Constant.isEditDrill == 0
                      ? showDialog(
                          context: context,
                          builder: (ctxt) => Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: SingleChildScrollView(
                              child: FancyDialog(
                                appbar: AppBar(
                                    backgroundColor: MyColors.kPrimaryColor,
                                    automaticallyImplyLeading: false,
                                    title: IntrinsicHeight(
                                        child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image.asset(
                                          MyImages.spaid_logo,
                                          width: 60,
                                        ),
                                        VerticalDivider(
                                          color: Colors.grey,
                                          thickness: 2,
                                        ),
                                        Text(Constant.isEditDrill == 0
                                            ? "Save as Drill"
                                            : "Save Drill")
                                      ],
                                    ))),
                                cancelColor: MyColors.red,
                                // gifPath:/* teamAImage.isNotEmpty
                                //                                   ? MemoryImage(base64Decode(
                                //                                       teamAImage))
                                //                                   : */MyImages.team,
                                title: "",
                                cancelFun: () => {Navigator.of(context).pop()},
                                okFun: () {
                                  _createDrill();
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                  // Navigator.of(context).pop();
                                },

                                child: StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text("Default/Custom:",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          FlutterSwitch(
                                            activeText: "Custom",
                                            inactiveText: "Default",
                                            value: status,
                                            valueFontSize: 10.0,
                                            width: 100,
                                            inactiveColor:
                                                MyColors.kPrimaryColor,
                                            activeColor:
                                                MyColors.colorGray_818181,
                                            borderRadius: 30.0,
                                            showOnOff: true,
                                            onToggle: (val) {
                                              setState(() {
                                                status = val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      status == false
                                          ? TextDropdownFormField(
                                              // validator:ValidateInput.requiredFields,
                                              onSaved: (dynamic str) {
                                                setState(() {
                                                  print(provider
                                                      .categoryDescriptionController!
                                                      .text
                                                      .toString());
                                                  provider
                                                      .categoryDescriptionController!
                                                      .text = str;
                                                });
                                              },
                                              // validator: ValidateInput.requiredFields,
                                              errorText: _validate
                                                  ? 'Value Can\'t Be Empty'
                                                  : null,
                                              options: getDrillList,
                                              labelText: "Drill Category",
                                              dropdownHeight: 120,
                                            )
                                          : CustomizeTextFormField(
                                              maxLines: 1,
                                              labelText:
                                                  "Custom Drill Category",
                                              controller: provider
                                                  .categoryDescriptionController,
                                              onSave: (value) {
                                                provider
                                                    .categoryDescriptionController!
                                                    .text = value!;
                                              },
                                              validator:
                                                  ValidateInput.requiredFields,
                                              keyboardType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                              // controller: provider.altemailController,
                                            ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      // ToggleSwitch(
                                      //   minWidth: 90.0,
                                      //   cornerRadius: 20.0,
                                      //
                                      //   activeBgColor: [Colors.green],
                                      //   activeFgColor: Colors.white,
                                      //   inactiveBgColor: Colors.grey,
                                      //   inactiveFgColor: Colors.grey[900],
                                      //   initialLabelIndex: null,
                                      //   doubleTapDisable: true, // re-tap active widget to de-activate
                                      //   totalSwitches: 2,
                                      //   labels: ['Default', 'Optional',],
                                      //
                                      //   onToggle: (index) {
                                      //     setState(() {
                                      //       toogle = index;
                                      //     });
                                      //
                                      //     // print('switched to: $index');
                                      //   },
                                      // ),
                                      // SizedBox(height: 10,),
                                      CustomizeTextFormField(
                                        maxLines: 1,
                                        labelText: "Title",
                                        controller:
                                            provider.planDescriptionController,
                                        keyboardType: TextInputType.text,
                                        inputAction: TextInputAction.next,
                                        inputFormatter: [
                                          new LengthLimitingTextInputFormatter(
                                              50),
                                        ],
                                        onSave: (value) {
                                          provider.planDescriptionController!
                                              .text = value!;
                                        },
                                        validator: ValidateInput.requiredFields,

                                        // controller: provider.altemailController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CustomizeTextFormField(
                                        minLines: 3,
                                        maxLines: 3,
                                        labelText: "Description",
                                        isLast: true,
                                        inputFormatter: [
                                          new LengthLimitingTextInputFormatter(
                                              200),
                                        ],
                                        //minLines: FontSize.textMinLine,
                                        keyboardType: TextInputType.multiline,
                                        inputAction: TextInputAction.newline,
                                        controller:
                                            provider.planNotesController,
                                        onSave: (value) {
                                          provider.planNotesController!.text =
                                              value!;
                                        },
                                        // validator: ValidateInput.requiredFields,
                                        // controller: provider.altemailController,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            PaddingSize.boxPaddingAllSide),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                  PaddingSize
                                                      .boxPaddingAllSide),
                                              child: Text(
                                                MyStrings.duration,
                                                style: TextStyle(
                                                  fontSize:
                                                      FontSize.headerFontSize5,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  provider.durationController
                                                          .isNotEmpty
                                                      ? (provider.durationController)
                                                              .split(':')
                                                              .first +
                                                          " hr " +
                                                          (provider
                                                                  .durationController)
                                                              .split(':')
                                                              .last +
                                                          " min"
                                                      : "",
                                                  style: TextStyle(
                                                    fontSize: FontSize
                                                        .headerFontSize5,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: MyIcons.arrowIos,
                                                  onPressed: () => {
                                                    setState(() {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      timePicker == true
                                                          ? timePicker = false
                                                          : timePicker = true;
                                                    }),

                                                    // showCupertinoModalPopup<void>(
                                                    //   context: context,
                                                    //   builder: (BuildContext context) {
                                                    //     return _buildBottomPicker(
                                                    //       CupertinoTimerPicker(
                                                    //         mode: CupertinoTimerPickerMode
                                                    //             .hm,
                                                    //         onTimerDurationChanged:
                                                    //             (duration) {
                                                    //           setState(() {
                                                    //             provider.durationController =
                                                    //                 duration
                                                    //                     .toString()
                                                    //                     .substring(0, 4);
                                                    //           });
                                                    //         },
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      timePicker == true &&
                                              getValueForScreenType<bool>(
                                                context: context,
                                                mobile: true,
                                                tablet: false,
                                                desktop: false,
                                              )
                                          ? Container(
                                              height: 70,
                                              child: CupertinoTimerPicker(
                                                mode:
                                                    CupertinoTimerPickerMode.hm,
                                                initialTimerDuration:provider.durationController.isNotEmpty?Duration(minutes:(int.parse(provider.durationController.split(":").first)*60+int.parse(provider.durationController.split(":").last))):Duration.zero,
                                                onTimerDurationChanged:
                                                    (duration) {
                                                  setState(() {
                                                    provider.duration =
                                                        duration.inMinutes;
                                                    provider.durationController =
                                                        duration
                                                            .toString()
                                                            .substring(0, 4);
                                                    print(duration
                                                        .toString()
                                                        .substring(0, 4));
                                                  });
                                                },
                                              ),
                                            )
                                          : SizedBox(),

                                      timePicker == true &&
                                              getValueForScreenType<bool>(
                                                context: context,
                                                mobile: false,
                                                tablet: true,
                                                desktop: true,
                                              )
                                          ? MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      alwaysUse24HourFormat:
                                                          true),
                                              child: TimePickerDialog(
                                                //initialTime: TimeOfDay.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0)),
                                                initialTime: TimeOfDay.fromDateTime(DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day,
                                                    provider.durationController
                                                            .isNotEmpty
                                                        ? int.parse((provider
                                                                .durationController)
                                                            .split(':')
                                                            .first)
                                                        : 0,
                                                    provider.durationController
                                                            .isNotEmpty
                                                        ? int.parse((provider
                                                                .durationController)
                                                            .split(':')
                                                            .last)
                                                        : 0)),
                                                initialEntryMode:
                                                    TimePickerEntryMode.input,
                                                onClick: (value) {
                                                  setState(() {
                                                    provider.duration =
                                                        (value.hour * 60) +
                                                            value.minute;
                                                    provider.durationController =
                                                        (value.hour.toString() +
                                                            ":" +
                                                            value.minute
                                                                .toString());
                                                    timePicker = false;
                                                  });
                                                },
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ),
                        )
                      : showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => FancyDialog(
                                gifPath: MyImages.team,
                                okFun: () => {
                                  Navigator.of(context).pop(),
                                },
                                // cancelFun: () => {Navigator.of(context).pop()},
                                // cancelColor: MyColors.red,
                                isCancelShow: false,
                                title: MyStrings.noDrill,
                              ));
                }),
            if (Constant.isEditDrill == 0)
              SpeedDialChild(
                  child: new Icon(
                    Icons.save_outlined,
                    color: MyColors.white,
                  ),
                  backgroundColor: (MyColors.kPrimaryColor),
                  label: MyStrings.save,
                  onTap: () {
                    screenshotController.capture().then((Uint8List? image) {
                      drillImage = image;
                    });
                    timePicker = false;
                    status = true;
                    provider.planDescriptionController!.text =
                        _homeScreenProvider!
                            .getDrillPlanResponse!.result!.planDescription!;
                    provider.planNotesController!.text =
                        _homeScreenProvider!.getDrillPlanResponse!.result!.planNotes!;
                    provider.durationController = durationToString(
                        _homeScreenProvider!.getDrillPlanResponse!.result!.duration!);
                    provider.categoryDescriptionController!.text =
                        _homeScreenProvider!
                            .getDrillPlanResponse!.result!.categoryDescription!;

                    var json = jsonEncode(
                        Constant.paintHistory.map((e) => e.toJson()).toList());
                    print(json);
                    showDialog(
                      context: context,
                      builder: (ctxt) => Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: SingleChildScrollView(
                          child: FancyDialog(
                            appbar: AppBar(
                                backgroundColor: MyColors.kPrimaryColor,
                                automaticallyImplyLeading: false,
                                title: IntrinsicHeight(
                                    child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(
                                      MyImages.spaid_logo,
                                      width: 60,
                                    ),
                                    VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 2,
                                    ),
                                    Text(Constant.isEditDrill == 0
                                        ? "Save Drill"
                                        : "Save as Drill")
                                  ],
                                ))),
                            cancelColor: MyColors.red,
                            // gifPath:/* teamAImage.isNotEmpty
                            //                                   ? MemoryImage(base64Decode(
                            //                                       teamAImage))
                            //                                   : */MyImages.team,
                            title: "",
                            cancelFun: () => {Navigator.of(context).pop()},
                            okFun: () {
                              _updateDrill();
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                            },

                            child: StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Default/Custom:",
                                          style: TextStyle(color: Colors.black)),
                                      FlutterSwitch(
                                        activeText: "Custom",
                                        inactiveText: "Default",
                                        value: status,
                                        valueFontSize: 10.0,
                                        width: 100,
                                        inactiveColor: MyColors.kPrimaryColor,
                                        activeColor: MyColors.colorGray_818181,
                                        borderRadius: 30.0,
                                        showOnOff: true,
                                        onToggle: (val) {
                                          setState(() {
                                            status = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  status == false
                                      ? TextDropdownFormField(
                                          // validator:ValidateInput.requiredFields,
                                          onSaved: (dynamic str) {
                                            setState(() {
                                              print(provider
                                                  .categoryDescriptionController!
                                                  .text
                                                  .toString());
                                              provider
                                                  .categoryDescriptionController!
                                                  .text = str;
                                            });
                                          },
                                          // validator: ValidateInput.requiredFields,
                                          errorText: _validate
                                              ? 'Value Can\'t Be Empty'
                                              : null,
                                          options: getDrillList,
                                          labelText: "Drill Category",
                                          // controller:DropdownEditingController(value: "defence"),

                                          dropdownHeight: 120,
                                        )
                                      : CustomizeTextFormField(
                                          maxLines: 1,
                                          labelText: "Custom Drill Category",
                                          inputAction: TextInputAction.next,
                                          controller: provider
                                              .categoryDescriptionController,
                                          onSave: (value) {
                                            provider
                                                .categoryDescriptionController!
                                                .text = value!;
                                          },
                                          validator:
                                              ValidateInput.requiredFields,
                                          keyboardType: TextInputType.text,
                                          // controller: provider.altemailController,
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomizeTextFormField(
                                    maxLines: 1,
                                    labelText: "Title",
                                    controller:
                                        provider.planDescriptionController,
                                    keyboardType: TextInputType.text,
                                    inputAction: TextInputAction.next,
                                    onSave: (value) {
                                      provider.planDescriptionController!.text =
                                          value!;
                                    },
                                    validator: ValidateInput.requiredFields,
                                    // controller: provider.altemailController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomizeTextFormField(
                                    minLines: 3,
                                    maxLines: 3,
                                    labelText: "Description",
                                    isLast: true,
                                    controller: provider.planNotesController,
                                    inputFormatter: [
                                      new LengthLimitingTextInputFormatter(200),
                                    ],
                                    keyboardType: TextInputType.multiline,
                                    inputAction: TextInputAction.newline,

                                    onSave: (value) {
                                      provider.planNotesController!.text = value!;
                                    },
                                    // validator: ValidateInput.requiredFields,

                                    // controller: provider.altemailController,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        PaddingSize.boxPaddingAllSide),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(
                                              PaddingSize.boxPaddingAllSide),
                                          child: Text(
                                            MyStrings.duration,
                                            style: TextStyle(
                                              fontSize:
                                                  FontSize.headerFontSize5,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              provider.durationController
                                                      .isNotEmpty
                                                  ? (provider.durationController)
                                                          .split(':')
                                                          .first +
                                                      " hr " +
                                                      (provider
                                                              .durationController)
                                                          .split(':')
                                                          .last +
                                                      " min"
                                                  : "",
                                              style: TextStyle(
                                                fontSize:
                                                    FontSize.headerFontSize5,
                                              ),
                                            ),
                                            IconButton(
                                              icon: MyIcons.arrowIos,
                                              onPressed: () => {
                                                setState(() {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          FocusNode());
                                                  timePicker == true
                                                      ? timePicker = false
                                                      : timePicker = true;
                                                }),
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  timePicker == true &&
                                          getValueForScreenType<bool>(
                                            context: context,
                                            mobile: true,
                                            tablet: false,
                                            desktop: false,
                                          )
                                      ? Container(
                                          height: 70,
                                          child: CupertinoTimerPicker(
                                            mode: CupertinoTimerPickerMode.hm,
                                            initialTimerDuration:provider.durationController.isNotEmpty?Duration(minutes:(int.parse(provider.durationController.split(":").first)*60+int.parse(provider.durationController.split(":").last))):Duration.zero,
                                            onTimerDurationChanged: (duration) {
                                              setState(() {
                                                provider.duration =
                                                    duration.inMinutes;
                                                provider.durationController =
                                                    duration
                                                        .toString()
                                                        .substring(0, 4);
                                              });
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                  timePicker == true &&
                                          getValueForScreenType<bool>(
                                            context: context,
                                            mobile: false,
                                            tablet: true,
                                            desktop: true,
                                          )
                                      ? MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                              alwaysUse24HourFormat: true),
                                          child: TimePickerDialog(
                                            //initialTime: TimeOfDay.fromDateTime(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0)),
                                            initialTime: TimeOfDay.fromDateTime(
                                                DateTime(
                                                    DateTime.now().year,
                                                    DateTime.now().month,
                                                    DateTime.now().day,
                                                    provider.durationController
                                                            .isNotEmpty
                                                        ? int.parse((provider
                                                                .durationController)
                                                            .split(':')
                                                            .first)
                                                        : 0,
                                                    provider.durationController
                                                            .isNotEmpty
                                                        ? int.parse((provider
                                                                .durationController)
                                                            .split(':')
                                                            .last)
                                                        : 0)),
                                            initialEntryMode:
                                                TimePickerEntryMode.input,
                                            onClick: (value) {
                                              setState(() {
                                                provider.duration =
                                                    (value.hour * 60) +
                                                        value.minute;
                                                provider.durationController =
                                                    (value.hour.toString() +
                                                        ":" +
                                                        value.minute
                                                            .toString());
                                                timePicker = false;
                                              });
                                            },
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    );
                  }),
          ],
          child: MyIcons.more_vert,
        ),
      );
    }));
  }

  // void _addDrillCategory() {
  //   FocusScope.of(context).requestFocus(FocusNode());
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //     Internet.checkInternet().then((value) async {
  //       if (value) {
  //         WidgetsBinding.instance!.addPostFrameCallback((_) {
  //           ProgressBar.instance.showProgressbar(context);
  //         });
  //         if(widget.id==0) {
  //           _addplayerProvider.AddPlayerAsync(imageBytes,await SharedPrefManager.instance.getStringAsync(Constants.teamAID),await SharedPrefManager.instance.getStringAsync(Constants.eventID1));
  //         }else if(widget.id==1){
  //           _addplayerProvider.AddPlayerAsync(imageBytes,await SharedPrefManager.instance.getStringAsync(Constants.teamBID),await SharedPrefManager.instance.getStringAsync(Constants.eventID2));
  //
  //         }
  //       } else {
  //         CodeSnippet.instance.showMsg("Check Network");
  //       }
  //     });
  //   }
  // }
  void getRefresh(Size size, String image) {
    setState(() {
      _getFloatingActionButton(size, image);
    });
  }

  @override
  void onRefresh(String type) {
    // TODO: implement onRefresh
  }

  Future<void> decodeImageData(String planImage) async {
    Constant.paintHistory.clear();
    var jsonData = jsonDecode(planImage);
    print(jsonData);

    for (int i = 0; i < jsonData.length; i++) {
      PaintInfo painInfo = PaintInfo();
      painInfo.image = jsonData[i]["Image"];
      painInfo.fromImage = jsonData[i]["FromImage"];
      painInfo.isImageSelected = jsonData[i]["IsImageSelected"] == null
          ? false
          : jsonData[i]["IsImageSelected"];
      if (jsonData[i]["IsImageSelected"] != null &&
          jsonData[i]["IsImageSelected"]) {
        String svgString = await DefaultAssetBundle.of(context)
            .loadString(jsonData[i]["Image"]);
        String valueString = jsonData[i]["Color"].split('(0x')[1].split(')')[0];
        int value = int.parse(valueString, radix: 16);
        DrawableRoot svgDrawableRoot;
        if (Color(value) == Colors.black) {
          print(jsonData[i]["Image"]);
          svgDrawableRoot = await svg.fromSvgString(svgString, svgString);
        } else {
          svgDrawableRoot = await svg.fromSvgString(svgString, svgString);
          svgDrawableRoot= svgDrawableRoot.mergeStyle(DrawableStyle(fill: DrawablePaint(PaintingStyle.fill,color:Color(value) ),stroke: DrawablePaint(PaintingStyle.stroke,color:MyColors.white ) ));

          // svgDrawableRoot = svgDrawableRoot.mergeStyle(DrawableStyle(
          //     fill: DrawablePaint(PaintingStyle.fill, color: Color(value))));
        }
        // ui.Picture picture = svgDrawableRoot.toPicture(size: Size(37, 37),colorFilter: ColorFilter.mode(Color(value), BlendMode.clear));
        ui.Picture picture = svgDrawableRoot.toPicture(size: Size(37, 37));

        painInfo.imageData = await picture.toImage(37, 37);
      }
      painInfo.isImage =
          jsonData[i]["IsImage"] == null ? false : jsonData[i]["IsImage"];
      if (jsonData[i]["IsImage"] != null && jsonData[i]["IsImage"]) {
        setState(() {
          imageURl = jsonData[i]["FromImage"];
        });
      }
      painInfo.text = jsonData[i]["Text"];
      painInfo.color = jsonData[i]["Color"];
      painInfo.style = jsonData[i]["Style"];
      if (jsonData[i]["Painter"] != "null") {
        painInfo.strokeWidth = double.parse(jsonData[i]["StrokeWidth"]);
        String valueString = jsonData[i]["Color"]
            .split('(0x')[1]
            .split(')')[0]; // kind of hacky..
        int value = int.parse(valueString, radix: 16);
        painInfo.painter = Paint()
          ..color = Color(value)
          ..strokeWidth = double.parse(jsonData[i]["StrokeWidth"])
          ..style = jsonData[i]["Style"] == PaintingStyle.stroke.toString()
              ? PaintingStyle.stroke
              : PaintingStyle.fill;
      }

      if (jsonData[i]["Mode"] == PaintMode.none.toString()) {
        painInfo.mode = PaintMode.none;
      } else if (jsonData[i]["Mode"] == PaintMode.freeStyle.toString()) {
        painInfo.mode = PaintMode.freeStyle;
      } else if (jsonData[i]["Mode"] == PaintMode.line.toString()) {
        painInfo.mode = PaintMode.line;
      } else if (jsonData[i]["Mode"] == PaintMode.rect.toString()) {
        painInfo.mode = PaintMode.rect;
      } else if (jsonData[i]["Mode"] == PaintMode.text.toString()) {
        painInfo.mode = PaintMode.text;
      } else if (jsonData[i]["Mode"] == PaintMode.arrow.toString()) {
        painInfo.mode = PaintMode.arrow;
      } else if (jsonData[i]["Mode"] == PaintMode.circle.toString()) {
        painInfo.mode = PaintMode.circle;
      }else if (jsonData[i]["Mode"] == PaintMode.circleFill.toString()) {
        painInfo.mode = PaintMode.circleFill;
      }else if (jsonData[i]["Mode"] == PaintMode.rectFill.toString()) {
        painInfo.mode = PaintMode.rectFill;
      } else if (jsonData[i]["Mode"] == PaintMode.dashLine.toString()) {
        painInfo.mode = PaintMode.dashLine;
      } else if (jsonData[i]["Mode"] == PaintMode.dashLineArrow.toString()) {
        painInfo.mode = PaintMode.dashLineArrow;
      } else if (jsonData[i]["Mode"] ==
          PaintMode.dashLineArrowStop.toString()) {
        painInfo.mode = PaintMode.dashLineArrowStop;
      } else if (jsonData[i]["Mode"] == PaintMode.freeStyleArrow.toString()) {
        painInfo.mode = PaintMode.freeStyleArrow;
      } else if (jsonData[i]["Mode"] ==
          PaintMode.freeStyleArrowStop.toString()) {
        painInfo.mode = PaintMode.freeStyleArrowStop;
      } else if (jsonData[i]["Mode"] ==
          PaintMode.freeStyleDashline.toString()) {
        painInfo.mode = PaintMode.freeStyleDashline;
      } else if (jsonData[i]["Mode"] ==
          PaintMode.freeStyleLateralSkating.toString()) {
        painInfo.mode = PaintMode.freeStyleLateralSkating;
      } else if (jsonData[i]["Mode"] ==
          PaintMode.freeStyleLateralSkatingStop.toString()) {
        painInfo.mode = PaintMode.freeStyleLateralSkatingStop;
      } else if (jsonData[i]["Mode"] == PaintMode.freeStyleWave.toString()) {
        painInfo.mode = PaintMode.freeStyleWave;
      } else if (jsonData[i]["Mode"] == PaintMode.skateArrow.toString()) {
        painInfo.mode = PaintMode.skateArrow;
      }
      if (jsonData[i]["Offset"] != null) {
        List<Offset> offset = [];
        for (int j = 0; j < jsonData[i]["Offset"].length; j++) {
          offset.add(
              Offset(jsonData[i]["Offset"][j][0], jsonData[i]["Offset"][j][1]));
        }
        painInfo.offset = offset;
      }
      setState(() {
        Constant.paintHistory.add(painInfo);
      });
    }
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }
}
