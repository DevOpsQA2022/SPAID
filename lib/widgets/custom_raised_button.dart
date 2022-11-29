import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/style_sizes.dart';

class RaisedButtonCustom extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final Color? splashColor;
  final Color? disableColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final Icon? icon;

  RaisedButtonCustom(
      {Key? key,
        @required this.onPressed,
      @required this.buttonText,
      this.splashColor,
      this.textColor,
      this.disableColor,
      this.buttonColor,
      this.buttonHeight,
      this.buttonWidth,
      this.icon});

  @override
  _RaisedButtonCustomState createState() => _RaisedButtonCustomState();
}

class _RaisedButtonCustomState extends State<RaisedButtonCustom> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.symmetric(vertical: 5),
      width: widget.buttonWidth == null ? size.width * 0.9 : widget.buttonWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          key: widget.key,
          style: ElevatedButton.styleFrom(backgroundColor: widget.buttonColor,disabledBackgroundColor: widget.disableColor,
            padding: EdgeInsets.symmetric(vertical: MarginSize.headerMarginVertical3, horizontal: MarginSize.headerMarginVertical1),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.standard_10)),
          ),
          onPressed: widget.onPressed,
          child: Text(
            widget.buttonText!,
            style: TextStyle(
                color: widget.textColor == null
                    ? MyColors.white
                    : widget.textColor,
                fontSize: Dimens.standard_22,fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class RaisedButtonIconCustom extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final Color? splashColor;
  final Color? disableColor;
  final double? buttonHeight;
  final double? buttonWidth;
  final Icon? icon;

  RaisedButtonIconCustom(
      {@required this.onPressed,
      @required this.buttonText,
      this.splashColor,
      this.textColor,
      this.disableColor,
      this.buttonColor,
      this.buttonHeight,
      this.buttonWidth,
      this.icon});

  @override
  _RaisedButtonIconCustomState createState() => _RaisedButtonIconCustomState();
}

class _RaisedButtonIconCustomState extends State<RaisedButtonIconCustom> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: widget.buttonWidth == null ? size.width * 0.8 : widget.buttonWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: widget.buttonColor,disabledBackgroundColor: widget.disableColor,
            padding: EdgeInsets.symmetric(vertical: MarginSize.headerMarginVertical1, horizontal: 30),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.standard_10)),
          ),
          onPressed: widget.onPressed,
          icon: widget.icon!,
          label: Text(
            widget.buttonText!,
            style: TextStyle(color: widget.textColor),
          ),
        ),
      ),
    );
  }
}
