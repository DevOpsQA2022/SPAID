import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:spaid/support/constants.dart';


///Handles all the painting ongoing on the canvas.
class DrawImage extends CustomPainter {
  ///Converted image from [ImagePainter] constructor.
  final Image? image;

  ///Keeps track of all the units of [PaintHistory].
  final List<PaintInfo>? paintHistory;

  ///Keeps track of points on currently drawing state.
  final UpdatePoints? update;

  ///Keeps track of freestyle points on currently drawing state.
  final List<Offset>? points;
  List<Offset>? pointsx;
  List<Offset>? pointsy;

  ///Keeps track whether the paint action is running or not.
  final bool isDragging;

  ///Flag for triggering signature mode.
  final bool isSignature;

  ///The background for signature painting.
  final Color? backgroundColor;
  ///Constructor for the canvas
  DrawImage(
      {this.image,
        this.update,
        this.points,
        this.isDragging = false,
        this.isSignature = false,
        this.backgroundColor,
        this.paintHistory});

  // @override
  // bool? hitTest(Offset position) {
  //   for (var item in paintHistory!) {
  //     final _offset = item.offset;
  //     print(item.offset!.contains(position));
  //
  //   }
  //   print(position);
  //   return super.hitTest(position);
  // }


  @override
  void paint(Canvas canvas, Size size) {
    if (isSignature) {
      ///Paints background for signature.
      canvas.drawRect(
          Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = backgroundColor!);
    } else {
      ///paints [ui.Image] on the canvas for reference to draw over it.
      if(Constant.isImageSelected && points!.isNotEmpty) {
        // canvas.drawImage(image!, points![0]??const Offset(0, 0), new Paint());
        // paintImage(
        //   canvas: canvas,
        //   image: image!,
        //   filterQuality: FilterQuality.high,
        //   /* rect: Rect.fromPoints(
        //     points![0]??const Offset(0, 0),
        //     points![1]??Offset(size.width / 2, size.height / 2),
        //   ),*/
        //   rect: Rect.fromCenter(
        //     width: 7, center: points![0]??const Offset(0, 0), height: 7,
        //   ),
        //
        // );
        /* paintImage(
          canvas: canvas,
          image: image!,
          filterQuality: FilterQuality.high,
          *//* rect: Rect.fromPoints(
            points![0]??const Offset(0, 0),
            points![1]??Offset(size.width / 2, size.height / 2),
          ),*//*
          rect: Rect.fromCenter(
            width: 20, center:Offset(57.0, 72.0), height: 20,
          ),

        );*/
      }
    }

    ///paints all the previous paintInfo history recorded on [PaintHistory]
    for (var item in paintHistory!) {
      final _offset = item.offset;
      final _painter = item.painter;
      Offset _start, _end;
      switch (item.mode) {
        case PaintMode.rect:
          canvas.drawRect(Rect.fromPoints(_offset![0], _offset[1]), _painter!);
          break;
        case PaintMode.rectFill:
          final arrowPainter = Paint()
            ..color = _painter!.color;
          canvas.drawRect(Rect.fromPoints(_offset![0], _offset[1]), arrowPainter);
          break;
        case PaintMode.line:
          canvas.drawLine(_offset![0], _offset![1], _painter!);
          break;

        case PaintMode.circle:
          final path = Path();
          path.addOval(
            Rect.fromCircle(
                center: _offset![1],
                radius: (_offset[0] - _offset[1]).distance),
          );
          canvas.drawPath(path, _painter!);
          // final arrowPainter = Paint()
          //   ..color = Colors.grey;
          //
          // final path = Path();
          // path.addOval(
          //   Rect.fromCircle(
          //       center: _offset![1]!,
          //       radius: (_offset[0]! - _offset[1]!).distance),
          // );
          // canvas.drawPath(path, arrowPainter);
          break;
        case PaintMode.circleFill:

          final arrowPainter = Paint()
            ..color = _painter!.color;

          final path = Path();
          path.addOval(
            Rect.fromCircle(
                center: _offset![1],
                radius: (_offset[0] - _offset[1]).distance),
          );
          canvas.drawPath(path, arrowPainter);
          break;
        case PaintMode.triangle:

          final path = Path();

          path.addOval(
            Rect.fromCircle(

                center: _offset![1],
                radius: (_offset[0] - _offset[1]).distance),
          );
          canvas.drawPath(path, _painter!);
          break;
        case PaintMode.arrow:
        // drawFreeArrow(canvas, _offset![0]!, _offset[1]!, _painter!);
        // drawArrow(canvas, _offset![0]!, _offset[1]!, _painter!);
          paints(canvas,_offset![0], _offset[1], _painter!, size);
          break;

        case PaintMode.skateArrow:
        // drawFreeArrow(canvas, _offset![0]!, _offset[1]!, _painter!);
        // drawArrow(canvas, _offset![0]!, _offset[1]!, _painter!);
          paintss(canvas,_offset![0], _offset[1], _painter!, size);
          break;
        case PaintMode.dashLine:

          final path = Path()

            ..moveTo(_offset![0].dx, _offset[0].dy)
            ..lineTo(_offset[1].dx, _offset[1].dy);
          canvas.drawPath(_dashPath(path, _painter!.strokeWidth,), _painter);
          break;
        case PaintMode.dashLineArrow:
          final path = Path()

            ..moveTo(_offset![0].dx, _offset[0].dy)
            ..lineTo(_offset[1].dx, _offset[1].dy);
          paintsFreestyleArrow(canvas,_offset[0], _offset[1], _painter!, size);

          canvas.drawPath(_dashPath(path, _painter.strokeWidth,), _painter);

          break;
        case PaintMode.dashLineArrowStop:
          final path = Path()

            ..moveTo(_offset![0].dx, _offset[0].dy)
            ..lineTo(_offset[1].dx, _offset[1].dy);
          paintsFreestyleArrowStop(canvas,_offset[0], _offset[1], _painter!, size);

          canvas.drawPath(_dashPath(path, _painter.strokeWidth,), _painter);

          break;
        case PaintMode.freeStyle:
          for (var i = 0; i < _offset!.length - 1; i++) {
            if (_offset[i] != null && _offset[i + 1] != null) {
              final _path = Path()
                ..moveTo(_offset[i].dx, _offset[i].dy)
                ..lineTo(_offset[i + 1].dx, _offset[i + 1].dy);
              // canvas.drawPath(_dashPath(_path, _painter!.strokeWidth,), _painter);

              canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);

            } else if (_offset[i] != null && _offset[i + 1] == null) {
              canvas.drawPoints(PointMode.points, [_offset[i]],
                  _painter!..strokeCap = StrokeCap.round);
            }
          }
          break;
        case PaintMode.freeStyleWave:
          for (var i = 0; i < _offset!.length - 1; i++) {
            if (_offset[i] != null && _offset[i + 1] != null) {
              // canvas.translate(0, size.height / 2);
              // final Paint wavePainter = Paint()
              //   ..color = Color(0xFF1f58a1)
              //   ..strokeWidth = 8
              //   ..style = PaintingStyle.stroke;
              // double high = size.height;
              // double offset = size.width / 13;
              // Path path = Path()
              //   ..moveTo(0, 0)
              //   ..quadraticBezierTo(offset, -high / 3, 2 * offset, 0)
              //   ..quadraticBezierTo(4 * offset, high / 2, 5 * offset, 0)
              //   ..quadraticBezierTo(offset * 7, -high, offset * 8, 2)
              //   ..quadraticBezierTo(offset * 9, high / 2, offset * 11, 0)
              //   ..quadraticBezierTo(offset * 12, -high / 3, offset * 13, 0);
              // canvas.drawPath(path, wavePainter);
              final _path = Path()
                ..moveTo(_offset[i].dx, _offset[i].dy)
                ..lineTo(_offset[i + 1].dx, _offset[i + 1].dy);
              // canvas.drawPath(_dashPath(_path, _painter!.strokeWidth,), _painter);
              canvas.drawPath(_dashPathWave(_path, _painter!.strokeWidth,),  _painter);
              // canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);

            } else if (_offset[i] != null && _offset[i + 1] == null) {
              canvas.drawPoints(PointMode.points, [_offset[i]],
                  _painter!..strokeCap = StrokeCap.round);
            }
          }
          break;
        case PaintMode.freeStyleDashline:
          for (var i = 0; i < _offset!.length - 1; i++) {
            if (_offset[i] != null && _offset[i + 1] != null) {
              paintsFreestyleArrow(canvas,_offset[0], _offset[_offset.length - 2], _painter!, size);

              final _path = Path()
                ..moveTo(_offset[i].dx, _offset[i].dy)
                ..lineTo(_offset[i + 1].dx, _offset[i + 1].dy);
              canvas.drawPath(_dashPaths(_path, _painter.strokeWidth,),  _painter);


              // canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);

            } else if (_offset[i] != null && _offset[i + 1] == null) {
              canvas.drawPoints(PointMode.points, [_offset[i]],
                  _painter!..strokeWidth);
            }
          }
          break;
        case PaintMode.freeStyleLateralSkating:
          try {
            for (var i = 0; i < _offset!.length - 1; i=i+5) {
                        if (_offset[i] != null && _offset[i + 5] != null) {

                          final _path = Path()
                            ..moveTo(_offset[i].dx, _offset[i].dy)
                            ..lineTo(_offset[i + 5].dx, _offset[i + 5].dy);
                          canvas.drawPath(_lateralSkate(_path, _painter!.strokeWidth,),  _painter);
                          // DashedLine(
                          //   path: Path()..cubicTo(-40, 53, 14, 86, 61, 102),
                          //   color: Colors.red,
                          // );
                          paintsFreestyleArrow(canvas,_offset[_offset.length - 5], _offset[_offset.length - 2], _painter, size);

                          // canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);

                        } else if (_offset[i] != null && _offset[i + 5] == null) {
                          canvas.drawPoints(PointMode.points, [_offset[i]],
                              _painter!..strokeWidth);
                        }
                      }
          } catch (e) {
            print(e);
          }
          break;
        case PaintMode.freeStyleLateralSkatingStop:
          print(_offset.toString());
          try {
            for (var i = 0; i < _offset!.length - 1; i=i+5) {
                        if (_offset[i] != null && _offset[i + 5] != null) {

                          final _path = Path()
                            ..moveTo(_offset[i].dx, _offset[i].dy)
                            ..lineTo(_offset[i + 5].dx, _offset[i + 5].dy);
                          canvas.drawPath(_lateralSkateStop(_path, _painter!.strokeWidth,),  _painter);

                          paintsFreestyleArrowStop(canvas,_offset[_offset.length - 5], _offset[_offset.length - 2], _painter, size);

                          // canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);

                        } else if (_offset[i] != null && _offset[i + 5] == null) {
                          canvas.drawPoints(PointMode.points, [_offset[i]],
                              _painter!..strokeWidth);
                        }
                      }
          } catch (e) {
            print(e);
          }
          break;
        case PaintMode.freeStyleArrowStop:
          for (var i = 0; i < _offset!.length - 1; i++) {
            if (_offset[i] != null && _offset[i + 1] != null) {

              final _path = Path()
                ..moveTo(_offset[i].dx, _offset[i].dy)
                ..lineTo(_offset[i + 1].dx, _offset[i + 1].dy);
              canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);
              paintsFreestyleArrowStop(canvas,_offset[_offset.length - 5], _offset[_offset.length - 2], _painter, size);

            } else if (_offset[i] != null && _offset[i + 1] == null) {
              canvas.drawPoints(PointMode.points, [_offset[i]],
                  _painter!..strokeCap = StrokeCap.round);
            }
          }
          break;

        case PaintMode.freeStyleArrow:
          for (var i = 0; i < _offset!.length - 1; i++) {
            if (_offset[i] != null && _offset[i + 1] != null) {
              final _path = Path()
                ..moveTo(_offset[i].dx, _offset[i].dy)
                ..lineTo(_offset[i + 1].dx, _offset[i + 1].dy);
              canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);
              paintsFreestyleArrow(canvas,_offset[_offset.length - 5], _offset[_offset.length - 2], _painter, size);
            }
            else if (_offset[i] != null && _offset[i + 1] == null) {
              canvas.drawPoints(PointMode.points, [_offset[i]],
                  _painter!);
            }
          }
          break;
        case PaintMode.text:
          final textSpan = TextSpan(
            text: item.text,
            style: TextStyle(
                color: _painter!.color,
                fontSize: 6 * _painter.strokeWidth,
                fontWeight: FontWeight.bold),
          );
          final textPainter = TextPainter(
            text: textSpan,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
          textPainter.layout(minWidth: 0, maxWidth: size.width);
          final textOffset = _offset!.isEmpty
              ? Offset(size.width / 2 - textPainter.width / 2,
              size.height / 2 - textPainter.height / 2)
              : Offset(_offset[0].dx - textPainter.width / 2,
              _offset[0].dy - textPainter.height / 2);
          textPainter.paint(canvas, textOffset);
          break;
        default:
          if(item.offset != null &&item.offset!.isNotEmpty && item.isImageSelected!) {
            paintImage(
              canvas: canvas,
              image: item.imageData!,
              filterQuality: FilterQuality.high,
              rect: Rect.fromCenter(
                width: 7, center: item.offset![0] ?? const Offset(0, 0), height: 7,
              ),

            );
          }
          // if(item.offset != null &&item.offset!.isNotEmpty && item.isImageSelected!){
          //   /*final path = Path()
          //     ..moveTo(_offset![0]!.dx, _offset[0]!.dy)
          //     ..lineTo(_offset[1]!.dx, _offset[1]!.dy);
          //   _dashPathImage(path,8.0 ,canvas,item);*/
          //   for (var i = 0; i < _offset!.length - 1; i++) {
          //     if (_offset[i] != null && _offset[i + 1] != null) {
          //         paintImage(
          //           canvas: canvas,
          //           image: item.imageData!,
          //           filterQuality: FilterQuality.high,
          //           rect: Rect.fromCenter(
          //             width: 7, center: item.offset![i] ?? const Offset(0, 0), height: 7,
          //           ),
          //
          //         );
          //       // final _path = Path()
          //       //   ..moveTo(_offset[i]!.dx, _offset[i]!.dy)
          //       //   ..lineTo(_offset[i + 1]!.dx, _offset[i + 1]!.dy);
          //       // // canvas.drawPath(_dashPath(_path, _painter!.strokeWidth,), _painter);
          //       //
          //       // canvas.drawPath(_path, _painter!..strokeCap = StrokeCap.round);
          //
          //     } else if (_offset[i] != null && _offset[i + 1] == null) {
          //     /*  canvas.drawPoints(PointMode.points, [_offset[i]!],
          //           _painter!..strokeCap = StrokeCap.round);*/
          //     }
          //   }
          // }
      }
    }

    ///Draws ongoing action on the canvas while indrag.
    if (isDragging && !Constant.isImageSelected) {
      final _start = update!.start;
      final _end = update!.end;
      final _painter = update!.painter;
      switch (update!.mode) {
        case PaintMode.rect:
          canvas.drawRect(Rect.fromPoints(_start!, _end!), _painter!);
          break;
        case PaintMode.rectFill:
          final arrowPainter = Paint()
            ..color = _painter!.color;
          canvas.drawRect(Rect.fromPoints(_start!, _end!), arrowPainter);
          break;
        case PaintMode.line:
          canvas.drawLine(_start!, _end!, _painter!);
          break;
        case PaintMode.circle:
          final path = Path();
          path.addOval(Rect.fromCircle(
              center: _end!, radius: (_end - _start!).distance));
          canvas.drawPath(path, _painter!);
          // final arrowPainter = Paint()
          //   ..color = Colors.grey;
          // final path = Path();
          // path.addOval(Rect.fromCircle(
          //     center: _end!, radius: (_end - _start!).distance));
          // canvas.drawPath(path, arrowPainter);
          break;
        case PaintMode.circleFill:

          final arrowPainter = Paint()
            ..color = _painter!.color;
          final path = Path();
          path.addOval(Rect.fromCircle(
              center: _end!, radius: (_end - _start!).distance));
          canvas.drawPath(path, arrowPainter);
          break;
        case PaintMode.triangle:
            final paint = Paint()
              ..color = Colors.grey
              ..strokeWidth = 10
              ..style = PaintingStyle.stroke;

            final path = Path();
            path.moveTo(size.width * 1 / 2, size.height * 1 / 4);
            path.lineTo(size.width * 1 / 6, size.height * 3 / 4);
            path.lineTo(size.width * 5 / 6, size.height * 3 / 4);
            path.close();

            canvas.drawPath(path, paint);

          break;

        case PaintMode.arrow:

        // drawFreeArrow(canvas, _start!, _end!, _painter!);

        // drawArrow(canvas, _start!, _end!, _painter!);
          paints(canvas,_start!, _end!, _painter!, size);

          break;
        case PaintMode.skateArrow:

        // drawFreeArrow(canvas, _start!, _end!, _painter!);

        // drawArrow(canvas, _start!, _end!, _painter!);
          paintss(canvas,_start!, _end!, _painter!, size);

          break;
        case PaintMode.freeStyle:
          for (var i = 0; i < points!.length - 1; i++) {
            if (points![i] != null && points![i + 1] != null) {

              canvas.drawLine(
                  Offset(points![i].dx, points![i].dy),
                  Offset(points![i + 1].dx, points![i + 1].dy),
                  _painter!..strokeCap = StrokeCap.round);

            } else if (points![i] != null && points![i + 1] == null) {
              canvas.drawPoints(PointMode.points,
                  [Offset(points![i].dx, points![i].dy)], _painter!);
            }
          }
          break;
        case PaintMode.freeStyleWave:
          for (var i = 0; i < points!.length - 1; i++) {
            if (points![i] != null && points![i + 1] != null) {
              // canvas.translate(0, size.height / 2);
              // final Paint wavePainter = Paint()
              //   ..color = Color(0xFF1f58a1)
              //   ..strokeWidth = 8
              //   ..style = PaintingStyle.stroke;
              // double high = size.height;
              // double offset = size.width / 13;
              // Path path = Path()
              //   ..moveTo(0, 0)
              //   ..quadraticBezierTo(offset, -high / 3, 2 * offset, 0)
              //   ..quadraticBezierTo(4 * offset, high / 2, 5 * offset, 0)
              //   ..quadraticBezierTo(offset * 7, -high, offset * 8, 2)
              //   ..quadraticBezierTo(offset * 9, high / 2, offset * 11, 0)
              //   ..quadraticBezierTo(offset * 12, -high / 3, offset * 13, 0);
              // canvas.drawPath(path, wavePainter);
              canvas.drawLine(
                  Offset(points![i].dx, points![i].dy),
                  Offset(points![i + 1].dx, points![i + 1].dy),
                  _painter!..strokeCap = StrokeCap.round);

            } else if (points![i] != null && points![i + 1] == null) {
              canvas.drawPoints(PointMode.points,
                  [Offset(points![i].dx, points![i].dy)], _painter!);
            }
          }
          break;
        case PaintMode.dashLine:
          final path = Path()
            ..moveTo(_start!.dx, _start.dy)
            ..lineTo(_end!.dx, _end.dy);

          // ..relativeLineTo(_start!.dx, _end.dy);
          canvas.drawPath(_dashPath(path, _painter!.strokeWidth,), _painter);
          break;
        case PaintMode.dashLineArrow:
          final path = Path()
            ..moveTo(_start!.dx, _start.dy)
            ..lineTo(_end!.dx, _end.dy);
          paintsFreestyleArrow(canvas,_start, _end, _painter!, size);

          // ..relativeLineTo(_start!.dx, _end.dy);
          canvas.drawPath(_dashPath(path, _painter.strokeWidth,), _painter);
          break;

        case PaintMode.dashLineArrowStop:
          final path = Path()
            ..moveTo(_start!.dx, _start.dy)
            ..lineTo(_end!.dx, _end.dy);
          paintsFreestyleArrowStop(canvas,_start, _end, _painter!, size);
          // ..relativeLineTo(_start!.dx, _end.dy);
          canvas.drawPath(_dashPath(path, _painter.strokeWidth,), _painter);
          break;
        case PaintMode.freeStyleArrowStop:
          for (var i = 0; i < points!.length - 1; i++) {
            if (points![i] != null && points![i + 1] != null) {

              final path = Path()
                ..moveTo(_start!.dx, _start.dy)
                ..lineTo(_end!.dx, _end.dy);

              canvas.drawLine(
                  Offset(points![i].dx, points![i].dy),
                  Offset(points![i + 1].dx, points![i + 1].dy),
                  _painter!..strokeCap = StrokeCap.round);
              paintsFreestyleArrowStop(canvas,points![points!.length-5], _end, _painter, size);

            } else if (points![i] != null && points![i + 1] == null) {
              canvas.drawPoints(PointMode.points,
                  [Offset(points![i].dx, points![i].dy)], _painter!);
            }
          }
          break;
        case PaintMode.freeStyleArrow:
          for (var i = 0; i < points!.length - 1; i++) {
            if (points![i] != null && points![i + 1] != null) {

              canvas.drawLine(
                  Offset(points![i].dx, points![i].dy),
                  Offset(points![i + 1].dx, points![i + 1].dy),
                  _painter!..strokeCap = StrokeCap.round);
              paintsFreestyleArrow(canvas,points![points!.length-5], _end!, _painter, size);

            } else if (points![i] != null && points![i + 1] == null) {
              canvas.drawPoints(PointMode.points,
                  [Offset(points![i].dx, points![i].dy)], _painter!);
            }
          }
          break;
        case PaintMode.freeStyleDashline:

          for (var i = 0; i < points!.length - 1; i++) {
            if (points![i] != null && points![i + 1] != null) {

              paintsFreestyleArrow(canvas,_start!, _end!, _painter!, size);

              final path = Path()
                ..moveTo(points![i].dx, points![i].dy)
                ..lineTo(points![i + 1].dx, points![i + 1].dy);
              canvas.drawPath(_dashPaths(path, _painter.strokeWidth,),  _painter..strokeCap = StrokeCap.round);
              // canvas.drawLine(
              //
              //     Offset(points![i]!.dx, points![i]!.dy),
              //     Offset(points![i + 1]!.dx, points![i + 1]!.dy),
              //     _painter!..strokeCap = StrokeCap.round);


            } else if (points![i] != null && points![i + 1] == null) {
              canvas.drawPoints(PointMode.points,
                  [Offset(points![i].dx, points![i].dy)], _painter!);
            }
          }
          break;
        case PaintMode.freeStyleLateralSkating:

          try {
            for (var i = 0; i < points!.length - 1; i=i+5) {
                        if (points![i] != null && points![i + 5] != null) {

                          paintsFreestyleArrow(canvas,points![points!.length-5], _end!, _painter!, size);
                          // for (double i = -300; i < 300; i = i + 15) {
                          //   // 15 is space between dots
                          //   if (i % 3 == 0)
                          //     canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _painter);
                          // }
                          final path = Path()
                            ..moveTo(points![i].dx, points![i].dy)
                            ..lineTo(points![i + 5].dx, points![i + 5].dy);
                          canvas.drawPath(_lateralSkate(path, _painter.strokeWidth,),  _painter);
                          // canvas.drawLine(
                          //
                          //     Offset(points![i]!.dx, points![i]!.dy),
                          //     Offset(points![i + 1]!.dx, points![i + 1]!.dy),
                          //     _painter!..strokeCap = StrokeCap.round);


                        }
                        else if (points![i] != null && points![i + 5] == null) {
                          canvas.drawPoints(PointMode.points,
                              [Offset(points![i].dx, points![i].dy)], _painter!);
                        }
                      }
          } catch (e) {
            print(e);
          }
          break;
        case PaintMode.freeStyleLateralSkatingStop:

          try {
            for (var i = 0; i < points!.length - 1; i=i+5) {
                        if (points![i] != null && points![i + 5] != null) {

                          paintsFreestyleArrowStop(canvas,points![points!.length-5], _end!, _painter!, size);
                          final path = Path()
                            ..moveTo(points![i].dx, points![i].dy)
                            ..lineTo(points![i + 5].dx, points![i + 5].dy);
                          canvas.drawPath(_lateralSkateStop(path, _painter.strokeWidth,),  _painter);
                          // canvas.drawLine(
                          //
                          //     Offset(points![i]!.dx, points![i]!.dy),
                          //     Offset(points![i + 1]!.dx, points![i + 1]!.dy),
                          //     _painter!..strokeCap = StrokeCap.round);


                        } else if (points![i] != null && points![i + 5] == null) {
                          canvas.drawPoints(PointMode.points,
                              [Offset(points![i].dx, points![i].dy)], _painter!);
                        }
                      }
          } catch (e) {
            print(e);
          }
          break;

        default:
      }
    }

    ///Draws all the completed actions of painting on the canvas.
  }

  ///Draws line as well as the arrowhead on top of it.
  ///Uses [strokeWidth] of the painter for sizing.
  // void drawArrow(Canvas canvas, Offset start, Offset end, Paint painter, Size size) {
  //   final arrowPainter = Paint()
  //     ..color = painter.color
  //     ..strokeWidth = painter.strokeWidth
  //     ..style = PaintingStyle.stroke;
  //   canvas.drawLine(start, end, painter);
  //   final _pathOffset = painter.strokeWidth / 15;
  //
  //   var path = Path()
  //     ..moveTo(size.width*0.5487500,size.height*0.3380000)
  //     ..lineTo(size.width*0.5987500,size.height*0.4200000)
  //
  //     ..close();
  //
  //   canvas.save();
  //   canvas.translate(end.dx, end.dy);
  //   canvas.rotate((end - start).direction);
  //   canvas.drawPath(path, arrowPainter);
  //   canvas.restore();
  // }

  void drawFreeArrow(Canvas canvas, Offset start, Offset end, Paint painter) {
    final arrowPainter = Paint()
      ..color = painter.color
      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;
    final _path = Path();
    _path.moveTo(420, 300);
    _path.lineTo(430, 300);
    _path.lineTo(420, 310);
    _path.lineTo(410, 300);
    _path.close();
    canvas.drawPath(_path, painter);
    final _pathOffset = painter.strokeWidth / 15;
    var path = Path()
      ..lineTo(-15 * _pathOffset, 10 * _pathOffset)
      ..lineTo(-15 * _pathOffset, -10 * _pathOffset)
      ..close();

    canvas.save();
    canvas.translate(end.dx, end.dy);
    canvas.rotate((end - start).direction);
    canvas.drawPath(path, arrowPainter);
    canvas.restore();
  }


  void drawArrow(Canvas canvas, Offset start, Offset end, Paint painter) {
    final arrowPainter = Paint()
      ..color = painter.color
      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start,end, painter);
    final _pathOffset = painter.strokeWidth / 15;
    var path = Path()
      ..lineTo(-15 * _pathOffset, 10 * _pathOffset)
      ..lineTo(-15 * _pathOffset, -10 * _pathOffset)
      ..close();

    canvas.save();
    canvas.translate(end.dx, end.dy);
    canvas.rotate((end - start).direction);
    canvas.drawPath(path, arrowPainter);
    canvas.restore();
  }

  void drawArrows(Canvas canvas, Offset start, Offset end, Paint painter, Size size) {
    final arrowPainter = Paint()
      ..color = painter.color
      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, end, painter);


    // final _pathOffset = painter.strokeWidth / 15;
    // var path = Path()
    //   ..lineTo(-15 * _pathOffset, 10 * _pathOffset)
    //   ..lineTo(-15 * _pathOffset, -10 * _pathOffset)
    //   ..close();

    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(size.width*0.5627500,size.height*0.4952000);
    path0.lineTo(size.width*0.5632500,size.height*0.4008000);
    path0.lineTo(size.width*0.4990000,size.height*0.3992000);
    canvas.drawPath(path0, paint0);

    Paint paint1 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;


    Path path1 = Path();
    path1.moveTo(size.width*0.5487500,size.height*0.3380000);
    path1.lineTo(size.width*0.5987500,size.height*0.4200000);
    canvas.save();
    canvas.translate(end.dx, end.dy);
    canvas.rotate((end - start).direction);
    canvas.drawPath(path1,paint1, );
    canvas.restore();


  }
  void paints(Canvas canvas, Offset start, Offset end, Paint painter, Size size) {

    final arrowPainter = Paint()
      ..color = painter.color

      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;
    // Paint paint0 = Paint()
    //   ..color = painter.color
    //   ..strokeWidth = painter.strokeWidth
    //   ..style = PaintingStyle.stroke;
    final _pathOffset = painter.strokeWidth / 15;
    var path = Path()

    // ..moveTo(size.width*0.5627500,size.height*0.4952000)
      ..lineTo(-15 * _pathOffset, 10 * _pathOffset)
      ..lineTo(-15 * _pathOffset, -10 * _pathOffset)
      ..close();


    canvas.drawLine(start, end, painter);

    Paint paint1 = Paint()
      ..color = painter.color
      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;

    Path path1 = Path();
    path1.moveTo(-15*0.5887500,10*0.3380000);
    path1.lineTo(-15*0.5987500,-10*0.4200000);

    Path path2 = Path();
    path2.moveTo(-15*0.5887500,10*0.3380000);
    path2.lineTo(-15*0.5987500,-10*0.4200000);
    //
    //
    // final Path intersection = Path.combine(PathOperation.union, path, path1);


    canvas.save();

    canvas.translate(end.dx, end.dy);

    canvas.rotate((end - start).direction);

    path.addPath(path1, Offset(11, 0));
    path.addPath(path2, Offset(13, 0));


    // canvas.drawPath(path1, paint1,);

    canvas.drawPath(path, arrowPainter);

    canvas.restore();

  }

  void paintss(Canvas canvas, Offset start, Offset end, Paint painter, Size size) {

    final arrowPainter = Paint()
      ..color = painter.color

      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;
    // Paint paint0 = Paint()
    //   ..color = painter.color
    //   ..strokeWidth = painter.strokeWidth
    //   ..style = PaintingStyle.stroke;
    final _pathOffset = painter.strokeWidth / 15;
    var path = Path()

    // ..moveTo(size.width*0.5627500,size.height*0.4952000)
      ..lineTo(-15 * _pathOffset, 10 * _pathOffset)
      ..lineTo(-15 * _pathOffset, -10 * _pathOffset)
      ..close();


    canvas.drawLine(start, end, painter);

    Paint paint1 = Paint()
      ..color = painter.color
      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;

    Path path1 = Path();
    path1.moveTo(-15*0.5887500,10*0.3380000);
    path1.lineTo(-15*0.5987500,-10*0.4200000);

    Path path2 = Path();
    path2.moveTo(-15*0.5887500,10*0.3380000);
    path2.lineTo(-15*0.5987500,-10*0.4200000);
    //
    //
    // final Path intersection = Path.combine(PathOperation.union, path, path1);


    canvas.save();

    canvas.translate(end.dx, end.dy);

    canvas.rotate((end - start).direction);

    // path.addPath(path1, Offset(11, 0));
    // path.addPath(path2, Offset(13, 0));


    // canvas.drawPath(path1, paint1,);

    canvas.drawPath(path, arrowPainter);

    canvas.restore();

  }

  void paintsFreestyleArrow(Canvas canvas, Offset start, Offset end, Paint painter, Size size) {

    final arrowPainter = Paint()
      ..color = painter.color

      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;
    // Paint paint0 = Paint()
    //   ..color = painter.color
    //   ..strokeWidth = painter.strokeWidth
    //   ..style = PaintingStyle.stroke;
    final paths = Path()
      ..moveTo(start.dx, start.dy)
      ..lineTo(end.dx, end.dy);

    // ..relativeLineTo(_start!.dx, _end.dy);
    // canvas.drawPath(_dashPath(paths, painter!.strokeWidth,), painter);
    final _pathOffset = painter.strokeWidth / 16;
    var path = Path()

    // ..moveTo(size.width*0.5627500,size.height*0.4952000)
      ..lineTo(-27 * _pathOffset, 17 * _pathOffset)
      ..lineTo(-27 * _pathOffset, -17 * _pathOffset)
      ..close();

    // canvas.drawLine(start, end, painter);
    Paint paint1 = Paint()
      ..color = painter.color
      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;

    Path path1 = Path();
    path1.moveTo(-15*0.5887500,10*0.3380000);
    path1.lineTo(-15*0.5987500,-10*0.4200000);

    Path path2 = Path();
    path2.moveTo(-15*0.5887500,10*0.3380000);
    path2.lineTo(-15*0.5987500,-10*0.4200000);
    //
    //
    // final Path intersection = Path.combine(PathOperation.union, path, path1);


    canvas.save();
    // rotate(
    //     canvas: canvas,
    //     cx: image!.width.toDouble() / 2,
    //     cy: image!.height.toDouble() / 2,
    //     angle: -0.3);
    canvas.translate(end.dx, end.dy);
    canvas.rotate((end - start).direction,);

    // rotate the canvas

    // path.addPath(path1, Offset(11, 0));
    // path.addPath(path2, Offset(13, 0));

    // canvas.drawPath(path1, paint1,);

    canvas.drawPath(path, arrowPainter);

    canvas.restore();

  }
  void paintsFreestyleArrowStop(Canvas canvas, Offset start, Offset end, Paint painter, Size size) {

    final arrowPainter = Paint()
      ..color = painter.color

      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;
    // Paint paint0 = Paint()
    //   ..color = painter.color
    //   ..strokeWidth = painter.strokeWidth
    //   ..style = PaintingStyle.stroke;
    final _pathOffset = painter.strokeWidth / 15;
    var path = Path()

    // ..moveTo(size.width*0.5627500,size.height*0.4952000)
      ..lineTo(-15 * _pathOffset, 10 * _pathOffset)
      ..lineTo(-15 * _pathOffset, -10 * _pathOffset)
      ..close();

    // canvas.drawLine(start, end, painter);


    Paint paint1 = Paint()
      ..color = painter.color
      ..strokeWidth = painter.strokeWidth
      ..style = PaintingStyle.stroke;

    Path path1 = Path();
    path1.moveTo(-15*0.5887500,10*0.3380000);
    path1.lineTo(-15*0.5987500,-10*0.4200000);

    Path path2 = Path();
    path2.moveTo(-15*0.5887500,10*0.3380000);
    path2.lineTo(-15*0.5987500,-10*0.4200000);
    //
    //
    // final Path intersection = Path.combine(PathOperation.union, path, path1);


    canvas.save();

    canvas.translate(end.dx, end.dy);
    print(end.toString());
    print("Marlen");
    print((end - start));
    print((end - start).direction);

    canvas.rotate((end - start).direction);

    path.addPath(path1, Offset(11, 0));
    path.addPath(path2, Offset(13, 0));

    // canvas.drawPath(path1, paint1,);

    canvas.drawPath(path, arrowPainter);

    canvas.restore();

  }

  ///Draws dashed path.
  ///It depends on [strokeWidth] for space to line proportion.
  Path _dashPath(Path path, double width, ) {
    final dashPath = Path();
    final dashWidth = 20.0 * width / 5;
    final dashSpace = 20.0 * width / 5;
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth,),

          Offset.zero,
        );


        distance += dashWidth;
        distance += dashSpace;


      }
    }
    return dashPath;
  }
  Path _dashPathImage(Path path, double width, Canvas canvas, PaintInfo item, ) {
    final dashPath = Path();
    final dashWidth = 20.0 * width / 5;
    final dashSpace = 20.0 * width / 5;
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth,),

          Offset.zero,
        );
        paintImage(
          canvas: canvas,
          image: item.imageData!,
          filterQuality: FilterQuality.high,
          rect: dashPath.getBounds(),

        );


        distance += dashWidth;
        distance += dashSpace;


      }
    }
    return dashPath;
  }
  Path _dashPathWave(Path path,  width, ) {
    final dashPath = Path();
    final dashWidth = 10.0 * width / 5;
    final dashSpace = 20.0 * width / 5;
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth,),

          Offset.zero,
        );


        distance += dashWidth;
        distance += dashSpace;


      }
    }
    return dashPath;
  }
  Path _dashPaths(Path path,  width, ) {
    final dashPath = Path();
    final dashWidth = 10.0 * width / 5;
    final dashSpace = 20.0 * width / 5;
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth,),

          Offset.zero,
        );


        distance += dashWidth;
        distance += dashSpace;


      }
    }
    return dashPath;
  }
  Path _lateralSkate(Path path, double width, ) {
    final dashPath = Path();
    final dashWidth = 22.0 * width / 35;
    final dashSpace = 30.0 * width / 15;
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth,),

          Offset.zero,
        );

        distance += dashWidth;
        distance += dashSpace;

      }
    }
    return dashPath;
  }
  Path _lateralSkateStop(Path path, double width, ) {
    final dashPath = Path();
    final dashWidth = 22.0 * width / 35;
    final dashSpace = 30.0 * width / 15;
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth,),

          Offset.zero,
        );


        distance += dashWidth;
        distance += dashSpace;


      }
    }
    return dashPath;
  }


  Path _dashPathsss(Path path, double width, ) {
    final dashPath = Path();
    final dashWidth = 2.0 * width / 10;
    final dashSpace = 40.0 * width / 10;
    var distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth,),

          Offset.zero,
        );


        distance += dashWidth;
        distance += dashSpace;


      }
    }
    return dashPath;
  }

  @override
  bool shouldRepaint(DrawImage oldInfo) {
    return (oldInfo.update != update ||
        oldInfo.paintHistory!.length == paintHistory!.length);
  }
}

void rotate(
    { Canvas? canvas,
       double? cx,
       double? cy,
       double? angle}) {
  canvas!.translate(cx!, cy!);
  canvas!.rotate(angle!);
  canvas!.translate(-cx, -cy);
}

///All the paint method available for use.

enum PaintMode {
  ///Prefer using [None] while doing scaling operations.
  none,

  ///Allows for drawing freehand shapes or text.
  freeStyle,

  ///Allows to draw line between two points.
  line,

  ///Allows to draw rectangle.
  rect,
  rectFill,

  ///Allows to write texts over an image.
  text,

  ///Allows us to draw line with arrow at the end point.
  arrow,

  skateArrow,


  ///Allows to draw circle from a point.
  circle,
  circleFill,

  triangle,
  triangleFill,

  ///Allows to draw dashed line between two point.
  dashLine,

  dashLineArrow,

  dashLineArrowStop,

  freeStyleArrow,

  freeStyleArrowStop,

  freeStyleDashline,

  freeStyleLateralSkating,

  freeStyleLateralSkatingStop,

  freeStyleWave,

}


class ImagesInfo {

  String? image;
  String? name;
  Icon? icon;

  ImagesInfo({ this.image,  this.name,this.icon});
}

///[PaintInfo] keeps track of a single unit of shape, whichever selected.
class PaintInfo {
  ///Mode of the paint method.
  PaintMode? mode;

  ///Used to save specific paint utils used for the specific shape.
  Paint? painter;

  ///Used to save offsets.
  ///Two point in case of other shapes and list of points for [FreeStyle].
  List<Offset>? offset;

  ///Used to save text in case of text type.
  String? text;

  bool? isImage=false;
  bool? isImageSelected=false;

  String? image="";
  ui.Image? imageData;
  String? fromImage;
  String? id;
  String? color;
  double? strokeWidth;
  String? style;


  ///In case of string, it is used to save string value entered.
  PaintInfo({this.offset, this.painter, this.text, this.mode, this.isImage, this.image,this.fromImage,this.imageData,this.isImageSelected,this.id,this.color,this.strokeWidth,this.style});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['FromImage'] = this.fromImage;
    //data['ImageData'] = this.imageData;
    data['Image'] = this.image;
    data['IsImageSelected'] = this.isImageSelected;
    data['IsImage'] = this.isImage;
    data['Text'] = this.text;
    data['Painter'] = this.painter.toString();
    data['Mode'] = this.mode.toString();
    data['Color'] = this.color.toString();
    data['StrokeWidth'] = this.strokeWidth.toString();
    data['Style'] = this.style.toString();
    if (this.offset != null) {
      data['Offset'] =
          this.offset!.map((v) => [v.dx,v.dy]).toList();
    }
    return data;
  }
}

@immutable

///Records realtime updates of ongoing [PaintInfo] when inDrag.
class UpdatePoints {
  ///Records the first tap offset,
  final Offset? start;

  ///Records all the offset after first one.
  final Offset? end;

  ///Records [Paint] method of the ongoing painting.
  final Paint? painter;

  ///Records [PaintMode] of the ongoing painting.
  final PaintMode? mode;

  ///Constructor for ongoing painthistory.
  UpdatePoints({this.start, this.end, this.painter, this.mode});

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UpdatePoints &&
        o.start == start &&
        o.end == end &&
        o.painter == painter &&
        o.mode == mode;
  }

  @override
  int get hashCode {
    return start.hashCode ^ end.hashCode ^ painter.hashCode ^ mode.hashCode;
  }
}
