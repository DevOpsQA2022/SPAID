
import 'package:flutter/material.dart';
import 'package:spaid/custom_widgets/_image_painter.dart';
import 'package:spaid/support/custom_icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/strings.dart';

import 'package:flutter/cupertino.dart';

import 'package:spaid/support/images.dart';


class SelectionItems extends StatelessWidget {
  final bool? isSelected;
  final ModeData? data;
  final VoidCallback ?onTap;

  const SelectionItems({Key? key, this.isSelected, this.data, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: isSelected! ? Colors.blue : Colors.transparent),
      child: ListTile(
        leading: IconTheme(
          data: const IconThemeData(opacity: 1.0),
          child: Icon(data!.icon,
              color: isSelected! ? Colors.white : Colors.black,size: 25,),
        ),
        title: Text(
          data!.label!,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
              color: isSelected!
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1!.color),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        selected: isSelected!,
      ),
    );
  }
}



List<ModeData> paintModes(TextDelegate textDelegate) => [
  // ModeData(
  //     icon: Icons.zoom_out_map,
  //     mode: PaintMode.none,
  //     label: textDelegate.noneZoom),
  ModeData(
      icon:MyFlutterApp.straight_lines,
      // image: Image.asset(
      //   'assets/images/arrow-stright.png',
      //
      // ),
      mode: PaintMode.line,
      label: textDelegate.line),
  // ModeData(
  //     icon: Icons.crop_free,
  //     mode: PaintMode.rect,
  //     label: textDelegate.rectangle),
  ModeData(
    icon: MyFlutterApp.arrow_freehand,
      mode: PaintMode.freeStyle,
      label: textDelegate.lineFreehand),
  ModeData(

      icon: Icons.arrow_forward_sharp,
      mode: PaintMode.skateArrow,
      label: textDelegate.SkateArrow),
  ModeData(
      icon: MyFlutterApp.arrow1,
      mode: PaintMode.freeStyleArrow,
      label: textDelegate.lineFreehandArrow),
  // ModeData(
  //     icon: MyFlutterApp.arrow1,
  //     mode: PaintMode.freeStyleDashline,
  //     label: textDelegate.dashlineFreehandArrow),
  ModeData(

      icon: MyFlutterApp.arrow_stright_stop,
      // image: MyImages.arrow_stright_stop,
      // image: Image.asset(
      //   'assets/images/spaid-arrow.png',
      //
      // ),
      mode: PaintMode.arrow,

      label: textDelegate.arrow),
  ModeData(
      icon: MyFlutterApp.arrow2,
      //   image: MyImages.arrow_freehand,
      mode: PaintMode.freeStyleArrowStop,
      label: textDelegate.lineFreehandArrowStop),


  // ModeData(
  //     icon: Icons.lens_outlined,
  //     mode: PaintMode.circle,
  //     label: textDelegate.circle),


  ModeData(
      icon: MyFlutterApp.dash_line,
      mode: PaintMode.dashLine,
      label: textDelegate.dashLine),
  ModeData(
      icon: MyFlutterApp.arrow11,
      // image: MyImages.dash_line,

      mode: PaintMode.dashLineArrow,
      label: textDelegate.dashLineArrow),
  ModeData(
      icon: MyFlutterApp.arroew,
      // image: MyImages.dash_line,

      mode: PaintMode.dashLineArrowStop,
      label: textDelegate.dashLineArrowStop),

  ModeData(
      icon: MyFlutterApp.arrow13,
      // image: MyImages.dash_line,
      mode: PaintMode.freeStyleLateralSkating,
      label: textDelegate.lateralSkating),

  ModeData(
      icon: MyFlutterApp.njsj__1_,
      // image: MyImages.dash_line,
      mode: PaintMode.freeStyleLateralSkatingStop,
      label: textDelegate.lateralSkatingStop),

  // ModeData(
  //     icon: MyFlutterApp.njsj__1_,
  //     // image: MyImages.dash_line,
  //     mode: PaintMode.freeStyleWave,
  //     label: textDelegate.lateralSkatingStop),

  // ModeData(
  //     icon: Icons.text_format,
  //     mode: PaintMode.text,
  //     label: textDelegate.text),
  // ModeData(
  //     icon: CupertinoIcons.circle,
  //     mode: PaintMode.circle,
  //     label: textDelegate.circle),
  // ModeData(
  //     icon: CupertinoIcons.rectangle,
  //     mode: PaintMode.rect,
  //     label: textDelegate.rectangle),

];


List<ModeData> paintModes1(TextDelegate textDelegate) => [

  // ModeData(
  //     icon: Icons.text_format,
  //     mode: PaintMode.text,
  //     label: textDelegate.text),
  ModeData(
      icon: CupertinoIcons.circle,
      mode: PaintMode.circle,
      label: textDelegate.circle),
  ModeData(
      icon: CupertinoIcons.rectangle,
      mode: PaintMode.rect,
      label: textDelegate.rectangle),

  ModeData(
      icon: CupertinoIcons.circle_fill,
      mode: PaintMode.circleFill,
      label: textDelegate.circleOverlay),
  ModeData(
      icon: CupertinoIcons.rectangle_fill,
      mode: PaintMode.rectFill,
      label: textDelegate.rectangleOverlay),
];

@immutable
class ModeData1 {
  final IconData? icon;
  final String? image;
  final PaintMode? mode;
  final String? label;
  const ModeData1({
    this.icon,
    this.image,
    this.mode,
    this.label,
  });
}

class ModeData {
   IconData? icon;
   String? image;
   PaintMode? mode;
   String? label;
   ModeData({
       this.icon,
       this.image,
      this.mode,
      this.label,
  });
}

