import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/utils/extension.dart';

class CustomPasswordTextField extends StatefulWidget {
  CustomPasswordTextField(
      {Key? key,
      this.labelText,
      this.isPwdType = false,
      this.controller,
      this.errorText,
      this.suffixImage,
      this.maxLines = 1,
      this.minLines = 1,
      this.prefix,
        this.isLast=false,
        this.isEnabled = true,
      this.textCapitalization = TextCapitalization.none,
      this.keyboardType = TextInputType.text,
      this.inputFormatter,
      this.inputAction = TextInputAction.done,
      this.focusNode,
      this.onChange,
      this.onFieldSubmit,
      this.prefixImage,
      this.helperText,
      this.prefixIcon,
      this.onSave,
      this.validator});

  final String? labelText;
  final String? prefix;
  final bool? isPwdType;
  final String? errorText;
  final Icon? prefixIcon;
  final bool? isEnabled;
  final String? suffixImage;
  final String? prefixImage;
  final String? helperText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final inputFormatter;
  final textCapitalization;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  final bool? isLast;
  final void Function(String)? onChange;
  final void Function(String)? onFieldSubmit;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;

  @override
  _CustomPasswordTextFieldState createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool? _passwordVisible;
  Color? _field1Color;
  FocusNode myFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimens.standard_100.widthPercentage(context),
      child: TextFormField(
        key:widget.key,
          style: TextStyle(color: MyColors.black),
          inputFormatters: [
          FilteringTextInputFormatter.deny(
          RegExp('(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')
          )],
        controller: widget.controller,
          keyboardType: widget.keyboardType,
          enabled: widget.isEnabled,
          obscureText: !_passwordVisible!,

          textCapitalization: widget.textCapitalization,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          textInputAction: widget.inputAction == null ? TextInputAction.next : widget.inputAction,
          focusNode: widget.focusNode?? myFocusNode,
          onChanged: widget.onChange,
          validator: widget.validator,
          onSaved: widget.onSave,
          onFieldSubmitted: widget.onFieldSubmit,
          // onEditingComplete: () => context.nextEditableTextFocus(widget.isLast!),

          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            helperText: widget.helperText,
            helperStyle: TextStyle(
                color: widget.errorText != null
                    ? MyColors.errorColor
                    : MyColors.black),
            // prefixIcon: widget.prefixIcon == null ?SizedBox(): widget.prefixIcon,
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
              borderRadius: const BorderRadius.all(
                const Radius.circular(0.0),
              ),
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
            suffixIcon: IconButton(
              tooltip: MyStrings.tooltipPassword,
              splashRadius: 0.5,
              icon: Icon(
                _passwordVisible! ? Icons.visibility : Icons.visibility_off,
                color: MyColors.black,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible!;
                });
              },
            ),
          )),
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