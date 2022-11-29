import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/responsive.dart';

class WebCard extends StatelessWidget {
  final Widget? child;
  final double? marginVertical;
  final double? marginhorizontal;
  final double? height;

  const WebCard({
    Key? key,
    @required this.child,
    this.marginhorizontal,
    this.marginVertical,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return getValueForScreenType<bool>(
      context: context,
      mobile: false,
      tablet: true,
      desktop: true,
    )
        ? Center(
            child: Container(
              height: height == null ? size.height * 0.94 : height,
              width: size.width,
              child: Stack(
                // alignment: Alignment.center,
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.symmetric(
                        vertical: marginVertical == null ? 10 : marginVertical!,
                        horizontal:
                            marginhorizontal == null ? 200 : marginhorizontal!),
                    color: MyColors.white,
                    elevation: 20,
                    child: child,
                  ),
                ],
              ),
            ),
          )
        : child!;
  }
}
