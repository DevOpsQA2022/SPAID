import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/utils/extension.dart';

class FlatButtonCustom extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? textColor;
  final double? buttonHeight;

  FlatButtonCustom({
    @required this.onPressed,
    @required this.buttonText,
    this.textColor = MyColors.kPrimaryColor,
    this.buttonHeight = Dimens.dp_50,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.standard_100.widthPercentage(context),
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(foregroundColor:textColor ,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimens.standard_12)),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(letterSpacing: Dimens.letterSpacing_25),
        ),
      ),
    );
  }
}
