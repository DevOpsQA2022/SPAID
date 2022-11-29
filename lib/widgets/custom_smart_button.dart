import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';

class SmallRaisedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final double? buttonHeight;
  final double? buttonWidth;

  SmallRaisedButton({
    @required this.onPressed,
    @required this.buttonText,
    this.textColor = MyColors.white,
    this.buttonColor = MyColors.kPrimaryColor,
    this.buttonHeight = Dimens.dp_20,
    this.buttonWidth,
  });

  @override
  _SmallRaisedButtonState createState() => _SmallRaisedButtonState();
}

class _SmallRaisedButtonState extends State<SmallRaisedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.buttonWidth == null ? 140 : widget.buttonWidth,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: widget.buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: Dimens.letterSpacing_25, color: MyColors.white,fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SmallRaisedButtonCard extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color textColor;
  final Color buttonColor;
  final double buttonHeight;

  SmallRaisedButtonCard({
    @required this.onPressed,
    @required this.buttonText,
    this.textColor = MyColors.white,
    this.buttonColor = MyColors.kPrimaryColor,
    this.buttonHeight = Dimens.dp_20,
  });

  @override
  _SmallRaisedButtonCardState createState() => _SmallRaisedButtonCardState();
}

class _SmallRaisedButtonCardState extends State<SmallRaisedButtonCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 30,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: widget.buttonColor, width: 2.0),
              borderRadius: BorderRadius.circular(5)),
        ),
        onPressed: widget.onPressed,
        child: Text(
          widget.buttonText!,
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: Dimens.letterSpacing_25,
              color: widget.buttonColor),
        ),
      ),
    );
  }
}
