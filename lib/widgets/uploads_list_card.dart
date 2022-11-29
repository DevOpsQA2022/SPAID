import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/images.dart';

class UploadsListCard extends StatefulWidget {
  UploadsListCard({
    @required this.onPressed,
    @required this.onDelete,
    this.fileURL,
    this.title,
    this.desc,
    this.extension,
    this.type,
  });

  final void Function(String)? onDelete;

  final VoidCallback? onPressed;
  final String? fileURL;
  final String? title;
  final String? desc;
  final String? extension;
  final int? type;

  @override
  _UploadsListCardState createState() => _UploadsListCardState();
}

class _UploadsListCardState extends State<UploadsListCard>
    with SingleTickerProviderStateMixin {
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
                Expanded(
                    child:
                  Center(
                      child: widget.type == Constants.images
                          ? Image.network(widget.fileURL!)
                          : widget.type == Constants.videos
                              ? Image.asset(MyImages.video)
                              : widget.type == Constants.files?Image.asset(widget.extension=="xlsx"?MyImages.excel:widget.extension=="pdf"?MyImages.pdf:widget.extension=="ppt"?MyImages.ppt:widget.extension=="doc"||widget.extension=="docx"?MyImages.word:widget.extension=="pptx"?MyImages.ppt:""):Container()),

                ),
                Row(
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(widget.title!),
                    )),
                    IconButton(
                        onPressed: () {
                          widget.onDelete!(widget.fileURL!);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: MyColors.black,
                        )),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
