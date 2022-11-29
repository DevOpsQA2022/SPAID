import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spaid/custom_widgets/_color_widget.dart';
import 'package:spaid/custom_widgets/_image_painter.dart';
import 'package:spaid/custom_widgets/_mode_widget.dart';
import 'package:spaid/custom_widgets/_range_slider.dart';
import 'package:spaid/custom_widgets/_text_dialog.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/widgets/customize_text_field.dart';
import '_ported_interactive_viewer.dart';


export '_image_painter.dart';

///[ImagePainter] widget.
@immutable
class ImagePainter extends StatefulWidget {
  const ImagePainter._(
      {Key? key,
        this.assetPath,
        this.networkUrl,
        this.byteArray,
        this.file,
        this.height,
        this.width,
        this.placeHolder,
        this.isScalable,
        this.brushIcon,
        this.clearAllIcon,
        this.colorIcon,
        this.undoIcon,
        this.isSignature = false,
        this.controlsAtTop = true,
        this.signatureBackgroundColor,
        this.colors,
        this.initialPaintMode,
        this.initialStrokeWidth,
        this.initialColor,
        this.onColorChanged,
        this.onStrokeWidthChanged,
        this.onPaintModeChanged,
        this.onUndo,
        this.setRefresh,
        this.screenshotController,
        this.textDelegate})
      : super(key: key);

  ///Constructor for loading image from network url.
  factory ImagePainter.network(
      String url, {
         Key? key,
        double? height,
        double? width,
        Widget? placeholderWidget,
        bool? scalable,
        List<Color>? colors,
        Widget? brushIcon,
        Widget? undoIcon,
        Widget? clearAllIcon,
        Widget? colorIcon,
        PaintMode? initialPaintMode,
        double? initialStrokeWidth,
        Color? initialColor,
        ValueChanged<PaintMode>? onPaintModeChanged,
        ValueChanged<Color>? onColorChanged,
        ValueChanged<double>? onStrokeWidthChanged,
        TextDelegate? textDelegate,
      }) {
    return ImagePainter._(
      key: key,
      networkUrl: url,
      height: height,
      width: width,
      placeHolder: placeholderWidget,
      isScalable: scalable,
      colors: colors,
      brushIcon: brushIcon,
      undoIcon: undoIcon,
      colorIcon: colorIcon,
      clearAllIcon: clearAllIcon,
      initialPaintMode: initialPaintMode,
      initialColor: initialColor,
      initialStrokeWidth: initialStrokeWidth,
      onPaintModeChanged: onPaintModeChanged,
      onColorChanged: onColorChanged,
      onStrokeWidthChanged: onStrokeWidthChanged,
      textDelegate: textDelegate,
    );
  }

  ///Constructor for loading image from assetPath.
  factory ImagePainter.asset(
      String path, {
         Key? key,
        double? height,
        double? width,
        bool? scalable,
        Widget? placeholderWidget,
        List<Color>? colors,
        Widget? brushIcon,
        Widget? undoIcon,
        Widget? clearAllIcon,
        Widget? colorIcon,
        PaintMode? initialPaintMode,
        double? initialStrokeWidth,
        Color? initialColor,
        ValueChanged<PaintMode>? onPaintModeChanged,
        ValueChanged<Color>? onColorChanged,
        ValueChanged<double>? onStrokeWidthChanged,
        Function(String)? onUndo,
        Function()? setRefresh,
        TextDelegate? textDelegate,
        ScreenshotController? screenshotController,
      }) {
    return ImagePainter._(
      key: key,
      assetPath: path,
      height: height,
      width: width,
      isScalable: scalable ?? false,
      placeHolder: placeholderWidget,
      colors: colors,
      brushIcon: brushIcon,
      undoIcon: undoIcon,
      colorIcon: colorIcon,
      clearAllIcon: clearAllIcon,
      initialPaintMode: initialPaintMode,
      initialColor: initialColor,
      initialStrokeWidth: initialStrokeWidth,
      onPaintModeChanged: onPaintModeChanged,
      onColorChanged: onColorChanged,
      onStrokeWidthChanged: onStrokeWidthChanged,
      textDelegate: textDelegate,
      onUndo: onUndo,
      setRefresh: setRefresh,
      screenshotController: screenshotController,
    );
  }

  ///Constructor for loading image from [File].
  factory ImagePainter.file(
      File file, {
         Key? key,
        double? height,
        double? width,
        bool? scalable,
        Widget? placeholderWidget,
        List<Color>? colors,
        Widget? brushIcon,
        Widget? undoIcon,
        Widget? clearAllIcon,
        Widget? colorIcon,
        PaintMode? initialPaintMode,
        double? initialStrokeWidth,
        Color? initialColor,
        ValueChanged<PaintMode>? onPaintModeChanged,
        ValueChanged<Color>? onColorChanged,
        ValueChanged<double>? onStrokeWidthChanged,
        TextDelegate? textDelegate,
      }) {
    return ImagePainter._(
      key: key,
      file: file,
      height: height,
      width: width,
      placeHolder: placeholderWidget,
      colors: colors,
      isScalable: scalable ?? false,
      brushIcon: brushIcon,
      undoIcon: undoIcon,
      colorIcon: colorIcon,
      clearAllIcon: clearAllIcon,
      initialPaintMode: initialPaintMode,
      initialColor: initialColor,
      initialStrokeWidth: initialStrokeWidth,
      onPaintModeChanged: onPaintModeChanged,
      onColorChanged: onColorChanged,
      onStrokeWidthChanged: onStrokeWidthChanged,
      textDelegate: textDelegate,
    );
  }

  ///Constructor for loading image from memory.
  factory ImagePainter.memory(
      Uint8List byteArray, {
         Key? key,
        double? height,
        double? width,
        bool? scalable,
        Widget? placeholderWidget,
        List<Color>? colors,
        Widget? brushIcon,
        Widget? undoIcon,
        Widget? clearAllIcon,
        Widget? colorIcon,
        PaintMode? initialPaintMode,
        double? initialStrokeWidth,
        Color? initialColor,
        ValueChanged<PaintMode>? onPaintModeChanged,
        ValueChanged<Color>? onColorChanged,
        ValueChanged<double>? onStrokeWidthChanged,
        TextDelegate? textDelegate,
      }) {
    return ImagePainter._(
      key: key,
      byteArray: byteArray,
      height: height,
      width: width,
      placeHolder: placeholderWidget,
      isScalable: scalable ?? false,
      colors: colors,
      brushIcon: brushIcon,
      undoIcon: undoIcon,
      colorIcon: colorIcon,
      clearAllIcon: clearAllIcon,
      initialPaintMode: initialPaintMode,
      initialColor: initialColor,
      initialStrokeWidth: initialStrokeWidth,
      onPaintModeChanged: onPaintModeChanged,
      onColorChanged: onColorChanged,
      onStrokeWidthChanged: onStrokeWidthChanged,
      textDelegate: textDelegate,
    );
  }

  ///Constructor for signature painting.
  factory ImagePainter.signature({
     Key? key,
    Color? signatureBgColor,
    double? height,
    double? width,
    List<Color>? colors,
    Widget? brushIcon,
    Widget? undoIcon,
    Widget? clearAllIcon,
    Widget? colorIcon,
    ValueChanged<PaintMode>? onPaintModeChanged,
    ValueChanged<Color>? onColorChanged,
    ValueChanged<double>? onStrokeWidthChanged,
    TextDelegate? textDelegate,
  }) {
    return ImagePainter._(
      key: key,
      height: height,
      width: width,
      isSignature: true,
      isScalable: false,
      colors: colors,
      signatureBackgroundColor: signatureBgColor ?? Colors.white,
      brushIcon: brushIcon,
      undoIcon: undoIcon,
      colorIcon: colorIcon,
      clearAllIcon: clearAllIcon,
      onPaintModeChanged: onPaintModeChanged,
      onColorChanged: onColorChanged,
      onStrokeWidthChanged: onStrokeWidthChanged,
      textDelegate: textDelegate,
    );
  }

  ///Only accessible through [ImagePainter.network] constructor.
  final String? networkUrl;

  ///Only accessible through [ImagePainter.memory] constructor.
  final Uint8List? byteArray;

  ///Only accessible through [ImagePainter.file] constructor.
  final File? file;

  ///Only accessible through [ImagePainter.asset] constructor.
  final String? assetPath;

  ///Height of the Widget. Image is subjected to fit within the given height.
  final double? height;

  ///Width of the widget. Image is subjected to fit within the given width.
  final double? width;

  ///Widget to be shown during the conversion of provided image to [ui.Image].
  final Widget? placeHolder;

  ///Defines whether the widget should be scaled or not. Defaults to [false].
  final bool? isScalable;

  ///Flag to determine signature or image;
  final bool? isSignature;

  ///Signature mode background color
  final Color? signatureBackgroundColor;

  ///List of colors for color selection
  ///If not provided, default colors are used.
  final List<Color>? colors;

  ///Icon Widget of strokeWidth.
  final Widget? brushIcon;

  ///Widget of Color Icon in control bar.
  final Widget? colorIcon;

  ///Widget for Undo last action on control bar.
  final Widget? undoIcon;

  ///Widget for clearing all actions on control bar.
  final Widget? clearAllIcon;

  ///Define where the controls is located.
  ///`true` represents top.
  final bool? controlsAtTop;

  ///Initial PaintMode.
  final PaintMode? initialPaintMode;

  //the initial stroke width
  final double? initialStrokeWidth;

  //the initial color
  final Color? initialColor;

  final ValueChanged<Color>? onColorChanged;

  final ValueChanged<double>? onStrokeWidthChanged;

  final ValueChanged<PaintMode>? onPaintModeChanged;


  final Function(String)? onUndo;
  final Function()? setRefresh;
  final ScreenshotController? screenshotController;

  //the text delegate
  final TextDelegate? textDelegate;

  @override
  ImagePainterState createState() => ImagePainterState();
}

///
class ImagePainterState extends State<ImagePainter> {
  final _repaintKey = GlobalKey();
  ui.Image? _image;
  bool _inDrag = false;
  final _formKey = GlobalKey<FormState>();

  // final _paintHistory = <PaintInfo>[];
  // final _paintHistoryRedo = <PaintInfo>[];
  final _paintPuck = <ImagesInfo>[];
  final _paintImages = <ImagesInfo>[];
  final _paintNet = <ImagesInfo>[];
  final _paintForward = <ImagesInfo>[];
  final _paintDefence = <ImagesInfo>[];
  final _paintPlayer = <ImagesInfo>[];
  final _paintPosition = <ImagesInfo>[];
  final _paintNumber = <ImagesInfo>[];
  final _paintActionIcon = <ImagesInfo>[];
  final _paintActionShapes = <ModeData>[];

  final _points = <Offset>[];
   ValueNotifier<Controller>? _controller;
   ValueNotifier<Controller>? _controllers;

   ValueNotifier<bool>? _isLoaded;
    TextEditingController? _textController;
  Offset? _start, _end;
  int _strokeMultiplier = 1;
   TextDelegate? textDelegate;
  String svgString = "";
  String svgImagePath = "";
  @override
  void initState() {
    super.initState();
    _isLoaded = ValueNotifier<bool>(false);
    _resolveAndConvertImage();
    ImagesInfo imagesInfo = ImagesInfo(image: MyImages.cone, name: "Cone");
    _paintImages.add(imagesInfo);
    ImagesInfo imagesInfo1 = ImagesInfo(image: MyImages.tire, name: 'Tire');
    _paintImages.add(imagesInfo1);
    ImagesInfo imagesInfo2 = ImagesInfo(image: MyImages.stick, name: 'Stick');
    _paintImages.add(imagesInfo2);
    ImagesInfo imagesInfo3 =
    ImagesInfo(image: MyImages.stickHandling, name: 'Stickhandling');
    _paintImages.add(imagesInfo3);
    ImagesInfo imagesInfo4 =
    ImagesInfo(image: MyImages.triangle, name: 'Triangle');
    _paintImages.add(imagesInfo4);
    ImagesInfo imagesInfo5 =
    ImagesInfo(image: MyImages.borderVertical, name: 'Border vertical');
    _paintImages.add(imagesInfo5);
    ImagesInfo imagesInfo6 = ImagesInfo(
        image: MyImages.borderHorizontal, name: 'Border horizontal');
    _paintImages.add(imagesInfo6);


    ImagesInfo imagesInfo8 = ImagesInfo(image: MyImages.netUp, name: 'Net up');
    _paintNet.add(imagesInfo8);
    ImagesInfo imagesInfo10 =
    ImagesInfo(image: MyImages.netDown, name: 'Net down');
    _paintNet.add(imagesInfo10);
    ImagesInfo imagesInfo9 =
    ImagesInfo(image: MyImages.netRight, name: 'Net right');
    _paintNet.add(imagesInfo9);
    ImagesInfo imagesInfo7 =
    ImagesInfo(image: MyImages.leftNet, name: 'Net left');
    _paintNet.add(imagesInfo7);
    ImagesInfo imagesInfo11 =
    ImagesInfo(image: MyImages.mininet, name: 'Mini net');
    _paintNet.add(imagesInfo11);

    ImagesInfo imagesInfo12 =
    ImagesInfo(image: MyImages.forward1, name: 'Forward 1');
    _paintForward.add(imagesInfo12);
    ImagesInfo imagesInfo13 =
    ImagesInfo(image: MyImages.forward2, name: 'Forward 2');
    _paintForward.add(imagesInfo13);
    ImagesInfo imagesInfo14 =
    ImagesInfo(image: MyImages.forward3, name: 'Forward 3');
    _paintForward.add(imagesInfo14);
    ImagesInfo imagesInfo15 =
    ImagesInfo(image: MyImages.forward4, name: 'Forward 4');
    _paintForward.add(imagesInfo15);
    ImagesInfo imagesInfo16 =
    ImagesInfo(image: MyImages.forward5, name: 'Forward 5');
    _paintForward.add(imagesInfo16);

    ImagesInfo imagesInfo17 =
    ImagesInfo(image: MyImages.defence1, name: 'Defense 1');
    _paintDefence.add(imagesInfo17);
    ImagesInfo imagesInfo18 =
    ImagesInfo(image: MyImages.defence2, name: 'Defense 2');
    _paintDefence.add(imagesInfo18);
    ImagesInfo imagesInfo19 =
    ImagesInfo(image: MyImages.defence3, name: 'Defense 3');
    _paintDefence.add(imagesInfo19);
    ImagesInfo imagesInfo20 =
    ImagesInfo(image: MyImages.defence4, name: 'Defense 4');
    _paintDefence.add(imagesInfo20);
    ImagesInfo imagesInfo21 =
    ImagesInfo(image: MyImages.defence5, name: 'Defense 5');
    _paintDefence.add(imagesInfo21);

    ImagesInfo imagesInfo22 =
    ImagesInfo(image: MyImages.forward, name: 'Forward');
    _paintPlayer.add(imagesInfo22);
    ImagesInfo imagesInfo23 =
    ImagesInfo(image: MyImages.defence, name: 'Defense');
    _paintPlayer.add(imagesInfo23);
    ImagesInfo imagesInfo24 =
    ImagesInfo(image: MyImages.opponent, name: 'Opponent');
    _paintPlayer.add(imagesInfo24);
    ImagesInfo imagesInfo25 =
    ImagesInfo(image: MyImages.playerType, name: 'Player type 1');
    _paintPlayer.add(imagesInfo25);
    ImagesInfo imagesInfo26 =
    ImagesInfo(image: MyImages.playerType2, name: 'Player type 2');
    _paintPlayer.add(imagesInfo26);
    ImagesInfo imagesInfo27 =
    ImagesInfo(image: MyImages.playerType3, name: 'Player type X');
    _paintPlayer.add(imagesInfo27);

    ImagesInfo imagesInfo28 =
    ImagesInfo(image: MyImages.center, name: 'Center');
    _paintPosition.add(imagesInfo28);
    ImagesInfo imagesInfo29 =
    ImagesInfo(image: MyImages.leftWing, name: 'Left wing');
    _paintPosition.add(imagesInfo29);
    ImagesInfo imagesInfo30 =
    ImagesInfo(image: MyImages.rightWing, name: 'Right wing');
    _paintPosition.add(imagesInfo30);
    ImagesInfo imagesInfo31 =
    ImagesInfo(image: MyImages.leftDefence, name: 'Left defense');
    _paintPosition.add(imagesInfo31);
    ImagesInfo imagesInfo32 =
    ImagesInfo(image: MyImages.rightDefence, name: 'Right defense');
    _paintPosition.add(imagesInfo32);
    ImagesInfo imagesInfo33 =
    ImagesInfo(image: MyImages.goalie, name: 'Goalie');
    _paintPosition.add(imagesInfo33);
    ImagesInfo imagesInfo34 = ImagesInfo(image: MyImages.coach, name: 'Coach');
    _paintPosition.add(imagesInfo34);

    ImagesInfo imagesInfo35 = ImagesInfo(image: MyImages.number1, name: '1');
    _paintNumber.add(imagesInfo35);
    ImagesInfo imagesInfo36 = ImagesInfo(image: MyImages.number2, name: '2');
    _paintNumber.add(imagesInfo36);
    ImagesInfo imagesInfo37 = ImagesInfo(image: MyImages.number3, name: '3');
    _paintNumber.add(imagesInfo37);
    ImagesInfo imagesInfo38 = ImagesInfo(image: MyImages.number4, name: '4');
    _paintNumber.add(imagesInfo38);
    ImagesInfo imagesInfo39 = ImagesInfo(image: MyImages.number5, name: '5');
    _paintNumber.add(imagesInfo39);
    ImagesInfo imagesInfo40 = ImagesInfo(image: MyImages.number6, name: '6');
    _paintNumber.add(imagesInfo40);
    ImagesInfo imagesInfo41 = ImagesInfo(image: MyImages.number7, name: '7');
    _paintNumber.add(imagesInfo41);
    ImagesInfo imagesInfo42 = ImagesInfo(image: MyImages.number8, name: '8');
    _paintNumber.add(imagesInfo42);
    ImagesInfo imagesInfo43 = ImagesInfo(image: MyImages.number9, name: '9');
    _paintNumber.add(imagesInfo43);

    ImagesInfo imagesInfo44 = ImagesInfo(
        image: "",
        name: 'Move',
        icon: Icon(
          CupertinoIcons.move,
          size: 25,
        ));
    _paintActionIcon.add(imagesInfo44);
    ImagesInfo imagesInfo45 = ImagesInfo(
        image: "",
        name: 'Rotate',
        icon: Icon(
          Icons.sync,
          size: 25,
        ));
    _paintActionIcon.add(imagesInfo45);
    ImagesInfo imagesInfo46 = ImagesInfo(
        image: "",
        name: 'Scale',
        icon: Icon(
          Icons.zoom_out_map_sharp,
          size: 25,
        ));
    _paintActionIcon.add(imagesInfo46);
    ImagesInfo imagesInfo47 = ImagesInfo(
        image: "",
        name: 'Line width',
        icon: Icon(
          Icons.line_weight,
          size: 25,
        ));
    _paintActionIcon.add(imagesInfo47);

    ImagesInfo imagesInfo48 = ImagesInfo(image: MyImages.puck, name: 'Puck');
    _paintPuck.add(imagesInfo48);
    ImagesInfo imagesInfo49 = ImagesInfo(image: MyImages.pucks, name: 'Group of pucks');
    _paintPuck.add(imagesInfo49);

    ModeData imagesInfo50 = ModeData(icon: CupertinoIcons.rectangle,
        mode: PaintMode.rect,
        label: 'Rectangle', image: '');
    _paintActionShapes.add(imagesInfo50);

    ModeData imagesInfo51 = ModeData( icon: CupertinoIcons.circle,
        mode: PaintMode.circle,
        label: 'Circle', image: '');
    _paintActionShapes.add(imagesInfo51);

    if (widget.isSignature!) {
      _controller = ValueNotifier(
          const Controller(mode: PaintMode.freeStyle, color: Colors.black));
    }
    else if (widget.isSignature!) {
      _controller = ValueNotifier(
          const Controller(mode: PaintMode.freeStyleWave, color: Colors.black));
    }else if (widget.isSignature!) {
      _controller = ValueNotifier(
          const Controller(mode: PaintMode.freeStyleArrowStop, color: Colors.black));
    }
    else if (widget.isSignature!) {
      _controller = ValueNotifier(
          const Controller(mode: PaintMode.freeStyleArrow, color: Colors.black));
    }
    else if (widget.isSignature!) {
      _controller = ValueNotifier(
          const Controller(mode: PaintMode.freeStyleDashline, color: Colors.black));
    }
    else if (widget.isSignature!) {
      _controller = ValueNotifier(
          const Controller(mode: PaintMode.freeStyleLateralSkating, color: Colors.black));
    }
    else if (widget.isSignature!) {
      _controller = ValueNotifier(
          const Controller(mode: PaintMode.freeStyleLateralSkatingStop, color: Colors.black));
    }
    else {
      _controller = ValueNotifier(const Controller().copyWith(
          mode: widget.initialPaintMode!,
          strokeWidth: widget.initialStrokeWidth!,
          color: widget.initialColor!));
    }
    _controllers = ValueNotifier(const Controller().copyWith(
    mode: Constant.initalShape,
    strokeWidth: widget.initialStrokeWidth!,
    color: widget.initialColor!));

    _textController = TextEditingController();
    textDelegate = widget.textDelegate ?? TextDelegate();




  }

  @override
  void dispose() {
    _controller!.dispose();
    _controllers!.dispose();
    _isLoaded!.dispose();
    print("Dispose");
    _textController!.dispose();
    super.dispose();
  }

  Paint get _painter => Paint()
    ..color = _controller!.value.color
    ..strokeWidth = _controller!.value.strokeWidth * _strokeMultiplier
    ..style = _controller!.value.mode == PaintMode.dashLine
        ? PaintingStyle.stroke
        : _controller!.value.paintStyle;

  ///Converts the incoming image type from constructor to [ui.Image]
  Future<void> _resolveAndConvertImage() async {
    if (widget.networkUrl != null) {
      _image = await _loadNetworkImage(widget.networkUrl!);
      if (_image == null) {
        throw ("${widget.networkUrl} couldn't be resolved.");
      } else {
        _setStrokeMultiplier();
      }
    } else if (widget.assetPath != null) {
      final img = await rootBundle.load(widget.assetPath!);
      _image = await _convertImage(Uint8List.view(img.buffer));
      if (_image == null) {
        throw ("${widget.assetPath} couldn't be resolved.");
      } else {
        _setStrokeMultiplier();
      }
    } else if (widget.file != null) {
      final img = await widget.file!.readAsBytes();
      _image = await _convertImage(img);
      if (_image == null) {
        throw ("Image couldn't be resolved from provided file.");
      } else {
        _setStrokeMultiplier();
      }
    } else if (widget.byteArray != null) {
      _image = await _convertImage(widget.byteArray!);
      if (_image == null) {
        throw ("Image couldn't be resolved from provided byteArray.");
      } else {
        _setStrokeMultiplier();
      }
    } else {
      _isLoaded!.value = true;
    }
  }

  Future<void> _convertSVGToImage() async {

    if (Constant.type == 1) {
      svgImagePath=Constant.initalImage;
      svgString =
      await DefaultAssetBundle.of(context).loadString(Constant.initalImage);
    } else if (Constant.type == 2) {
      svgImagePath=Constant.initalNet;
      svgString =
      await DefaultAssetBundle.of(context).loadString(Constant.initalNet);
    } else if (Constant.type == 3) {
      svgImagePath=Constant.initalForward;
      svgString = await DefaultAssetBundle.of(context)
          .loadString(Constant.initalForward);
    } else if (Constant.type == 4) {
      svgImagePath=Constant.initalDefense;
      svgString = await DefaultAssetBundle.of(context)
          .loadString(Constant.initalDefense);
    } else if (Constant.type == 5) {
      svgImagePath=Constant.initalPlayer;
      svgString = await DefaultAssetBundle.of(context)
          .loadString(Constant.initalPlayer);
    } else if (Constant.type == 6) {
      svgImagePath=Constant.initalPosition;
      svgString = await DefaultAssetBundle.of(context)
          .loadString(Constant.initalPosition);
    } else if (Constant.type == 7) {
      svgImagePath=Constant.initalNumber;
      svgString = await DefaultAssetBundle.of(context)
          .loadString(Constant.initalNumber);
    }else if (Constant.type == 8) {
      svgImagePath=Constant.initalPuck;
      svgString = await DefaultAssetBundle.of(context)
          .loadString(Constant.initalPuck);
    }
    /*else if (Constant.type == 9) {
      svgString = await DefaultAssetBundle.of(context)
          .loadString(Constant.initalShape);
    }*/
    if (svgString.isNotEmpty) {
      DrawableRoot svgDrawableRoot;
      if(_controller!.value.color==Colors.black){
        svgDrawableRoot = await svg.fromSvgString(svgString, svgString);

        /*svgDrawableRoot =
        await svg.fromSvgString(svgString,SvgTheme(),"");*/
      }else{
        svgDrawableRoot = await svg.fromSvgString(svgString, svgString);
        svgDrawableRoot= svgDrawableRoot.mergeStyle(DrawableStyle(fill: DrawablePaint(PaintingStyle.fill,color:_controller!.value.color ),stroke: DrawablePaint(PaintingStyle.stroke,color:MyColors.white ) ));
        // svgDrawableRoot= svgDrawableRoot.mergeStyle(DrawableStyle(fill: DrawablePaint(PaintingStyle.fill,color:_controller.value.color )));

       /* svgDrawableRoot =
        await svg.fromSvgString(svgString,SvgTheme(currentColor: _controller.value.color),svgString);*/
      }

      /* String temp = svgString.substring(svgString.indexOf('height="')+8);
    int originalHeight = int.parse(temp.substring(0, temp.indexOf('p')));
    temp = svgString.substring(svgString.indexOf('width="')+7);
    int originalWidth = int.parse(temp.substring(0, temp.indexOf('p')));

    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    double width = originalHeight * devicePixelRatio; // where 32 is your SVG's original width
    double height = originalWidth * devicePixelRatio; // same thing
*/
      ui.Picture picture = svgDrawableRoot.toPicture(size: Size(37, 37));
      // ui.Picture picture = svgDrawableRoot.toPicture(size: Size(37, 37),colorFilter: ColorFilter.mode(_controller.value.color, BlendMode.clear));


      _image = await picture.toImage(37, 37);
    }
    /*if (_image == null) {
      throw ("${widget.assetPath} couldn't be resolved.");
    } else {
      _setStrokeMultiplier();
    }*/
  }

  ///Dynamically sets stroke multiplier on the basis of widget size.
  ///Implemented to avoid thin stroke on high res images.
  _setStrokeMultiplier() {
    if ((_image!.height + _image!.width) > 1000) {
      _strokeMultiplier = (_image!.height + _image!.width) ~/ 1000;
    }
  }

  ///Completer function to convert asset or file image to [ui.Image] before drawing on custompainter.
  Future<ui.Image> _convertImage(Uint8List img) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, (image) {
      if(_isLoaded!.value != null){
      _isLoaded!.value = true;}
      return completer.complete(image);
    });
    return completer.future;
  }

  ///Completer function to convert network image to [ui.Image] before drawing on custompainter.
  Future<ui.Image> _loadNetworkImage(String path) async {
    final completer = Completer<ImageInfo>();
    var img = NetworkImage(path);
    img.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info)));
    final imageInfo = await completer.future;
    _isLoaded!.value = true;
    return imageInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoaded!,
      builder: (_, loaded, __) {
        if (loaded) {
          return widget.isSignature! ? _paintSignature() : _paintImage();
        } else {
          return Container(
            height: widget.height ?? double.maxFinite,
            width: widget.width ?? double.maxFinite,
            child: Center(
              child: widget.placeHolder ?? const CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  ///paints image on given constrains for drawing if image is not null.
  Widget _paintImage() {
    return Container(
      height: widget.height ?? double.maxFinite,
      width: widget.width ?? double.maxFinite,
      child: Column(
        children: [
          if (widget.controlsAtTop!) _buildControls(),
          Expanded(
            child: FittedBox(
              alignment: FractionalOffset.center,
              child: ClipRect(
                child: ValueListenableBuilder<Controller>(
                  valueListenable: Constant.isImageShape == "Drill" ? _controller! : _controllers!,
                  builder: (_, controller, __) {
                    _convertSVGToImage();
                    return ImagePainterTransformer(
                      maxScale: 2.4,
                      minScale: 1,
                      panEnabled: controller.mode == PaintMode.none,
                      scaleEnabled: widget.isScalable!,
                      //onInteractionStart: _scaleStartGesture,
                      onTapUp: _tapStartGesture,
                      onInteractionUpdate: (details) =>
                          _scaleUpdateGesture(details, controller),
                      onInteractionEnd: (details) =>
                          _scaleEndGesture(details, controller),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.precise,
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(35)),
                          child: CustomPaint(
                            size: Size(200, 100),
                            willChange: true,
                            isComplex: true,
                            painter: DrawImage(
                              image: _image,
                              points: _points,
                              paintHistory: Constant.paintHistory,
                              isDragging: _inDrag,
                              update: UpdatePoints(
                                  start: _start,
                                  end: _end,
                                  painter: _painter,
                                  mode: controller.mode),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (!widget.controlsAtTop!) _buildControls(),
          SizedBox(height: MediaQuery.of(context).padding.bottom)
        ],
      ),
    );
  }

  Widget _paintSignature() {
    return Stack(
      children: [
        RepaintBoundary(
          key: _repaintKey,
          child: ClipRect(
            child: Container(
              width: widget.width ?? double.maxFinite,
              height: widget.height ?? double.maxFinite,
              child: ValueListenableBuilder<Controller>(
                valueListenable: Constant.isImageShape == "Drill" ? _controller! : _controllers!,
                builder: (_, controller, __) {
                  return ImagePainterTransformer(
                    panEnabled: false,
                    scaleEnabled: false,
                    onInteractionStart: _scaleStartGesture,
                    onInteractionUpdate: (details) =>
                        _scaleUpdateGesture(details, controller),
                    onInteractionEnd: (details) =>
                        _scaleEndGesture(details, controller),
                    child: CustomPaint(
                      willChange: true,
                      isComplex: true,
                      painter: DrawImage(
                        isSignature: true,
                        backgroundColor: widget.signatureBackgroundColor,
                        points: _points,
                        paintHistory: Constant.paintHistory,
                        isDragging: _inDrag,
                        update: UpdatePoints(
                            start: _start,
                            end: _end,
                            painter: _painter,
                            mode: controller.mode),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  tooltip: textDelegate!.undo,
                  icon: widget.undoIcon ??
                      Icon(Icons.reply, color: Colors.grey[700]),
                  onPressed: () {
                    if (Constant.paintHistory.isNotEmpty) {
                      setState(Constant.paintHistory.removeLast);
                    }
                  }),
              IconButton(
                tooltip: textDelegate!.clearAllProgress,
                icon: widget.clearAllIcon ??
                    Icon(Icons.clear, color: Colors.grey[700]),
                onPressed: () => setState(Constant.paintHistory.clear),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _scaleStartGesture(ScaleStartDetails onStart) {
    print(onStart);
    print(DateTime.now().millisecondsSinceEpoch);
    _points.clear();
    if (!widget.isSignature! && Constant.isImageSelected) {

      setState(() {
        _start = onStart.localFocalPoint;
        _points.add(_start!);
        // _controller.value = controller.copyWith(mode: item.mode);
        PaintInfo painInfo = PaintInfo();
        painInfo.imageData = _image;
        painInfo.image = svgImagePath;
        painInfo.isImageSelected = true;
        painInfo.color = _controller!.value.color.toString();
        painInfo.id = DateTime.now().millisecondsSinceEpoch.toString();
        painInfo.offset = <Offset>[_start!];
        Constant.paintHistory.add(painInfo);
      });
    }
  }

  _tapStartGesture(TapUpDetails onStart) {
    print(onStart);
    print(DateTime.now().millisecondsSinceEpoch);
    _points.clear();
    if (!widget.isSignature! && Constant.isImageSelected) {

      setState(() {
        _start = onStart.localPosition;
        _points.add(_start!);
        // _controller.value = controller.copyWith(mode: item.mode);
        PaintInfo painInfo = PaintInfo();
        painInfo.imageData = _image;
        painInfo.image = svgImagePath;
        painInfo.isImageSelected = true;
        painInfo.color = _controller!.value.color.toString();
        painInfo.id = DateTime.now().millisecondsSinceEpoch.toString();
        painInfo.offset = <Offset>[_start!];
        Constant.paintHistory.add(painInfo);
        _points.clear();
        _start = null;
        _end = null;
      });
    }
  }


  ///Fires while user is interacting with the screen to record painting.
  void _scaleUpdateGesture(ScaleUpdateDetails onUpdate, Controller ctrl) {
    print(onUpdate);
    if (!Constant.isImageSelected && !Constant.isImageAction && !Constant.isTextSelected) {
      setState(
            () {
          _inDrag = true;
          _start ??= onUpdate.focalPoint;
          _end = onUpdate.focalPoint;
          if (ctrl.mode == PaintMode.freeStyle) _points.add(_end!);
          if (ctrl.mode == PaintMode.freeStyleWave) _points.add(_end!);
          if (ctrl.mode == PaintMode.freeStyleArrow) _points.add(_end!);
          if (ctrl.mode == PaintMode.freeStyleArrowStop) _points.add(_end!);
          if (ctrl.mode == PaintMode.freeStyleDashline) _points.add(_end!);
          if (ctrl.mode == PaintMode.freeStyleLateralSkating) _points.add(_end!);
          if (ctrl.mode == PaintMode.freeStyleLateralSkatingStop) _points.add(_end!);

          // if (ctrl.mode == PaintMode.text &&
          //     Constant.paintHistory
          //         .where((element) => element.mode == PaintMode.text)
          //         .isNotEmpty) {
          //   Constant.paintHistory
          //       .lastWhere((element) => element.mode == PaintMode.text)
          //       .offset = [_end];
          // }
        },
      );
    }else if(Constant.isTextSelected){
      setState(() {
        // _inDrag = true;
        // _start ??= onUpdate.focalPoint;
        _end = onUpdate.focalPoint;
        if (
        Constant.paintHistory
            .where((element) => element.mode == PaintMode.text)
            .isNotEmpty) {
          Constant.paintHistory
              .lastWhere((element) => element.mode == PaintMode.text)
              .offset = [_end!];
        }
      });

    }
    // else if (Constant.isImageAction) {
    //   setState(() {
    //     _inDrag = true;
    //     _start ??= onUpdate.focalPoint;
    //     _end = onUpdate.localFocalPoint;
    //     if (ctrl.mode == PaintMode.freeStyleWave) _points.add(_end);
    //     for(int i=0;i<Constant.paintHistory.length;i++){
    //       if(Constant.paintHistory[i].mode == null){
    //
    //       }
    //     }
    //     Constant.paintHistory.lastWhere((element) => element.mode == null).offset = [_end];
    //   });
    //
    //   // setState(() {
    //   //   _inDrag = true;
    //   //   _start ??= onUpdate.focalPoint;
    //   //   _end = onUpdate.focalPoint;
    //   //   Constant.paintHistory
    //   //       .lastWhere((element) => element.id == ctrl.id)
    //   //       .offset = [_end];
    //   // });
    //
    // }
    /*else if (!Constant.isImageAction) {
      print("jj");
      setState(() {
        _inDrag = true;
        _start ??= onUpdate.focalPoint;
        _end = onUpdate.focalPoint;
        _points.add(_end);
      });

      // setState(() {
      //   _inDrag = true;
      //   _start ??= onUpdate.focalPoint;
      //   _end = onUpdate.focalPoint;
      //   Constant.paintHistory
      //       .lastWhere((element) => element.id == ctrl.id)
      //       .offset = [_end];
      // });

    }*/

  }

  ///Fires when user stops interacting with the screen.
  void _scaleEndGesture(ScaleEndDetails onEnd, Controller controller) {
    if(!Constant.isTextSelected) {
      if (!Constant.isImageSelected) {
        setState(() {
          _inDrag = false;
          if (_start != null &&
              _end != null &&
              (controller.mode == PaintMode.freeStyle)
          ) {
            // _points.add(null);
            _addFreeStylePoint();


            _points.clear();
          } else if (_start != null &&
              _end != null &&

              (controller.mode == PaintMode.freeStyleArrow)
          ) {
            //_points.add(null);
            _addFreeStyleArrow();


            _points.clear();
          }
          else if (_start != null &&
              _end != null &&

              (controller.mode == PaintMode.freeStyleWave)
          ) {
            // _points.add(null);
            _addFreeStyleWave();


            _points.clear();
          }
          else if (_start != null &&
              _end != null &&

              (controller.mode == PaintMode.freeStyleArrowStop)
          ) {
            //_points.add(null);
            _addFreeStyleArrowStop();


            _points.clear();
          }
          else if (_start != null &&
              _end != null &&

              (controller.mode == PaintMode.freeStyleDashline)
          ) {
            //_points.add(null);
            _addFreeStyleDashline();


            _points.clear();
          }
          else if (_start != null &&
              _end != null &&

              (controller.mode == PaintMode.freeStyleLateralSkatingStop)
          ) {
            // _points.add(null);
            _addFreeStylePointlateralstop();


            _points.clear();
          }
          else if (_start != null &&
              _end != null &&

              (controller.mode == PaintMode.freeStyleLateralSkating)
          ) {
            // _points.add(null);
            _addFreeStylePointlateral();


            _points.clear();
          }
          else if (_start != null &&
              _end != null &&
              controller.mode != PaintMode.text) {
            _addEndPoints();
            _points.clear();

          }
          _start = null;
          _end = null;
        });
      } else {
        setState(() {
          _inDrag = false;
          if (_start != null &&
              _end != null
          ) {
            //_points.add(null);
            PaintInfo painInfo = PaintInfo();
            painInfo.imageData = _image;
            painInfo.image = svgImagePath;
            painInfo.color = _controller!.value.color.toString();
            painInfo.isImageSelected = true;
            painInfo.id = DateTime
                .now()
                .millisecondsSinceEpoch
                .toString();
            painInfo.offset = <Offset>[..._points];
            Constant.paintHistory.add(painInfo);
            _points.clear();
          }
        });
      }
    }
  }

  void _addEndPoints() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[_start!, _end!],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: Constant.isImageShape == "Drill" ?_controller!.value.mode :_controllers!.value.mode,
    ),
  );



  void _addFreeStyleArrow() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[..._points],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: PaintMode.freeStyleArrow,

    ),
  );

  void _addFreeStyleWave() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[..._points],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: PaintMode.freeStyleWave,

    ),
  );

  void _addFreeStylePoint() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[..._points],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: PaintMode.freeStyle,

    ),
  );

  void _addFreeStyleArrowStop() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[..._points],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: PaintMode.freeStyleArrowStop,

    ),
  );

  void _addFreeStyleDashline() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[..._points],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: PaintMode.freeStyleDashline,

    ),
  );

  void _addFreeStylePointlateral() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[..._points],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: PaintMode.freeStyleLateralSkating,

    ),
  );

  void _addFreeStylePointlateralstop() => _addPaintHistory(
    PaintInfo(
      offset: <Offset>[..._points],
      painter: _painter,
      color:_controller!.value.color.toString(),
      strokeWidth: _controller!.value.strokeWidth * _strokeMultiplier,
      style:(_controller!.value.mode == PaintMode.dashLine
          ? PaintingStyle.stroke
          : _controller!.value.paintStyle).toString() ,
      mode: PaintMode.freeStyleLateralSkatingStop,

    ),
  );


  ///Provides [ui.Image] of the recorded canvas to perform action.
  Future<ui.Image> _renderImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter =
    DrawImage(image: _image, paintHistory: Constant.paintHistory);
    final size = Size(_image!.width.toDouble(), _image!.height.toDouble());
    painter.paint(canvas, size);
    return recorder
        .endRecording()
        .toImage(size.width.floor(), size.height.floor());
  }

  PopupMenuItem _showOptionsRow(Controller controller) {
    return PopupMenuItem(
      enabled: false,
      child: Center(
        child: SizedBox(
          child: Wrap(
            children: paintModes(textDelegate!)
                .map(
                  (item) => SelectionItems(
                data: item,
                isSelected: controller.mode == item.mode,
                onTap: () {
                  Constant.isTextSelected = false;
                  Constant.isImageSelected = false;
                  Constant.isImageAction = false;
                  Constant.initalDrill = item.mode!;
                  Constant.isImageShape = "Drill";
                  if (widget.onPaintModeChanged != null &&
                      item.mode != null) {
                    widget.onPaintModeChanged!(item.mode!);
                  }
                  _controller!.value = controller.copyWith(mode: item.mode!);
                  Navigator.of(context).pop();
                },
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }


  PopupMenuItem _showOptionsRow1(Controller controller) {
    return PopupMenuItem(
      enabled: false,
      child: Center(
        child: SizedBox(
          child: Wrap(
            children: paintModes1(textDelegate!)
                .map(
                  (item) => SelectionItems(
                data: item,
                isSelected: controller.mode == item.mode,
                onTap: () {
                  Constant.isImageSelected = false;
                  Constant.isTextSelected = false;
                  Constant.isImageAction = false;
                  Constant.initalShape = item.mode!;
                  Constant.isImageShape = "Shape";
                  if (widget.onPaintModeChanged != null &&
                      item.mode != null) {
                    widget.onPaintModeChanged!(item.mode!);
                  }
                  _controllers!.value = controller.copyWith(mode: item.mode!);
                  Navigator.of(context).pop();
                },
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }

  PopupMenuItem _showRangeSlider() {
    return PopupMenuItem(
      enabled: false,
      child: SizedBox(
        width: double.maxFinite,
        child: ValueListenableBuilder<Controller>(
          valueListenable: _controller!,
          builder: (_, ctrl, __) {
            return RangedSlider(
              value: ctrl.strokeWidth,
              onChanged: (value) {
                _controller!.value = ctrl.copyWith(strokeWidth: value);
                if (widget.onStrokeWidthChanged != null) {
                  widget.onStrokeWidthChanged!(value);
                }
              },
            );
          },
        ),
      ),
    );
  }

  PopupMenuItem _showColorPicker(Controller controller) {
    return PopupMenuItem(

        enabled: false,
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: (widget.colors ?? editorColors).map((color) {
              return ColorItem(

                isSelected: color == controller.color,
                color: color,
                onTap: () {
                  _controller!.value = controller.copyWith(color: color);
                  Constant.initalColor=color;
                  if (widget.onColorChanged != null) {
                    widget.onColorChanged!(color);
                  }
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ));
  }

  ///Generates [Uint8List] of the [ui.Image] generated by the [renderImage()] method.
  ///Can be converted to image file by writing as bytes.
  Future<Uint8List> exportImage() async {
     ui.Image _convertedImage;
    if (widget.isSignature!) {
      final _boundary = _repaintKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;
      _convertedImage = await _boundary.toImage(pixelRatio: 3);
    } else if (widget.byteArray != null && Constant.paintHistory.isEmpty) {
      return widget.byteArray!;
    } else {
      _convertedImage = await _renderImage();
    }
    final byteData =
    await _convertedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  void _addPaintHistory(PaintInfo info) {
    if (info.mode != PaintMode.none) {
      Constant.paintHistory.add(info);
    }
  }

  void _openTextDialog() {

    Constant.isTextSelected = true;
    Constant.isImageSelected = false;
    Constant.isImageAction = false;
    Constant.isImageShape = "Drill";
    TextEditingController textEditingController=TextEditingController();
    // if (widget.onPaintModeChanged != null) {
    //   widget.onPaintModeChanged!(PaintMode.text);
    // }
    // _controller.value = controller.copyWith(mode: item.mode);
    // _controller.value = _controller.value.copyWith(mode: PaintMode.text);
    // final fontSize = 6 * _controller.value.strokeWidth;
    // print(fontSize);
   /* showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  _textController!.text = value;
                });
              },
              controller: _textController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });*/
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child:  FancyDialog(
              gifPath: MyImages.team,
              title: "",
              okFun: () => {

              if (textEditingController.text.trim().isNotEmpty) {
                            _addPaintHistory(
                              PaintInfo(
                                  mode: PaintMode.text,
                                  text: textEditingController.text,
                                  painter: _painter,
                                  color: _controller!.value.color.toString(),
                                  strokeWidth: _controller!.value.strokeWidth *
                                      _strokeMultiplier,
                                  style: (_controller!.value.mode == PaintMode.dashLine
                                      ? PaintingStyle.stroke
                                      : _controller!.value.paintStyle).toString(),
                                  id: DateTime
                                      .now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  offset: []),
                            ),
                            widget.setRefresh!(),
                            textEditingController.clear(),
                Navigator.of(context).pop()

              }else
                (_formKey.currentState!.validate())
          },
              cancelFun: () => {Navigator.of(context).pop()},
              cancelColor: MyColors.red,
              // title: MyStrings.noDrill,
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,

                child: CustomizeTextFormField(

                  labelText: "Text",
                  controller: textEditingController,
                  inputAction: TextInputAction.done,
                  isLast: true,
                  isEnabled: true,
                  validator:ValidateInput.requiredFields,
                  onSave: (value) {

                  },

                ),
              ),
            ),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(bottom: 80),
            //       child: Align(
            //         alignment: Alignment.topLeft,
            //         child: TextButton(
            //
            //             child: Text(
            //               textDelegate.cancel,
            //               style: const TextStyle(
            //                 color: Colors.white,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             onPressed:(){
            //               if (textEditingController.text != '') {
            //                 _addPaintHistory(
            //                   PaintInfo(
            //                       mode: PaintMode.text,
            //                       text: textEditingController.text,
            //                       painter: _painter,
            //                       color: _controller.value.color.toString(),
            //                       strokeWidth: _controller.value.strokeWidth *
            //                           _strokeMultiplier,
            //                       style: (_controller.value.mode == PaintMode.dashLine
            //                           ? PaintingStyle.stroke
            //                           : _controller.value.paintStyle).toString(),
            //                       id: DateTime
            //                           .now()
            //                           .millisecondsSinceEpoch
            //                           .toString(),
            //                       offset: []),
            //                 );
            //                 widget.setRefresh();
            //                 textEditingController.clear();
            //               }
            //               Navigator.pop(context);
            //
            //             }),
            //       ),
            //     ),
            //     TextField(
            //       controller: textEditingController,
            //       autofocus: true,
            //       style: TextStyle(
            //            fontWeight: FontWeight.bold, ),
            //       textAlign: TextAlign.center,
            //       decoration: const InputDecoration(
            //         contentPadding: EdgeInsets.symmetric(horizontal: 10),
            //         border: InputBorder.none,
            //       ),
            //     ),
            //     Align(
            //       alignment: Alignment.bottomRight,
            //       child: TextButton(
            //           child: Text(
            //             textDelegate.done,
            //             style: const TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //           onPressed:(){
            //             if (textEditingController.text != '') {
            //               _addPaintHistory(
            //                 PaintInfo(
            //                     mode: PaintMode.text,
            //                     text: textEditingController.text,
            //                     painter: _painter,
            //                     color: _controller.value.color.toString(),
            //                     strokeWidth: _controller.value.strokeWidth *
            //                         _strokeMultiplier,
            //                     style: (_controller.value.mode == PaintMode.dashLine
            //                         ? PaintingStyle.stroke
            //                         : _controller.value.paintStyle).toString(),
            //                     id: DateTime
            //                         .now()
            //                         .millisecondsSinceEpoch
            //                         .toString(),
            //                     offset: []),
            //               );
            //               widget.setRefresh();
            //               textEditingController.clear();
            //             }
            //             Navigator.pop(context);
            //
            //           }),
            //     ),
            //   ],
            // ),
          );
        });
  // TextDialog.show(context, _textController!, fontSize, _controller.value.color,
  //     textDelegate, onFinished: () {
  //       if (_textController!.text != '') {
  //         setState(() {
  //           _addPaintHistory(
  //             PaintInfo(
  //                 mode: PaintMode.text,
  //                 text: _textController!.text,
  //                 painter: _painter,
  //                 color: _controller.value.color.toString(),
  //                 strokeWidth: _controller.value.strokeWidth *
  //                     _strokeMultiplier,
  //                 style: (_controller.value.mode == PaintMode.dashLine
  //                     ? PaintingStyle.stroke
  //                     : _controller.value.paintStyle).toString(),
  //                 id: DateTime
  //                     .now()
  //                     .millisecondsSinceEpoch
  //                     .toString(),
  //                 offset: []),
  //           );
  //         });
  //         _textController!.clear();
  //       }
  //       Navigator.pop(context);
  //     });

  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(4),
      color: Colors.grey[200],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ValueListenableBuilder<Controller>(
                valueListenable: _controller!,
                builder: (_, _ctrl, __) {
                  return PopupMenuButton(
                    tooltip: textDelegate!.selectDrill,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),

                    icon: Icon(
                        paintModes(textDelegate!)
                            .firstWhere((item) => item.mode == _ctrl.mode)
                            .icon,
                        color: Colors.grey[700],size: 25,),
                    itemBuilder: (_) => [_showOptionsRow(_ctrl)],
                  );
                }),
            SizedBox(
              width: 10,
            ),
            ValueListenableBuilder<Controller>(
                valueListenable: _controllers!,
                builder: (_, _ctrls, __) {
                  return PopupMenuButton(
                    tooltip: textDelegate!.selectBorder,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    icon: Icon(paintModes1(textDelegate!).firstWhere((item) => item.mode == _ctrls.mode).icon,
                        color: Colors.grey[700]),
                    itemBuilder: (_) => [_showOptionsRow1(_ctrls)],
                  );
                }),
            // ValueListenableBuilder<Controller>(
            //     valueListenable: _controller,
            //     builder: (_, controller, __) {
            //       return PopupMenuButton(
            //         padding: const EdgeInsets.symmetric(vertical: 10),
            //         shape: ContinuousRectangleBorder(
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         tooltip: textDelegate.changeColor,
            //         icon: widget.colorIcon ??
            //             Container(
            //               padding: const EdgeInsets.all(2.0),
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 border: Border.all(color: Colors.grey),
            //                 color: controller.color,
            //               ),
            //             ),
            //         itemBuilder: (_) => [_showColorPicker(controller)],
            //       );
            //     }),
            // PopupMenuButton(
            //   tooltip: textDelegate.changeBrushSize,
            //   shape: ContinuousRectangleBorder(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   icon:
            //   widget.brushIcon ?? Icon(Icons.brush, color: Colors.grey[700]),
            //   itemBuilder: (_) => [_showRangeSlider()],
            // ),

            IconButton(tooltip: textDelegate!.text,
                icon: const Icon(Icons.text_format), onPressed:_openTextDialog),
            //const Spacer(),

            PopupMenuButton(
              child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(Constant.initalPuck, width: 25),
                    ],
                  )),
              initialValue: Constant.initalPuck,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintPuck.length, (index) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        Constant.isImageSelected = true;
                        Constant.isTextSelected = false;
                        Constant.isImageAction = false;
                        Constant.type = 8;
                        Constant.initalPuck = _paintPuck[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintPuck[index].image,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_paintPuck[index].name!),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
              width: 20,
            ),

            PopupMenuButton(
              child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(Constant.initalImage, width: 25),
                    ],
                  )),
              initialValue: Constant.initalImage,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintImages.length, (index) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        Constant.isImageSelected = true;
                        Constant.isTextSelected = false;
                        Constant.isImageAction = false;
                        Constant.type = 1;
                        Constant.initalImage = _paintImages[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintImages[index].image,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_paintImages[index].name!),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
              width: 20,
            ),

            PopupMenuButton(

              child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(Constant.initalNet, width: 25),
                    ],
                  )),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintNet.length, (index) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        Constant.isImageSelected = true;
                        Constant.isTextSelected = false;
                        Constant.isImageAction = false;
                        Constant.type = 2;
                        Constant.initalNet = _paintNet[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintNet[index].image,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_paintNet[index].name!),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
              width: 20,
            ),

            PopupMenuButton(
              child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(Constant.initalForward, width: 25),
                    ],
                  )),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintForward.length, (index) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        Constant.isImageSelected = true;
                        Constant.isTextSelected = false;
                        Constant.isImageAction = false;
                        Constant.type = 3;
                        Constant.initalForward = _paintForward[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintForward[index].image,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_paintForward[index].name!),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
              width: 20,
            ),

            PopupMenuButton(
              child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(Constant.initalDefense, width: 25),
                    ],
                  )),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintDefence.length, (index) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        Constant.isImageSelected = true;
                        Constant.isTextSelected = false;
                        Constant.isImageAction = false;
                        Constant.type = 4;
                        Constant.initalDefense = _paintDefence[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintDefence[index].image,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_paintDefence[index].name!),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
              width: 20,
            ),

            PopupMenuButton(
              child: Center(
                  child: Row(
                children: [
                  SvgPicture.asset(Constant.initalPlayer, width: 25),
                ],
              )),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintPlayer.length, (index) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        Constant.isImageSelected = true;
                        Constant.isTextSelected = false;
                        Constant.isImageAction = false;
                        Constant.type = 5;
                        Constant.initalPlayer = _paintPlayer[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintPlayer[index].image,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_paintPlayer[index].name!),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
              width: 20,
            ),

            PopupMenuButton(
              child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(Constant.initalPosition, width: 25),
                    ],
                  )),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintPosition.length, (index) {
                  return PopupMenuItem(
                    onTap: () {
                      setState(() {
                        Constant.isImageSelected = true;
                        Constant.isTextSelected = false;
                        Constant.isImageAction = false;
                        Constant.type = 6;
                        Constant.initalPosition = _paintPosition[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintPosition[index].image,
                          width: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(_paintPosition[index].name!),
                      ],
                    ),
                  );
                });
              },
            ),
            SizedBox(
              width: 20,
            ),

            PopupMenuButton(
              child: Center(
                  child: Row(
                    children: [
                      SvgPicture.asset(Constant.initalNumber, width: 25),
                    ],
                  )),
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              itemBuilder: (context) {
                return List.generate(_paintNumber.length, (index) {
                  return PopupMenuItem(
                    padding: EdgeInsets.only(left: 40),
                    onTap: () {
                      setState(() {
                        Constant.isImageAction = false;
                        Constant.isTextSelected = false;
                        Constant.isImageSelected = true;
                        Constant.type = 7;
                        Constant.initalNumber = _paintNumber[index].image!;
                      });
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _paintNumber[index].image,
                          width: 25,
                        ),
                        /*SizedBox(width: 10,),
                        Text(_paintNumber[index].name),*/
                      ],
                    ),
                  );
                });
              },
            ),
            // SizedBox(
            //   width: 20,
            // ),

            // PopupMenuButton(
            //   child: Center(
            //       child: Row(
            //         children: [
            //           Constant.initalActionIcon,
            //         ],
            //       )),
            //   shape: ContinuousRectangleBorder(
            //     borderRadius: BorderRadius.circular(40),
            //   ),
            //   itemBuilder: (context) {
            //     return List.generate(_paintActionIcon.length, (index) {
            //       return PopupMenuItem(
            //         onTap: () {
            //           setState(() {
            //             Constant.isImageAction = true;
            //             Constant.isImageSelected = false;
            //             Constant.initalAction = _paintActionIcon[index].name;
            //             Constant.initalActionIcon = _paintActionIcon[index].icon!;
            //           });
            //         },
            //         child: Row(
            //           children: [
            //             _paintActionIcon[index].icon!,
            //             SizedBox(
            //               width: 10,
            //             ),
            //             Text(_paintActionIcon[index].name),
            //           ],
            //         ),
            //       );
            //     });
            //   },
            // ),

            SizedBox(
              width: 20,
            ),
            ValueListenableBuilder<Controller>(
                valueListenable: _controller!,
                builder: (_, controller, __) {
                  return PopupMenuButton(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tooltip: textDelegate!.changeColor,
                    icon:  Icon(Icons.color_lens,color:  controller.color == MyColors.transparent ? MyColors.black : controller.color ,),
                    // widget.colorIcon ??
                    //     Container(
                    //       padding: const EdgeInsets.all(2.0),
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         border: Border.all(color: Colors.grey),
                    //         color: controller.color,
                    //       ),
                    //     ),
                    itemBuilder: (_) => [_showColorPicker(controller)],
                  );
                }),
            SizedBox(
              width: 20,
            ),
            IconButton(
                tooltip: textDelegate!.undo,
                icon: widget.undoIcon ??
                    Icon(Icons.undo, color: Colors.grey[700]),
                onPressed: () {
                 // Constant.isImageSelected = false;
                  print(Constant.paintHistory.length);
                  if (Constant.paintHistory.isNotEmpty) {
                    Constant.paintHistoryRedo.add(Constant.paintHistory.last);
                    if (Constant.paintHistory.last.isImage != null &&
                        Constant.paintHistory.last.isImage == true) {
                      widget.onUndo!(Constant.paintHistory.last.image!);
                    }
                    setState(Constant.paintHistory.removeLast);
                  }

                }),
            SizedBox(
              width: 20,
            ),

            IconButton(
                tooltip: textDelegate!.redo,
                icon: widget.undoIcon ??
                    Icon(Icons.redo, color: Colors.grey[700]),
                onPressed: () {
                  //Constant.isImageSelected = false;
                  Constant.paintHistory.add(Constant.paintHistoryRedo.last);
                  if (Constant.paintHistoryRedo.last.isImage != null &&
                      Constant.paintHistoryRedo.last.isImage == true) {
                    widget.onUndo!(Constant.paintHistoryRedo.last.fromImage!);
                  }
                  print(Constant.paintHistoryRedo);
                  setState(Constant.paintHistoryRedo.removeLast);
                }),
            SizedBox(
              width: 20,
            ),

            IconButton(
              tooltip: textDelegate!.clearAllProgress,
              icon: widget.clearAllIcon ??
                  Icon(Icons.clear, color: Colors.grey[700]),
              onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => FancyDialog(
                        gifPath: MyImages.team,
                        cancelColor: MyColors.red,
                        cancelFun: () => {
                          //Constant.isImageSelected = false,
                          Navigator.of(context).pop()
                        },
                        okFun: () => {


                        setState(() {
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
                          Constant.initalShape= PaintMode.circle;
                          Constant.initalDrill = PaintMode.freeStyleLateralSkating;


                          _controller!.value = Controller().copyWith(mode: PaintMode.freeStyleLateralSkating,strokeWidth: widget.initialStrokeWidth!,
                              color: widget.initialColor!);
                          _controllers!.value = Controller().copyWith(mode: PaintMode.circle,strokeWidth: widget.initialStrokeWidth!,
                              color: widget.initialColor!);


                        }),


                          setState(Constant.paintHistory.clear,),
                          setState(Constant.paintHistoryRedo.clear,),
                          Navigator.of(context).pop()
                        },
                        title: "Are you sure you want to clear?",
                      )),

            ),
          ],
        ),
      ),
    );
  }
}

///Gives access to manipulate the essential components like [strokeWidth], [Color] and [PaintMode].
@immutable
class Controller {
  ///Tracks [strokeWidth] of the [Paint] method.
  final double strokeWidth;

  ///Tracks [Color] of the [Paint] method.
  final Color color;

  ///Tracks [PaintingStyle] of the [Paint] method.
  final PaintingStyle paintStyle;

  ///Tracks [PaintMode] of the current [Paint] method.
  final PaintMode mode;

  ///Any text.
  final String text;

  ///Constructor of the [Controller] class.
  const Controller(
      {this.strokeWidth = 4.0,
        this.color = Colors.red,
        this.mode = PaintMode.line,
        this.paintStyle = PaintingStyle.stroke,
        this.text = ""});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Controller &&
        o.strokeWidth == strokeWidth &&
        o.color == color &&
        o.paintStyle == paintStyle &&
        o.mode == mode &&
        o.text == text;
  }

  @override
  int get hashCode {
    return strokeWidth.hashCode ^
    color.hashCode ^
    paintStyle.hashCode ^
    mode.hashCode ^
    text.hashCode;
  }

  ///copyWith Method to access immutable controller.
  Controller copyWith(
      {double? strokeWidth,
        Color? color,
        PaintMode? mode,
        PaintingStyle? paintingStyle,
        String? text}) {
    return Controller(
        strokeWidth: strokeWidth ?? this.strokeWidth,
        color: color ?? this.color,
        mode: mode ?? this.mode,
        paintStyle: paintingStyle ?? paintStyle,
        text: text ?? this.text);
  }
}
