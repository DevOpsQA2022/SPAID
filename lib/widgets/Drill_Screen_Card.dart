import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';

class DrillScreenCard extends StatefulWidget {
  DrillScreenCard(
      { this.onPressed,
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
  final Widget? title;
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
  _DrillScreenCardState createState() => _DrillScreenCardState();
}

class _DrillScreenCardState extends State<DrillScreenCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: GestureDetector(

        onTap: (){
          widget.onPressed!();

          // if(widget.index != null){
          //   widget.onResend(widget.index);
          //
          // }else{
          //   widget.onPressed();
          //
          // }
        },
        child: Card(

            elevation: 4,
            //clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(

                    leading: widget.image != null?CircleAvatar(
                      backgroundImage:MemoryImage(widget.image!),// Image.file(new File(imgFilePath)),
                      //backgroundImage: NetworkImage(MyImages.spaid),
                      backgroundColor:
                      MyColors.white,
                      radius: 20,
                    ):widget.icon != null?CircleAvatar(
                        radius: 20.0,
                        backgroundColor: MyColors.white,
                        child: widget.icon):Container() ,
                    //widget.icon,

                    title:Row(children: <Widget>[
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: widget.title,
                      ),
                      /*Expanded(child: Text(widget.role == null ? " " : widget.role,style: TextStyle(
                        letterSpacing: Dimens.letterSpacing_25,
                        color: MyColors.kPrimaryColor))),*/
                    ]),
                    /*subtitle:widget.note == null?null:Expanded(child: Text(widget.note == null ? " " : "\nNote: "+widget.note,style: TextStyle(
                        letterSpacing: Dimens.letterSpacing_25,
                        color: MyColors.black))) ,*/
                    trailing: widget.trailing != null ?widget.trailing:null
                  /*Text(
                    widget.title == null ? " " : widget.title,
                    style: TextStyle(
                        letterSpacing: Dimens.letterSpacing_25,
                        color: MyColors.kPrimaryColor),
                  ),*/ /*Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title == null ? " " :widget.title ,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.kPrimaryColor),
                      ),

                      SizedBox(
                        height: Dimens.dp_8,
                      ),

                    ],
                  ),*/

                ),
                widget.note != null && (widget.roleID==Constants.coachorManager||widget.roleID==Constants.owner)?
                Divider():Container(),
                widget.note != null && (widget.roleID==Constants.coachorManager||widget.roleID==Constants.owner)?
                Row(
                  children: [
                    /*Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Expanded(
                        child: SizedBox(
                          width: 30,
                          child: Text( "Note: ",style: TextStyle(
                              fontSize: 12,
                              letterSpacing: Dimens.letterSpacing_25,
                              color: MyColors.black)),
                        ),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: SizedBox(
                        width: 280,
                        child: Text(widget.note == null ? " " : "Note: "+widget.note!,style: TextStyle(
                            fontSize: 12,
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.black)),
                      ),
                    ),
                  ],
                ):Container()
              ],
            )),
      ),
    );
  }
}
