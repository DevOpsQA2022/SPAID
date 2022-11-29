import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';

class EventCustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final Color? secondaryButton;
  final double? buttonHeight;

  EventCustomButton({
     this.onPressed,
    @required this.buttonText,
    this.textColor = MyColors.white,
    this.buttonColor = MyColors.kPrimaryColor,
    this.buttonHeight = Dimens.dp_50,
    this.secondaryButton = MyColors.kPrimaryLightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: Dimens.standard_200.widthPercentage(context),
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: buttonColor,foregroundColor: textColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.standard_10)),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(letterSpacing: Dimens.letterSpacing_25,fontSize: Dimens.standard_16),
        ),
      ),
    );
  }
}
