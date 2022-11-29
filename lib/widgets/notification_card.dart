import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/widgets/customize_text_field.dart';

class NotificationCard extends StatelessWidget {
  final String? title, body;
  final String? buttonstatus;
  final String? buttonStatusClosed;
  final bool? noteStatus;
  final Function(int, String)? onClick;
  final Function()? onDelete;
  final Function(int)? onUpdateStatus;

  // final _formKey = GlobalKey<FormState>();
  FocusNode _node = new FocusNode();
  String? note = "";
  TextEditingController? noteControler;
  ScrollController _controllerOne = ScrollController();

  NotificationCard({
    this.noteControler,
    @required this.title,
    @required this.body,
    @required this.buttonstatus,
    @required this.buttonStatusClosed,
    @required this.noteStatus,
    this.onClick,
    this.onDelete,
    this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 18.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width:getValueForScreenType<bool>(
        context: context,
        mobile: true,
        tablet: false,
        desktop: false,)? MediaQuery.of(context).size.width -10:(MediaQuery.of(context).size.width/2.5) ,
        child: Column(

          children: [
            SizedBox(height: 10,),
            ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundColor: MyColors.kPrimaryColor,
                child: Text(title!.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyColors.white)),
              ),
              title: Text(title!,),
              /* subtitle: Text(
                body,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),*/
            ),
            if (buttonstatus != "InActive")
              Listener(
                onPointerDown: (_) {
                  FocusScope.of(context).requestFocus(_node);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.all(PaddingSize.boxPaddingAllSide),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _controllerOne,
                    child: CustomizeTextFormField(
                      //maxLines: FontSize.textMaxLine,
                      labelText: noteStatus!
                          ? MyStrings.notes + "*"
                          : MyStrings.notes,
                      prefixIcon: MyIcons.message,
                      minLines: 3,
                      maxLines: 3,
                      //minLines: FontSize.textMinLine,
                      // keyboardType: TextInputType.multiline,
                      validator: noteStatus!
                          ? ValidateInput.requiredFieldsNoteName
                          : null,
                      controller: noteControler!,
                      inputAction:
                      TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      // suffixImage: MyImages.dropDown,
                      isEnabled: true,
                      inputFormatter: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
                      /*onChange: (value){
                        note=value;

                      },
                      onSave: (value) {
                        note=value;
                        // provider.noteController.text = value;
                      },*/
                    ),
                  ),
                ),
              ),

              ButtonBar(
                children: [
                  if (buttonstatus != "InActive")
                  Listener(
                    onPointerDown: (_) {
                      FocusScope.of(context).requestFocus(_node);
                    },
                    child: Container(
                      height: 40.0,
                      width: 75.0,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),padding: EdgeInsets.all(0.0),
                            ),
                        onPressed: () {
                          if (noteStatus! && noteControler!.text.isNotEmpty ||
                              !noteStatus!) {
                            print("Marlen" + noteControler!.text);
                            onClick!(2, noteControler!.text);
                          } else {
                            CodeSnippet.instance.showMsg(
                                ValidateInput.requiredFieldsNoteName(
                                    noteControler!.text)!);
                          }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.kPrimaryColor,
                                  MyColors.kPrimaryColor
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Accept",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (buttonstatus != "InActive")
                  Listener(
                    onPointerDown: (_) {
                      FocusScope.of(context).requestFocus(_node);
                    },
                    child: Container(
                      height: 40.0,
                      width: 75.0,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () {
                          if (noteStatus! && noteControler!.text.isNotEmpty ||
                              !noteStatus!) {
                            onClick!(4, noteControler!.text);
                          } else {
                            CodeSnippet.instance.showMsg(
                                ValidateInput.requiredFieldsNoteName(
                                    noteControler!.text)!);
                          }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.kPrimaryColor,
                                  MyColors.kPrimaryColor
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Maybe",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (buttonstatus != "InActive")
                  Listener(
                    onPointerDown: (_) {
                      FocusScope.of(context).requestFocus(_node);
                    },
                    child: Container(
                      height: 40.0,
                      width: 75.0,
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),padding: EdgeInsets.all(0.0),
                        ),
                        onPressed: () {
                          if (noteStatus! && noteControler!.text.isNotEmpty ||
                              !noteStatus!) {
                            onClick!(3, noteControler!.text);
                          } else {
                            CodeSnippet.instance.showMsg(
                                ValidateInput.requiredFieldsNoteName(
                                    noteControler!.text)!);
                          }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.kPrimaryColor,
                                  MyColors.kPrimaryColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 250.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Decline",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (buttonStatusClosed != "InActive")
                    Listener(
                      onPointerDown: (_) {
                        FocusScope.of(context).requestFocus(_node);
                      },
                      child: Container(
                        height: 40.0,
                        width: 75.0,
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),padding: EdgeInsets.all(0.0),
                          ),
                          onPressed: () {
                            onUpdateStatus!(2);
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    MyColors.kPrimaryColor,
                                    MyColors.kPrimaryColor],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 250.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Yes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (buttonStatusClosed != "InActive")
                    Listener(
                      onPointerDown: (_) {
                        FocusScope.of(context).requestFocus(_node);
                      },
                      child: Container(
                        height: 40.0,
                        width: 75.0,
                        margin: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),padding: EdgeInsets.all(0.0),
                          ),
                          onPressed: () {
                            onUpdateStatus!(3);
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    MyColors.kPrimaryColor,
                                    MyColors.kPrimaryColor],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 250.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "No",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (buttonstatus == "InActive")
                  IconButton(
                      tooltip: MyStrings.delete,
                      onPressed:() {

                        onDelete!();
                      },
                      icon: Icon(
                    Icons.delete,
                    color: MyColors.black,
                  ))

                ],
              ),
           /* Row(
           // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: () {
                      onDelete();
                    },
                    child: Icon(
                      Icons.delete,
                      color: MyColors.black,
                    )),
              ],
            ),*/
            /*Image.asset('assets/card-sample-image.jpg'),
            Image.asset('assets/card-sample-image-2.jpg'),*/
          ],
        ),
      ),
    );
  }
}
