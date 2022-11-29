import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';

class OpponentScreenCard extends StatefulWidget {
  OpponentScreenCard(
      {@required this.onPressed,
      this.title,
      this.role,
      this.icon,
      this.trailing,
      this.color,
      this.image,
      this.index,
      this.roleID,
      this.note,
      this.height, this.onResend});

  final VoidCallback? onPressed;
  final String? title;
  final String? role;
  final String? note;
  final Uint8List?  image;
  final Widget? icon;
  final Widget? trailing;
  final Color? color;
  final double? height;
  final int? index;
  final int? roleID;
  final Function(int)? onResend;


  @override
  _OpponentScreenCardState createState() => _OpponentScreenCardState();
}

class _OpponentScreenCardState extends State<OpponentScreenCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GestureDetector(

        onTap: (){
          if(widget.index != null){
            widget.onResend!(widget.index!);

          }else{
            widget.onPressed!();

          }
        },
        child: Card(

            elevation: 4,
            //clipBehavior: Clip.antiAlias,
            child: Center(
              child: ListTile(
                leading: widget.image != null?CircleAvatar(
                  backgroundImage:MemoryImage(widget.image!),// Image.file(new File(imgFilePath)),
                  //backgroundImage: NetworkImage(MyImages.spaid),
                  backgroundColor:
                  MyColors.white,
                  radius: 20,
                ):widget.icon != null?CircleAvatar(
                    radius: 20.0,
                    backgroundColor: MyColors.white,
                    child: widget.icon):SizedBox() ,//widget.icon,
                title: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(widget.title == null ? " " : widget.title!,style: TextStyle(
                      letterSpacing: Dimens.letterSpacing_25,
                      color: MyColors.kPrimaryColor)),
                ),


              ),
            )),
      ),
    );
  }
}
