import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/routes.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/utils/navigation.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String? title, imageLeft, imageRight, tooltipMessageRight, tooltipMessageLeft;
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
  final bool? leadingfalse;

  CustomAppBar({
    this.title,
    this.imageLeft,
    this.imageRight,
    this.tooltipMessageRight,
    this.tooltipMessageLeft,
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
    this.leadingfalse = false
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      centerTitle: false,
      titleSpacing: 0.0,
      elevation: elevation == null ? Dimens.standard_5 : elevation,
      bottom: bottom,
      backgroundColor: backGroundColor == null ? MyColors.kPrimaryColor : backGroundColor,
      // titleSpacing: removeArrow == false ? 10 : -30,
      leading: iconLeft != null?  InkWell(
        onTap: () => onClickLeftImage == null
            ? leadingfalse == false ? Navigator.pop(context) : null
            : onClickLeftImage!(),
        child: Row(
          children: <Widget>[
            iconLeft != null
                ? Padding(
                    padding: EdgeInsets.only(left: Dimens.standard_8),
                    // child: Image.asset(
                    //   imageLeft == null ?MyImages.appLogo:imageLeft,
                    //   color: imageLeftColor == null?MyColors.white:imageLeftColor,
                    //   height: Dimens.standard_16,
                    //   width: Dimens.standard_16,
                    // ),
                    child:Tooltip(
                      message: tooltipMessageLeft == null ?  MyStrings.back : tooltipMessageLeft,
                      child: Icon(
                        (iconLeft == null ? Icons.arrow_back_rounded : iconLeft!.icon),
                        color: imageLeftColor == null
                            ? MyColors.white
                            : imageLeftColor,),
                    ))
                : SizedBox()
          ],
        ),

      ):SizedBox(),
      title: Transform(
        // you can forcefully translate values left side using Transform
        transform:  removeArrow == true ? Matrix4.translationValues(-40.0, 0.0, 0.0) : Matrix4.translationValues(-20.0, 0.0, 0.0),
        child: Text(
          title!,
          style: textStyle == null
              ? TextStyle(
                  color: MyColors.white,

                  letterSpacing: Dimens.letterSpacing_15,
                )
              : textStyle,
        ),
      ),
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
        iconRight == null
            ? SizedBox()
            : InkWell(
                onTap: () => onClickRightImage == null
                    ? Navigation.navigatePushNamedAndRemoveAll(
                        context, MyRoutes.signIn)
                    : onClickRightImage!(),
                child: Padding(
                    padding:
                        const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                    child: Tooltip(
                      message: tooltipMessageRight == null ? MyStrings.save : tooltipMessageRight,
                      child: Icon(
                        iconRight!.icon,
                        color: MyColors.white,
                      ),
                    )),
              ),
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
