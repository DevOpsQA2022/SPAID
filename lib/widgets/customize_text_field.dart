import 'package:flutter/material.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/utils/extension.dart';

class CustomizeTextFormField extends StatefulWidget {
  CustomizeTextFormField(
      {Key? key,
      this.labelText,
      this.isPwdType = false,
      this.controller,
      this.errorText,
      this.suffixImage,
      this.maxLines = 1,
      this.minLines = 1,

        this.width,
      this.prefix,
      this.isEnabled = true,
        this.isReadonly = false,
      this.textCapitalization = TextCapitalization.none,
      this.keyboardType = TextInputType.text,
      this.inputFormatter,
      this.inputAction = TextInputAction.done,
      this.focusNode,
      this.onChange,
        this.isLast=false,

        this.onFieldSubmit,
        this.onEditComplete,
      this.prefixImage,
      this.suffixIcon,
        this.inputBorder,
      this.helperText,
      this.validator,
      this.prefixIcon,
      this.onSave,
      this.hintText,
      this.onClick,});

  final String? labelText;
  final String? prefix;
  final bool? isPwdType;
  final String? errorText;
  final bool? isEnabled;
  final bool? isReadonly;
  final String? suffixImage;
  final String? prefixImage;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final  inputBorder;
  final bool? isLast;

  final String? helperText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final double? width;
  final inputFormatter;
  final textCapitalization;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final void Function(String)? onFieldSubmit;
  final void Function()? onEditComplete;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;

  final String? hintText;
  final VoidCallback? onClick;
  @override
  _CustomizeTextFormFieldState createState() => _CustomizeTextFormFieldState();
}

class _CustomizeTextFormFieldState extends State<CustomizeTextFormField> {
  FocusNode myFocusNode = new FocusNode();
  Color? _field1Color;
  bool? showCursor;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.width == null ? Dimens.standard_100.widthPercentage(context) : widget.width,
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
            key: widget.key,
              style: TextStyle(color: MyColors.black),
              inputFormatters: widget.inputFormatter,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPwdType!,
              enabled: widget.isEnabled,
              readOnly: widget.isReadonly!,
              textCapitalization: widget.textCapitalization,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              textInputAction: widget.inputAction == null ? TextInputAction.next : widget.inputAction,
              focusNode:widget.focusNode?? myFocusNode,
              onChanged: widget.onChange,
              validator: widget.validator,
              onSaved: widget.onSave,
              onTap: widget.onClick,
              //onEditingComplete:  () => FocusScope.of(context).nextFocus(),
              // onEditingComplete: () => context.nextEditableTextFocus(widget.isLast!),
              onFieldSubmitted:widget.onFieldSubmit,
              decoration: InputDecoration(

                // helperText: helperText,
                helperStyle: TextStyle(
                    color: widget.errorText != null
                        ? MyColors.errorColor
                        : MyColors.black),
                // prefixIcon: prefixIcon == null ?SizedBox(): prefixIcon,
                 suffixIcon: widget.suffixIcon == null ?null: widget.suffixIcon,
                contentPadding: EdgeInsets.fromLTRB(20.0, widget.minLines!>1?15.0:0.0, 20.0, 0.0),
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
                hintStyle: TextStyle(color: MyColors.colorGray_818181),
                border: widget.inputBorder == null ? OutlineInputBorder(
                  borderSide: new BorderSide(color:MyColors.borderColor),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(0.0),
                  ),
                ) : widget.inputBorder,
                focusColor: MyColors.red,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  borderSide: BorderSide(color: MyColors.kPrimaryColor,width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                  borderSide: BorderSide(color: MyColors.borderColor),
                ),
                hintText: widget.hintText,
               // alignLabelWithHint: true,
                labelStyle: TextStyle(
                    height: 0.8,
                    // 0,1 - label will sit on top of border
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