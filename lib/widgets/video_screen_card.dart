import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoScreenCard extends StatefulWidget {
  VideoScreenCard(
      {@required this.onPressed,
        this.videoThumbnail,
      this.videoURL,
      this.title,
      this.height});

  final VoidCallback? onPressed;
  final String? videoURL;
  final String? title;
  final double? height;
  final Future<File>? videoThumbnail;


  @override
  _VideoScreenCardState createState() => _VideoScreenCardState();
}

class _VideoScreenCardState extends State<VideoScreenCard> {




  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
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
