import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/utils/extension.dart';

class PlayerProfileDetailCardEdit extends StatefulWidget {
  final String? profileImageString;
  final Icon? calendarImageString;
   String? titleText;
  final String? groupText;
  final String? userImageString;
  final String? descriptionText;
  final String? sponsorshipCountText;
  final VoidCallback? onTap;
  final String? phoneText;
  final double? height;
  final String? addressText;
  final bool? isEditingText;
  final TextEditingController? editingController;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;
  final bool? isLast;

  final String? labelText;
  final String? prefix;
  final bool? isPwdType;
  final String? errorText;
  final bool? isEnabled;
  final String? suffixImage;
  final String? prefixImage;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final inputFormatter;
  final textCapitalization;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final void Function(String)? onFieldSubmit;
  final VoidCallback? onClick;
  final String? hintText;

  PlayerProfileDetailCardEdit({
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
    this.isEditingText,
    this.editingController,
    this.validator,
    this.labelText,
    this.isPwdType = false,
    this.controller,
    this.errorText,
    this.suffixImage,
    this.isLast=false,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefix,
    this.isEnabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.inputFormatter,
    this.inputAction = TextInputAction.next,
    this.focusNode,
    this.onChange,
    this.onFieldSubmit,
    this.prefixImage,
    this.suffixIcon,
    this.helperText,
    this.prefixIcon,
    this.onSave,
    this.onClick,
    this.hintText,
  });

  @override
  _PlayerProfileDetailCardEditState createState() => _PlayerProfileDetailCardEditState();
}

class _PlayerProfileDetailCardEditState extends State<PlayerProfileDetailCardEdit> {
  Color? _field1Color;
  FocusNode myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: Dimens.standard_100.widthPercentage(context),
      child: Stack(
        children: [
          widget.suffixImage != null
              ? Positioned(
            bottom: Dimens.standard_28,
            right: Dimens.standard_12,
            child: Container(
              width: Dimens.standard_24,
              height: Dimens.standard_24,
              child: Image.asset(widget.suffixImage!),
            ),
          )
              : SizedBox(),
          TextFormField(
              focusNode:widget.focusNode?? myFocusNode,
              style: TextStyle(color: MyColors.black),
              inputFormatters: widget.inputFormatter,
              controller: widget.editingController,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPwdType!,
              enabled: widget.isEnabled,
              textCapitalization: widget.textCapitalization,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              textInputAction: widget.inputAction,
              onChanged: widget.onChange,
              validator: widget.validator,
              onSaved: widget.onSave,
              onTap: widget.onClick,
              // onEditingComplete: () => context.nextEditableTextFocus(widget.isLast!),
              onFieldSubmitted:widget.onFieldSubmit,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: MyColors.colorGray_818181),

                hintText: widget.hintText,
                helperText: widget.helperText,
                helperStyle: TextStyle(
                    color: widget.errorText != null
                        ? MyColors.errorColor
                        : MyColors.colorGray_818181),
                prefixIcon: widget.prefixIcon == null ?SizedBox(): widget.prefixIcon,
                suffixIcon: widget.suffixIcon == null ?null: widget.suffixIcon,
                contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                prefix: widget.prefix == null
                    ? SizedBox()
                    : Text(
                  widget.prefix!,
                  style: TextStyle(
                      color: widget.errorText != null
                          ? MyColors.errorColor
                          : MyColors.black),
                ),
                labelText: widget.labelText,

                fillColor: MyColors.white,
                border:new OutlineInputBorder(
                  borderSide: new BorderSide(color:MyColors.borderColor),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(0.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  borderSide: BorderSide(color: MyColors.kPrimaryColor,width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  borderSide: BorderSide(color: MyColors.borderColor),
                ),

                alignLabelWithHint: true,
                labelStyle: TextStyle(

                    height: 0.8,
                    color: widget.errorText != null
                        ? MyColors.errorColor
                        :  myFocusNode.hasFocus
                  ? MyColors.black
                        : MyColors.colorGray_818181,),
              )
          ),
        ],
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
                            color: MyColors.kPrimaryColor),),
                      SizedBox(
                        height: Dimens.dp_8,
                      ),
                      Text(
                        widget.groupText!,
                        style: TextStyle(
                            letterSpacing: Dimens.letterSpacing_25,
                            color: MyColors.colorGray_818181),
                      ),
                      SizedBox(
                        height: Dimens.dp_8,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.phoneText!,
                            style: TextStyle(
                                letterSpacing: Dimens.letterSpacing_25,
                                color: MyColors.colorGray_818181),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dimens.dp_8,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.addressText!,
                            style: TextStyle(
                                letterSpacing: Dimens.letterSpacing_25,
                                color: MyColors.colorGray_818181),
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
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

extension Utility on BuildContext {
  void nextEditableTextFocus(bool isLast) {
    do {
      FocusScope.of(this).nextFocus();
      if(isLast) {
        FocusScope.of(this).unfocus();
      }
    } while (FocusScope.of(this).focusedChild?.context?.widget is! EditableText);
  }
}