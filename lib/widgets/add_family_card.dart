import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';

import 'customize_text_field.dart';

class AddFamilyListCard extends StatelessWidget {
  final int index;
  final TextEditingController firstnamecontroller;
  final TextEditingController lastnamecontroller;
  final TextEditingController emailcontroller;
  final TextEditingController contactcontroller;
  final TextEditingController addresscontroller;
  final TextEditingController citycontroller;
  final TextEditingController statecontroller;
  final TextEditingController zipcodecontroller;
  final TextEditingController userIDController;
FocusNode _zipnode = new FocusNode();
//final Function(int) onCountChanged;
  final Function(int,int)? myNumber;


  AddFamilyListCard(
      this.index,
      this.firstnamecontroller,
      this.lastnamecontroller,
      this.emailcontroller,
      this.contactcontroller,
      this.addresscontroller,
      this.citycontroller,
      this.statecontroller,
      this.userIDController,
      this.zipcodecontroller,
      {Key? key,
      this.myNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        ListTile(
          title: Center(
            child: Text(
              MyStrings.familyinfo,
              style: TextStyle(
                  fontSize: getValueForScreenType<bool>(
                                          context: context,
                                          mobile: false,
                                          tablet: false,
                                          desktop: true,) ? 40 : 25,
                  fontWeight: FontWeight.w700),
            ),
          ),
          trailing: Tooltip(message:MyStrings.delete ,child: MyIcons.delete),
          onTap: () => myNumber!(index,int.parse(userIDController.text)),
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          labelText: MyStrings.firstName+"*",
          controller: firstnamecontroller,
          inputFormatter: [new LengthLimitingTextInputFormatter(25),],
          // suffixImage: MyImages.dropDown,
          isEnabled: true,
          inputAction: TextInputAction.next,
          validator: ValidateInput.requiredFieldsFirstName,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          labelText: MyStrings.lastName+"*",
          controller: lastnamecontroller,
          inputFormatter: [new LengthLimitingTextInputFormatter(25),],
          // suffixImage: MyImages.dropDown,
          isEnabled: true,
          inputAction: TextInputAction.next,
          validator: ValidateInput.requiredFieldsLastName,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          labelText: MyStrings.email+"*",
          controller: emailcontroller,
          inputFormatter: [new LengthLimitingTextInputFormatter(100),],
          // suffixImage: MyImages.dropDown,
          isEnabled: true,
          keyboardType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          validator: ValidateInput.validateEmail,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          hintText: MyStrings.noFormat,
          labelText: MyStrings.contactPhone,
          inputFormatter: [new LengthLimitingTextInputFormatter(10),],
          controller: contactcontroller,
          keyboardType: TextInputType.number,
          // suffixImage: MyImages.dropDown,
          inputAction: TextInputAction.next,
          isEnabled: true,
          //validator: ValidateInput.requiredFields,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          labelText: MyStrings.address,
          controller: addresscontroller,
          // suffixImage: MyImages.dropDown,
          inputFormatter: [new LengthLimitingTextInputFormatter(50),],
          isEnabled: true,
          inputAction: TextInputAction.next,
          //validator: ValidateInput.requiredFields,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          labelText: MyStrings.city,
          controller: citycontroller,
          inputFormatter: [new LengthLimitingTextInputFormatter(25),],
          // suffixImage: MyImages.dropDown,
          isEnabled: true,
          inputAction: TextInputAction.next,
          //validator: ValidateInput.requiredFields,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          labelText: MyStrings.state,
          controller: statecontroller,
          inputFormatter: [new LengthLimitingTextInputFormatter(25),],
          // suffixImage: MyImages.dropDown,
          isEnabled: true,
          onFieldSubmit: (v){
            FocusScope.of(context).requestFocus(_zipnode);
          },
          inputAction: TextInputAction.next,
          //validator: ValidateInput.requiredFields,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
        SizedBox(
          height: SizedBoxSize.standardSizedBoxHeight,
          width: SizedBoxSize.standardSizedBoxWidth,
        ),
        CustomizeTextFormField(
          labelText: MyStrings.zipcode,
          controller: zipcodecontroller,
          focusNode: _zipnode,
          inputFormatter: [new LengthLimitingTextInputFormatter(10),],
          // suffixImage: MyImages.dropDown,
          isEnabled: true,
          isLast: true,
          inputAction: TextInputAction.done,
          onFieldSubmit: (v){
            _zipnode.unfocus();
          },
          //validator: ValidateInput.requiredFields,
          onSave: (value) {
            //provider.firstNameController.text = value;
          },
        ),
      ]),
    );
  }
}
