import 'package:country_picker/country_picker.dart';
import 'package:country_pickers/country.dart' as b;
import 'package:country_pickers/country_pickers.dart' as c;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/base/base_state.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/widgets/customize_text_field.dart';

class PhoneNumberCountryPicker extends StatefulWidget {
  TextEditingController? countryController, countryCodeController;
  String? Function(String?)? validator;
  void Function(String?)? onSave;
  void Function(String)? onChange;
  final FocusNode? focusNode;

  String? label, imagestring, countryCode, hintText;
  bool? changePosition;
  PhoneNumberCountryPicker(
      {this.countryCodeController,
        this.countryController,
        this.onSave,
        this.onChange,
        this.validator,
        this.label,
        this.imagestring,
        this.changePosition,
        this.countryCode,
        this.focusNode,
        this.hintText});
  @override
  _PhoneNumberCountryPickerState createState() => _PhoneNumberCountryPickerState();
}
class _PhoneNumberCountryPickerState extends BaseState<PhoneNumberCountryPicker> {

 /* @override
  void initState() {
    super.initState();
    widget.countryController.addListener(() {
      if(widget.countryController.){

      }
    });
  }*/

  Widget _buildDropdownItem(b.Country country) => Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                child: Row(
                  children: [
                    c.CountryPickerUtils.getDefaultFlagImage(country),
                    SizedBox(width:5,),
                    Text("+ ${country.phoneCode}"),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          getValueForScreenType<bool>(
            context: context,
            mobile: true,
            tablet: false,
            desktop: false,
          )
              ? GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                   // exclude: <String>[widget.countryCode],
                    countryFilter: <
                        String>[
                      'CA',
                      'US'
                    ],
                    //Optional. Shows phone code before the country name.
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      setState(() {
                        widget.countryCodeController!.text = "+"+country.phoneCode;
                      });

                    },
                  );
                },
                child:  Padding(
                  padding:widget.changePosition!? const EdgeInsets.fromLTRB(0.0,0.0,0.0,25):const EdgeInsets.fromLTRB(0.0,0.0,0.0,0.0),
                  child: SizedBox(
                    width: 100,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: MyColors
                                  .colorGray_818181)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8.0,0.0,0.0,0.0),
                            child: Text(
                              widget.countryCodeController!.text.isEmpty?widget.countryCode=="IN"?"+91":"+1":widget.countryCodeController!.text,
                              style: TextStyle(
                                  fontSize: FontSize.headerFontSize5),
                            ),
                          ),
                          IconButton(
                            icon:
                            MyIcons
                                .arrowdownIos,
                            onPressed: (){
                              showCountryPicker(
                                context: context,
                                //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                // exclude: <String>[widget.countryCode],
                                countryFilter: <
                                    String>[
                                  'CA',
                                  'US'
                                ],
                                //Optional. Shows phone code before the country name.
                                showPhoneCode: true,
                                onSelect: (Country country) {
                                  setState(() {
                                    widget.countryCodeController!.text = "+"+country.phoneCode;
                                  });

                                },
                              );
                            },
                            // controller: provider.countryController,

                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              )
              /*CountryCodePicker(

            showDropDownButton: true,
            onInit: (code) {
              countryCodeController.text = code.dialCode;
            },
            onChanged: (code) {
              countryCodeController.text = code.toString();
            },
            closeIcon: MyIcons.backwardArrow,
            initialSelection: countryCode,
            // favorite: ['+91','IN'],
            showCountryOnly: false,
            showFlag: true,
            showOnlyCountryWhenClosed: false,
            alignLeft: false,
          ) */
              : c.CountryPickerDropdown(
                  itemHeight: 80,
                  icon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_drop_down),
                  ),
                  iconSize: 30,
                  initialValue: widget.countryCode!.isEmpty ? "CA" : widget.countryCode,
            itemFilter: (c) => ['CA', 'US'].contains(c.isoCode),
            priorityList: [
              c.CountryPickerUtils.getCountryByIsoCode('CA'),
              c.CountryPickerUtils.getCountryByIsoCode('US'),
            ],
                  itemBuilder: _buildDropdownItem,
                  isExpanded: false,
                  sortComparator: (b.Country a, b.Country b) =>
                      a.isoCode.compareTo(b.isoCode),
                  onValuePicked: (b.Country country) {
                    print("${country.name}");
                  },
                ),
          SizedBox(width: 10,),
          Expanded(
            child: CustomizeTextFormField(
              hintText: widget.hintText!,
              labelText: widget.label!,
              prefixImage: widget.imagestring??"",
              controller: widget.countryController!,
              keyboardType: TextInputType.number,
              inputAction: TextInputAction.done,
              focusNode:widget.focusNode! ,
              isLast: true,
              inputFormatter: [
                new LengthLimitingTextInputFormatter(
                    10),
              ],
              validator: widget.validator,
              onSave: widget.onSave,
              onChange: widget.onChange!,
            ),
          ),
        ],
      ),
    );
  }
}

class CountryPickerDialog extends StatelessWidget {
  final TextEditingController? countryController, countryCodeController;
  final void Function(String)? validator;
  final void Function(String)? onSave;
  final String? label, imagestring, countryCode;

  CountryPickerDialog(
      {this.countryCodeController,
      this.countryController,
      this.onSave,
      this.validator,
      this.label,
      this.imagestring,
      this.countryCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // CountryCodePicker(
              //   showDropDownButton: true,
              //   onInit: (code) {
              //     countryCodeController!.text = code.name;
              //   },
              //   onChanged: (code) {
              //     countryCodeController!.text = code.toString();
              //   },
              //   // closeIcon: MyIcons.backwardArrow,
              //   initialSelection: countryCode,
              //   // favorite: ['+91','IN'],
              //   customArrow: Icons.arrow_forward_ios,
              //   flagWidth: 16,
              //   showCountryOnly: true,
              //   showFlag: false,
              //   showOnlyCountryWhenClosed: true,
              //   alignLeft: false,
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
