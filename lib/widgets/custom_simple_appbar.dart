import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';

class CustomSimpleAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title, imageLeft, imageRight,tooltipMessageRight,tooltipMessageLeft;
  final VoidCallback? onClickRightImage;
  final bool? backFlag;
  final VoidCallback? onClickLeftImage;
  final Color? backGroundColor, imageLeftColor;
  final TextStyle? textStyle;
  final Widget? tabBar;
  final Icon? iconLeft;
  final Icon? iconRight;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final bool? removeArrow;

  CustomSimpleAppBar({
    this.title,
    this.imageLeft,
    this.imageRight,
    this.tooltipMessageLeft,
    this.tooltipMessageRight,
    this.onClickRightImage,
    this.backFlag = false,
    this.onClickLeftImage,
    this.backGroundColor,
    this.imageLeftColor,
    this.textStyle,
    this.tabBar,
    this.iconLeft,
    this.iconRight,
    this.bottom,
    this.elevation,
    this.removeArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      leadingWidth: 100,
      elevation: elevation == null ? Dimens.standard_5 : elevation,
      bottom: bottom,
      backgroundColor: backGroundColor == null ? MyColors.kPrimaryColor : backGroundColor,
      titleSpacing: removeArrow == false ? 10 : -30,
      leading:
      // getValueForScreenType<bool>(
      //   context: context,
      //   mobile: false,
      //   tablet: false,
      //   desktop: true,)? GestureDetector(
      //   onTap: (){
      //     Navigation.navigateTo(context, MyRoutes.homeScreen);
      //   },
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: new Image.asset(MyImages.spaid_logo,),
      //   ),
      // )
      /*CircleAvatar(
            backgroundColor: MyColors.white,
              radius: 10.0,
              child: GestureDetector(
                onTap: (){
                  Navigation.navigateTo(context, MyRoutes.homeScreen);

                },
                child: Image.asset(
                  MyImages.spaid_logo,

                ),
              )
          )*/Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          MyImages.spaid_logo,

        ),
      ),

     /* title: Text(
        title,
        style: textStyle == null
            ? TextStyle(
          color: MyColors.white,
          letterSpacing: Dimens.letterSpacing_15,
        )
            : textStyle,
      ),*/
      /*title:  Center(
        child: Row(
          children: [
            SizedBox(
              width: 750,
            ),
            InkWell(
              onTap: () => onClickLeftImage == null
                  ? Navigator.pop(context)
                  : onClickLeftImage(),
              child: Row(
                children: <Widget>[
                  iconLeft != null
                      ? Padding(
                      padding: EdgeInsets.only(left: Dimens.standard_28),
                      // child: Image.asset(
                      //   imageLeft == null ?MyImages.appLogo:imageLeft,
                      //   color: imageLeftColor == null?MyColors.white:imageLeftColor,
                      //   height: Dimens.standard_16,
                      //   width: Dimens.standard_16,
                      // ),
                      child: Icon(
                        iconLeft == null ? MyIcons.backwardArrow : iconLeft.icon,
                        color: imageLeftColor == null
                            ? MyColors.white
                            : imageLeftColor,
                      ))
                      : SizedBox()
                ],
              ),
            ),
            SizedBox(width: 20,),
            Text(
                title,
                style: textStyle == null
                    ? TextStyle(
                        color: MyColors.white,
                        letterSpacing: Dimens.letterSpacing_15,
                      )
                    : textStyle,
              ),
          ],
        ),
      ),
*/
      actions: [
        // imageRight == null?SizedBox() : InkWell(
        //   onTap: ()=>onClickRightImage==null?Navigator.pop(context):onClickRightImage(),
        //   child: Padding(
        //     padding: const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
        //     child: Image(
        //       image: AssetImage(imageRight),color: MyColors.white,
        //     ),
        //   ),
        // )
        // iconRight == null
        //     ? SizedBox()
        //     : InkWell(
        //   onTap: () => onClickRightImage == null
        //       ? Navigation.navigatePushNamedAndRemoveAll(
        //       context, MyRoutes.signIn)
        //       : onClickRightImage(),
        //   child: Padding(
        //       padding:
        //       const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
        //       child: Tooltip(
        //         message: "Logout",
        //         child: Icon(
        //           iconRight.icon,
        //           color: MyColors.white,
        //         ),
        //       )),
        // ),
      ],
      //bottom: tabBar != null ?tabBar : SizedBox(),
    );
  }

  @override
  // Size get preferredSize =>Size.fromHeight(kToolbarHeight);
  Size get preferredSize => tabBar != null
      ? Size.fromHeight(Dimens.standard_100)
      : Size.fromHeight(kToolbarHeight);
}
