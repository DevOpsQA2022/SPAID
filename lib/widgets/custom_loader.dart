import 'package:flutter/material.dart';
import 'dart:math';

import 'package:spaid/support/colors.dart';
import 'package:spaid/support/images.dart';



class CustomLoader extends StatefulWidget {
  final Color? color1;

  const CustomLoader({Key? key,  this.color1= MyColors.kPrimaryColor}) : super(key: key);


  @override
  _ColorLoader2State createState() => _ColorLoader2State();
}

class _ColorLoader2State extends State<CustomLoader>
    with TickerProviderStateMixin {
  Animation<double>? animation1;
  AnimationController? controller1;

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);



    animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: controller1!, curve: const Interval(0.0, 1.0, curve: Curves.linear)));



    controller1!.repeat();

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
              radius: 25,
              backgroundColor: MyColors.white,
              child: Image.asset(MyImages.spaid_logo,
                width: 30,
                height: 40,
              )),
          RotationTransition(
            turns: animation1!,
            child: CustomPaint(
              painter: Arc1Painter(widget.color1!),
              child: Container(
                width: 50.0,
                height: 50.0,
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    controller1!.dispose();
    super.dispose();
  }
}

class Arc1Painter extends CustomPainter {
  final Color color;

  Arc1Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p1 = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect1 = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    canvas.drawArc(rect1, 0.0, 0.3 * pi, false, p1);
    canvas.drawArc(rect1, 0.6 * pi, 0.3 * pi, false, p1);
    canvas.drawArc(rect1, 1.3 * pi, 0.3 * pi, false, p1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc2Painter extends CustomPainter {
  final Color color;

  Arc2Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p2 = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect2 = Rect.fromLTWH(
        0.0 + (0.2 * size.width) / 2,
        0.0 + (0.2 * size.height) / 2,
        size.width - 0.2 * size.width,
        size.height - 0.2 * size.height);

    canvas.drawArc(rect2, 0.0, 0.5 * pi, false, p2);
    canvas.drawArc(rect2, 0.8 * pi, 0.6 * pi, false, p2);
    canvas.drawArc(rect2, 1.6 * pi, 0.2 * pi, false, p2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc3Painter extends CustomPainter {
  final Color color;

  Arc3Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint p3 = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect3 = Rect.fromLTWH(
        0.0 + (0.4 * size.width) / 2,
        0.0 + (0.4 * size.height) / 2,
        size.width - 0.4 * size.width,
        size.height - 0.4 * size.height);

    canvas.drawArc(rect3, 0.0, 0.9 * pi, false, p3);
    canvas.drawArc(rect3, 1.1 * pi, 0.8 * pi, false, p3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}