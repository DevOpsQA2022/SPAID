import 'package:flutter/material.dart';


class Navigation {


  static navigateTo(BuildContext context, String routePath) {
    Navigator.pushNamed(context, routePath );
  }

  static navigatesTo(BuildContext context, Function _createRoute) {
    Navigator.pushNamed(context, _createRoute());
  }

  static navigateToTransition(BuildContext context,SlideRightRoute,{String? routePath} ) {
    Navigator.pushNamed(context,  SlideRightRoute(page:routePath),);
  }

//   static navigateToTransition(BuildContext context,PageTransition,{Widget routePath} ) {
//   Navigator.pushNamed(context,   PageTransition(
//       type: PageTransitionType.rightToLeftWithFade, child: routePath));
// }

  // static navigateToTransition(BuildContext context,SlideRightRoute,{String routePath} ) {
  //   Navigator.pushNamed(context,   SlideRightRoute(page:routePath));
  // }



  static navigateAndFinish(BuildContext context, String routePath) {
    Navigator.pushReplacementNamed(context, routePath);
  }

  static navigatePushNamedAndRemoveAll(BuildContext context, String routePath) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(routePath, (Route<dynamic> route) => false);

  }

  static navigatePushNamedAndRemoveUntil(BuildContext context, {String? navigatePath,String? untilPath}) {
    Navigator.of(context).pushNamedAndRemoveUntil(navigatePath!, ModalRoute.withName(untilPath!));
  }

  static navigatePushNamedAndRemoveUntilWithArguments(BuildContext context, {String? navigatePath,String? untilPath,Object? data}) {
    Navigator.of(context).pushNamedAndRemoveUntil(navigatePath!, ModalRoute.withName(untilPath!),arguments: data);
  }

  static navigateWithArgument(
      BuildContext context, String route, Object data) {
    Navigator.pushNamed(context, route, arguments: data);
  }

  static finishAndNavigateWithArgument(
      BuildContext context, String route, Object data) {
    Navigator.pushReplacementNamed(context, route, arguments: data);
  }

}