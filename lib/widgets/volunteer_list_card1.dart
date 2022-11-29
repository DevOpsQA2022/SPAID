
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_select/smart_select.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/model/response/roaster_listview_response/roaster_listview_response.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/widgets/customize_text_field.dart';

class VolunteerScreenCardAdmin extends StatefulWidget {
  //region Private Members
  final TextEditingController namecontroller;

  final int index;
  final Function(int)? myValue;
  final Function(int)? delete;
  final Function? refresh;



  List<String> names = [];
  BuildContext context;

  //endregion

  VolunteerScreenCardAdmin(
      this.context,
      this.index,
      this.namecontroller,
      {Key? key,
        this.myValue,
        this.delete,
        this.refresh})
      : super(key: key);

  @override
  _VolunteerScreenCardAdminState createState() =>
      _VolunteerScreenCardAdminState();
}

class _VolunteerScreenCardAdminState
    extends BaseState<VolunteerScreenCardAdmin> {
  String? goalpenaltyshot;

  String? playerchosenValue, _playerchosenName;

  TimeOfDay _time = TimeOfDay.now();
  String? gender;
  FocusNode _node = new FocusNode();
  bool? playerList, enableEdit;
  TimeOfDay? picked;

  //String dropdownvalue;
  bool? cardEnable;
  // var items = [
  //   'Travis Dermott',
  //   'Ryan Lomberg',
  //   'Anton Lundell',
  //   'Jason Spezza'
  // ];
  bool _validate = false;

  @override
  /*void initState() {
    super.initState();

    print("Marlen 1");
    print(widget.namecontroller.text);
    setState(() {
      // print(widget.roasterListViewResponse.userDetails);
      if(widget.volunteerPlayernamecontroller != null){
        for(int i=0;i<widget.volunteerPlayernamecontroller.length;i++){
          selected.add(widget.volunteerPlayernamecontroller[i].text);
          */ /*  for(int j=0;j<widget.roasterListViewResponse.userDetails.length;j++){
            if(widget.roasterListViewResponse.userDetails[j].userIdNo==int.parse(widget.volunteerPlayernamecontroller[i].text)){
              selected.add(widget.roasterListViewResponse.userDetails[j].userFirstName);
            }
          }*/ /*
        }
      }
      print(selected);
      if(widget.roasterListViewResponse != null){
        for(int i=0;i<widget.roasterListViewResponse.userDetails.length;i++){
          print("2");
          names.add(widget.roasterListViewResponse.userDetails[i].userFirstName);
          print(names);
        }
      }
    });

  }
*/

  @override
  Widget build(BuildContext context) {
    //   Future.delayed(Duration.zero, () {
    //   // updateInit();
    // });
    Size size = MediaQuery.of(context).size;
    return IntrinsicHeight(
        child: Column(
          children: [

            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 12.0, top: 8.0, bottom: 8.0),

                  child: Column(children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[


                          widget.namecontroller.text.isEmpty
                              ? Flexible(
                            child: CustomizeTextFormField(

                              validator: ValidateInput.requiredFields,
                              isReadonly: widget.namecontroller.text.isEmpty
                                  ? false
                                  : true,
                              inputBorder: widget.namecontroller.text.isEmpty
                                  ? null
                                  : InputBorder.none,
                              inputFormatter: [new LengthLimitingTextInputFormatter(25),],
                              controller: widget.namecontroller,
                              isEnabled: widget.namecontroller.text.trim() != "" ? false : true,
                              helperText: MyStrings.playerRole,
isLast: true,
                              // labelText: namecontroller.text,

                              onSave: (value) {
                                widget.namecontroller.text = value!;
                              },
                            ),
                          )
                              : Flexible(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 130,
                                child: Text(
                                  widget.namecontroller.text,
                                  textAlign: TextAlign.left,

                                ),
                              ),
                            ),
                          ),

                          // SizedBox(width: 3,),

                          Flexible(
                              child: IconButton(
                                  tooltip: MyStrings.delete,
                                  onPressed:() {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) => FancyDialog(
                                          gifPath: MyImages.team,
                                          okFun: () async => {
                                            Navigator.of(context).pop(),
                                            widget.delete!(widget.index),

                                          },
                                          cancelFun: () => {Navigator.of(context).pop()},
                                          cancelColor: MyColors.red,
                                          title: MyStrings.conformDelete,
                                        ));
                                  }, icon: Icon(
                                Icons.delete,
                                color: MyColors.black,
                              ))
                          )


                          /* widget.checckboxcontroller.text == "true"
                              ? Flexible(
                            child: SizedBox(
                              height: 50,
                              child: DropDownMultiSelect(
                                validator: ValidateInput.requiredFields,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 20,
                                  ),
                                  errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                                  border: OutlineInputBorder(
                                    borderSide: new BorderSide(
                                        color: MyColors.borderColor),
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                  ),
                                ),
                                onChanged: (List<String> x) {
                                  print(x.length);
                                  print(x.toString());
                                  widget.volunteerPlayernamecontroller.clear();
                                  List<TextEditingController> name = [];
                                  for (int i = 0; i < x.length; i++) {
                                    name.add(TextEditingController());
                                    name[i].text = x[i].toString();
                                  }
                                  widget.volunteerPlayernamecontroller
                                      .addAll(name);
                                  setState(() {
                                    widget.selected = x;
                                  });
                                },
                                options: widget.names,
                                selectedValues: widget.selected,
                                whenEmpty: 'Choose Volunteer',
                              ),
                            ),
                          )
                              : SizedBox(),
                         */
                          // widget.index >= 6
                          //     ? SizedBox(
                          //         child: IconButton(
                          //             tooltip: MyStrings.delete,
                          //             onPressed: () {
                          //               widget.delete(widget.index);
                          //             },
                          //             icon: Icon(
                          //               Icons.delete,
                          //               color: MyColors.black,
                          //             )))
                          //     : Container()
                        ],
                      ),
                    ),
                    //widget.selected.length > 0
                    // ? Expanded(
                    //     child: Container(
                    //       height: widget.selected.length * 40.0,
                    //       child: Column(
                    //         children: [
                    //           ListView.builder(
                    //             padding: EdgeInsets.only(left: 5),
                    //             shrinkWrap: true,
                    //             //MUST TO ADDED
                    //             physics: NeverScrollableScrollPhysics(),
                    //             // new
                    //             itemCount: widget.selected.length,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               return ListTile(
                    //                 visualDensity: VisualDensity(
                    //                     horizontal: 0, vertical: -4),
                    //                 title: Align(
                    //                   alignment: Alignment(-1.2, 0),
                    //                   child: Row(
                    //                     children: [
                    //                       Text(
                    //                         (index + 1).toString() + ".",
                    //                         style: TextStyle(
                    //                             fontSize:
                    //                                 FontSize.footerFontSize4),
                    //                       ),
                    //                       Text(
                    //                         widget.selected[index],
                    //                         style: TextStyle(
                    //                             fontSize:
                    //                                 FontSize.footerFontSize4),
                    //                       )
                    //                     ],
                    //                   ),
                    //                 ),
                    //               );
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   )
                    // : Container(),
                  ]),
                ),
                elevation: 5,
                shadowColor: MyColors.kPrimaryColor,
              ),
            ),
          ],
        ));
  }
}

// List<S2Choice<String>> _choiceHomeAway = [
//   S2Choice<String>(value: '1', title: MyStrings.home),
//   S2Choice<String>(value: '2', title: MyStrings.away),
//   S2Choice<String>(value: '3', title: MyStrings.timeTbd),
// ];
//
// class CustomDropDown extends StatelessWidget {
//   final int value;
//   final String hint;
//   final String errorText;
//   final List<DropdownMenuItem> items;
//   final Function onChanged;
//
//   const CustomDropDown(
//       {Key key,
//         this.value,
//         this.hint,
//         this.items,
//         this.onChanged,
//         this.errorText})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Container(
//           decoration: BoxDecoration(
//               color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
//           child: Padding(
//             padding:
//             const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 5),
//             // child: DropdownButton<int>(
//             //   value: value,
//             //   hint: Text(
//             //     hint,
//             //     style: TextStyle(fontSize: 20),
//             //     overflow: TextOverflow.ellipsis,
//             //   ),
//             //   style: Theme.of(context).textTheme.subtitle1,
//             //   items: items,
//             //   onChanged: (item) {
//             //     onChanged(item);
//             //   },
//             //   isExpanded: true,
//             //   underline: Container(),
//             //   icon: Icon(Icons.keyboard_arrow_down),
//             // ),
//           ),
//         ),
//         if (errorText != null)
//           Padding(
//             padding: EdgeInsets.only(left: 30, top: 10),
//             child: Text(
//               errorText,
//               style: TextStyle(fontSize: 12, color: Colors.red[800]),
//             ),
//           )
//       ],
//     );
//   }
// }
