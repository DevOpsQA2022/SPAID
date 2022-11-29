import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PlayerContactCard extends StatefulWidget {
  PlayerContactCard(
      {@required this.onPressed,

      this.title,
      });

  final VoidCallback? onPressed;
  final String? title;


  @override
  _PlayerContactCardState createState() => _PlayerContactCardState();
}

class _PlayerContactCardState extends State<PlayerContactCard> {




  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Card(
            elevation: 4,
            //clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ListTile(
                 /* leading: Image.file( widget.videoThumbnail.),*/ /*CircleAvatar(
                      radius: 20.0,
                      backgroundColor: MyColors.kPrimaryColor,
                      child: widget.icon), */
                  title: Text(
                    widget.title == null ? " " : widget.title!,
                    style: TextStyle(
                        letterSpacing: Dimens.letterSpacing_25,
                        color: MyColors.kPrimaryColor),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
