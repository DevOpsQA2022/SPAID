import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/style_sizes.dart';

class PlayerProfileDetailCard extends StatefulWidget {
  final String? profileImageString;
  final Icon? calendarImageString;
  final String? titleText;
  final String? groupText;
  final String? userImageString;
  final String? descriptionText;
  final String? sponsorshipCountText;
  final VoidCallback? onTap;
  final String? phoneText;
  final double? height;
  final String? addressText;

  PlayerProfileDetailCard({
    this.profileImageString,
    this.titleText,
    this.groupText,
    this.userImageString,
    this.descriptionText,
    this.sponsorshipCountText,
    this.calendarImageString,
    this.phoneText,
    this.height,
    this.addressText,
    this.onTap,
  });

  @override
  _PlayerProfileDetailCardState createState() =>
      _PlayerProfileDetailCardState();
}

class _PlayerProfileDetailCardState extends State<PlayerProfileDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: widget.calendarImageString,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.groupText == null ? " " : widget.groupText!,
                        style: TextStyle(
                          fontWeight:kIsWeb? FontWeight.w500:FontWeight.bold,
                            letterSpacing: Dimens.letterSpacing_25,),
                      ),
                      SizedBox(
                        height: Dimens.dp_8,
                      ),
                      Text(
                        widget.titleText == null ? " " : widget.titleText!,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.black),
                      ),


                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class FamilyProfileDetailCard extends StatefulWidget {
  final String? profileImageString;
  final Icon? calendarImageString;
  final String? titleText;
  final String? groupText;
  final String? userImageString;
  final String? descriptionText;
  final String? sponsorshipCountText;
  final VoidCallback? onTap;
  final String? phoneText;
  final double? height;
  final String? addressText;

  FamilyProfileDetailCard({
    this.profileImageString,
    this.titleText,
    this.groupText,
    this.userImageString,
    this.descriptionText,
    this.sponsorshipCountText,
    this.calendarImageString,
    this.phoneText,
    this.height,
    this.addressText,
    this.onTap,
  });

  @override
  _FamilyProfileDetailCardState createState() =>
      _FamilyProfileDetailCardState();
}

class _FamilyProfileDetailCardState extends State<FamilyProfileDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  leading: widget.calendarImageString,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.titleText!,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.black),
                      ),
                      SizedBox(
                        height: Dimens.dp_8,
                      ),
                      Text(
                        widget.groupText!,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.black),
                      ),
                      SizedBox(
                        height: Dimens.dp_8,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.phoneText == "0"?"":widget.phoneText!,
                            style: TextStyle(
                                letterSpacing: Dimens.letterSpacing_25,
                                color: MyColors.black),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dimens.dp_8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.addressText!,
                              style: TextStyle(
                                  letterSpacing: Dimens.letterSpacing_25,
                                  color: MyColors.black),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
