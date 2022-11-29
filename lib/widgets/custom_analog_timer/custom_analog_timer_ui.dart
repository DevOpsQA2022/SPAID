// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
// class OtpTimer extends StatefulWidget {
//   @override
//   _OtpTimerState createState() => _OtpTimerState();
// }
//
// class _OtpTimerState extends State<OtpTimer> {
//   final interval = const Duration(seconds: 1);
//
//   final int timerMaxSeconds = 60;
//
//   int currentSeconds = 0;
//
//   String get timerText =>
//       '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
//
//   startTimeout([int milliseconds]) {
//     var duration = interval;
//     Timer.periodic(duration, (timer) {
//       setState(() {
//         print(timer.tick);
//         currentSeconds = timer.tick;
//         if (timer.tick >= timerMaxSeconds) timer.cancel();
//       });
//     });
//   }
//
//   @override
//   void initState() {
//     startTimeout();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         Icon(Icons.timer),
//         SizedBox(
//           width: 5,
//         ),
//         Text(timerText)
//       ],
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/widgets/custom_analog_timer/custom_clock_painter.dart';
import 'package:spaid/widgets/custom_analog_timer/custom_dependencies.dart';
import 'package:spaid/widgets/custom_background/custom_background.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';



class MainScreenPortrait extends StatefulWidget {
  final Dependencies? dependencies;

  MainScreenPortrait({Key? key, this.dependencies}) : super(key: key);

  MainScreenPortraitState createState() => MainScreenPortraitState();
}

class MainScreenPortraitState extends State<MainScreenPortrait> {
  Icon? leftButtonIcon;
  Icon? rightButtonIcon;
  String? rightButtontext;
  String? leftButtontext;

  Color? leftButtonColor;
  Color? rightButtonColor;

  Timer? timer;
  bool _clicked = false;
  int slidechange = 0;

  updateTime(Timer timer) {
    if (widget.dependencies!.stopwatch.isRunning) {
      setState(() {});
    } else {
      timer.cancel();
    }
  }

  @override
  void initState() {
    if (widget.dependencies!.stopwatch.isRunning) {
      timer = new Timer.periodic(new Duration(milliseconds: 20), updateTime);
      leftButtonIcon = Icon(Icons.pause);
      leftButtonColor = MyColors.red;
      leftButtontext = MyStrings.pause;
      rightButtontext = MyStrings.lap;
      rightButtonIcon = Icon(
        Icons.timelapse_rounded,
        color: Colors.red,
      );
      rightButtonColor = Colors.white70;
    } else {
      leftButtonIcon = Icon(Icons.play_arrow);
      leftButtonColor = MyColors.green;
      rightButtonIcon = Icon(Icons.refresh);
      rightButtonColor = MyColors.blue;
      leftButtontext = MyStrings.start;
      rightButtontext = MyStrings.reset;
    }
    super.initState();
  }

  @override
  void dispose() {
    if (timer!.isActive) {
      timer!.cancel();
      timer = null;
    }
    super.dispose();
  }



  void changed() {
    setState(() {
      slidechange == 0 ? {TimerClocks(widget.dependencies!,slidechange) , slidechange = 1 }: slidechange = 0;
    });}
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final _screenSize = MediaQuery.of(context).size;
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

    GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () =>{
        changed(),
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          slidechange == 1 ?  IconButton(

            icon: new Icon(Icons.arrow_back_ios_outlined),
            tooltip: MyStrings.tooltipNavigation,
            onPressed:() =>{
              changed(),
            }, // null disables the button

          ) : SizedBox(),
          Container(

            height: 250.0,
            width: 250.0,
            child:  slidechange == 1 ? TimerClock(widget.dependencies!) : TimerClocks(widget.dependencies!,slidechange),
          ),
          slidechange == 0 ?  IconButton(

            icon: new Icon(Icons.arrow_forward_ios),
            tooltip: MyStrings.tooltipNavigation,
            onPressed:() =>{
              changed(),
            }, // null disables the button

          ) : SizedBox(),
        ],
      ),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        FloatingActionButton.extended(
            heroTag: "btn1",
            label: Text(leftButtontext!),
            backgroundColor: leftButtonColor,
            onPressed: startOrStopWatch,
            icon: leftButtonIcon) ,
        SizedBox(height: size.height * 0.03),
        FloatingActionButton.extended (
            heroTag: "btn2",
            label: Text(rightButtontext!),
            disabledElevation: 4,
            backgroundColor: rightButtonColor,
            onPressed: saveOrRefreshWatch,
            icon : rightButtonIcon),
      ],
    ),

    SizedBox(height: size.height * 0.03),
    // Expanded(
    //   child: ListView.builder(
    //       itemCount: widget.dependencies.savedTimeList.length,
    //       itemBuilder: (context, index) {
    //         return ListTile(
    //           title: Container(
    //               alignment: Alignment.center,
    //               child: Text(
    //                 createListItemText(
    //                     widget.dependencies.savedTimeList.length,
    //                     index,
    //                     widget.dependencies.savedTimeList.elementAt(index)),
    //                 style: TextStyle(fontSize: Dimens.standard_25),
    //               )),
    //         );
    //       }),
    // ),
    //Text('$savedTimeList')
          ],
        ),
      );
  }

  startOrStopWatch() {
    if (widget.dependencies!.stopwatch.isRunning) {
      leftButtonIcon = Icon(Icons.play_arrow);
      leftButtonColor = MyColors.green;
      leftButtontext = MyStrings.start;
      rightButtonIcon = Icon(Icons.refresh);
      rightButtonColor = MyColors.blue;
      rightButtontext =MyStrings.reset;
      widget.dependencies!.stopwatch.stop();
      setState(() {});
    } else {
      leftButtonIcon = Icon(Icons.pause);
      leftButtonColor = MyColors.red;
      leftButtontext = MyStrings.pause;
      rightButtonIcon = Icon(
        Icons.timelapse_rounded,
        color: MyColors.red,
      );
      rightButtontext = MyStrings.lap;
      rightButtonColor = Colors.white70;
      widget.dependencies!.stopwatch.start();
      timer = new Timer.periodic(new Duration(milliseconds: 20), updateTime);
    }
  }

  saveOrRefreshWatch() {
    setState(() {
      if (widget.dependencies!.stopwatch.isRunning) {
        widget.dependencies!.savedTimeList.insert(
            0,
            widget.dependencies!.transformMilliSecondsToString(
                widget.dependencies!.stopwatch.elapsedMilliseconds));
      } else {
        widget.dependencies!.stopwatch.reset();
        widget.dependencies!.savedTimeList.clear();
      }
    });
  }

  String createListItemText(int listSize, int index, String time) {
    index = listSize - index;
    String indexText = index.toString().padLeft(2, '0');

    return 'Time $indexText, $time';
  }
}










class TimerClock extends StatefulWidget {
  final Dependencies dependencies;

  TimerClock(this.dependencies,  {Key? key}) : super(key: key);

  TimerClockState createState() => TimerClockState();
}

class TimerClockState extends State<TimerClock> {
  CurrentTime? currentTime;


  Paint? paint;
  @override
  void initState() {
    paint = new Paint();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentTime = widget.dependencies.transformMilliSecondsToTime(
        widget.dependencies.stopwatch.elapsedMilliseconds);

    return CustomPaint(
          painter:  ClockPainter(
          lineColor: Colors.lightBlueAccent,
          completeColor: Colors.blueAccent,
          hundreds: currentTime!.hundreds,
          seconds: currentTime!.seconds,
          minutes: currentTime!.minutes,
          hours: currentTime!.hours,
          width: 4.0,
          linePaint: paint),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentTime!.hours.toString().padLeft(2, '0'),
              style: TextStyle(fontSize: Dimens.standard_25),
            ),
            Text(

              '${currentTime!.minutes.toString().padLeft(2, '0')} : ${currentTime!.seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: Dimens.standard_25),
            ),
            // Text(
            //   currentTime.hundreds.toString().padLeft(2, '0'),
            //   style: TextStyle(fontSize: 24.0),
            // )
          ],
        ),
      ),
    );

  }
}


class TimerClocks extends StatefulWidget {
  final Dependencies dependencies;
  int slidechange;
  TimerClocks(this.dependencies,this.slidechange,  {Key? key}) : super(key: key);

  TimerClocksState createState() => TimerClocksState(slidechange);
}

class TimerClocksState extends State<TimerClocks> {
  CurrentTime? currentTime;
  int slidechange;

  Paint? paint;
  TimerClocksState(this.slidechange);
  @override
  void initState() {
    paint = new Paint();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currentTime = widget.dependencies.transformMilliSecondsToTime(
        widget.dependencies.stopwatch.elapsedMilliseconds);

    return CustomPaint(

      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(3.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              '${currentTime!.hours.toString().padLeft(2, '0')} : ${currentTime!.minutes.toString().padLeft(2, '0')} : ',
              style: TextStyle(fontSize: Dimens.standard_35,color: MyColors.black),
            ),
            Text(
              '${currentTime!.seconds.toString().padLeft(2, '0')} ',
              style: TextStyle(fontSize: Dimens.standard_35,color: MyColors.black),
            ),
          ],
        ),
      ),
    );

  }
}
// class MainScreenLandscape extends StatefulWidget {
//   final Dependencies dependencies;
//
//   MainScreenLandscape({Key key, this.dependencies}) : super(key: key);
//
//   MainScreenLandscapeState createState() => MainScreenLandscapeState();
// }
//
// class MainScreenLandscapeState extends State<MainScreenLandscape> {
//   Icon leftButtonIcon;
//   Icon rightButtonIcon;
//
//   Color leftButtonColor;
//   Color rightButtonColor;
//
//   Timer timer;
//
//   updateTime(Timer timer) {
//     if (widget.dependencies.stopwatch.isRunning) {
//       setState(() {});
//     } else {
//       timer.cancel();
//     }
//   }
//
//   @override
//   void initState() {
//     if (widget.dependencies.stopwatch.isRunning) {
//       timer = new Timer.periodic(new Duration(milliseconds: 20), updateTime);
//       leftButtonIcon = Icon(Icons.pause);
//       leftButtonColor = Colors.red;
//       rightButtonIcon = Icon(
//         Icons.timelapse_rounded,
//         color: Colors.red,
//       );
//       rightButtonColor = Colors.white70;
//     } else {
//       leftButtonIcon = Icon(Icons.play_arrow);
//       leftButtonColor = Colors.green;
//       rightButtonIcon = Icon(Icons.refresh);
//       rightButtonColor = Colors.blue;
//     }
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     if (timer.isActive) {
//       timer.cancel();
//       timer = null;
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Container(
//           height: 250.0,
//           width: 250.0,
//           child: TimerClock(widget.dependencies),
//         ),
//         Expanded(
//           child: Container(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
//                     child: ListView.builder(
//                         itemCount: widget.dependencies.savedTimeList.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Container(
//                                 alignment: Alignment.center,
//                                 child: Text(
//                                   createListItemText(
//                                       widget.dependencies.savedTimeList.length,
//                                       index,
//                                       widget.dependencies.savedTimeList
//                                           .elementAt(index)),
//                                   style: TextStyle(fontSize: 24.0),
//                                 )),
//                           );
//                         }),
//                   ),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     FloatingActionButton(
//                         backgroundColor: leftButtonColor,
//                         onPressed: startOrStopWatch,
//                         child: leftButtonIcon),
//                     SizedBox(width: 20.0),
//                     FloatingActionButton(
//                         backgroundColor: rightButtonColor,
//                         onPressed: saveOrRefreshWatch,
//                         child: rightButtonIcon),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   startOrStopWatch() {
//     if (widget.dependencies.stopwatch.isRunning) {
//       leftButtonIcon = Icon(Icons.play_arrow);
//       leftButtonColor = Colors.green;
//       rightButtonIcon = Icon(Icons.refresh);
//       rightButtonColor = Colors.blue;
//       widget.dependencies.stopwatch.stop();
//       setState(() {});
//     } else {
//       leftButtonIcon = Icon(Icons.pause);
//       leftButtonColor = Colors.red;
//       rightButtonIcon = Icon(
//         Icons.timelapse_rounded,
//         color: Colors.red,
//       );
//       rightButtonColor = Colors.white70;
//       widget.dependencies.stopwatch.start();
//       timer = new Timer.periodic(new Duration(milliseconds: 20), updateTime);
//     }
//   }
//
//   saveOrRefreshWatch() {
//     setState(() {
//       if (widget.dependencies.stopwatch.isRunning) {
//         widget.dependencies.savedTimeList.insert(
//             0,
//             widget.dependencies.transformMilliSecondsToString(
//                 widget.dependencies.stopwatch.elapsedMilliseconds));
//       } else {
//         widget.dependencies.stopwatch.reset();
//         widget.dependencies.savedTimeList.clear();
//       }
//     });
//   }
//
//   String createListItemText(int listSize, int index, String time) {
//     index = listSize - index;
//     String indexText = index.toString().padLeft(2, '0');
//
//     return 'Time $indexText, $time';
//   }
// }
