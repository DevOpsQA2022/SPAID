import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/dimens.dart';
import 'package:spaid/support/responsive.dart';
import 'package:spaid/support/validate_input.dart';
import 'package:spaid/utils/extension.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/custom_web_datepicker.dart';

class DatePickerTextfieldWidget extends StatefulWidget {
  DatePickerTextfieldWidget(
      {Key? key,
      this.labelText,
      this.isPwdType = false,
        this.isBoolType = false,
      this.controller,
      this.errorText,
      this.suffixImage,
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
      this.prefixIcon,
        this.suffixIcon,
      this.helperText,
      this.validator,
        this.onTab,
      this.onSave,
        this.hintText,
      this.height,});

  final String? labelText;
  final String? prefix;
  final bool? isPwdType;
  final bool? isBoolType;
  final String? errorText;
  final bool? isEnabled;
  final String? suffixImage;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
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
  final void Function(String)? onChange;
  final void Function(String)? onFieldSubmit;
  final String? Function(String?)? validator;
  final void Function(String?)? onSave;
  final VoidCallback? onTab;
  final String? hintText;
  final double? height;


  @override
  _DatePickerTextfieldWidgetState createState() =>
      _DatePickerTextfieldWidgetState();
}

class _DatePickerTextfieldWidgetState extends State<DatePickerTextfieldWidget> {
  DateTime _selectedDate = DateTime.now();
  FocusNode myFocusNode = new FocusNode();

  // TextEditingController _textEditingController = TextEditingController();
  String? dateformat, first;
  bool _webDatePicker = false;
  Color? _field1Color;


  @override
  void initState() {
    super.initState();
    getCountryCodeAsync();
  }

  Future<void> getCountryCodeAsync() async {
    first =
        "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  @override
  Widget build(BuildContext context) {
   /* widget.controller.text != ""?
    _selectedDate=DateFormat('dd/mm/yyyy').parse(widget.controller.text):null;*/
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
              showCursor: true,
              //add this line
              readOnly: false,
              style: TextStyle(color: MyColors.black),

              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.isPwdType!,
              enabled: widget.isEnabled,
              textCapitalization: widget.textCapitalization,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              textInputAction: widget.inputAction,
              focusNode: myFocusNode,
              onChanged: widget.onChange,
              validator: widget.validator,
              onSaved: widget.onSave,
              onFieldSubmitted: widget.onFieldSubmit,
              onTap: getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: true,) ? widget.onTab :() {_selectDateAsync(context);},
              // onTap: () {
              //   isMobile(context) ? _selectDateAsync(context): widget.onTab;
              // },
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                LengthLimitingTextInputFormatter(10),
                DateFormatter()
              ],

              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                helperText: widget.helperText,
                hintText: dateformat == "US" ? "MM/DD/YYYY"
                    :dateformat == "CA"? "YYYY/MM/DD" : "DD/MM/YYYY",
                helperStyle: TextStyle(
                    color: widget.errorText != null
                        ? MyColors.errorColor
                        : MyColors.black),
                prefixIcon: widget.prefixIcon == null ? null : widget.prefixIcon,
                suffixIcon: widget.suffixIcon == null ?SizedBox(): widget.suffixIcon,
                /*prefixIcon:
                widget.prefixIcon == null ? SizedBox() : widget.prefixIcon,*/
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
                labelStyle: TextStyle(
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

  // _selectDate(BuildContext context) async {
  //   final ThemeData theme = Theme.of(context);
  //   assert(theme.platform != null);
  //   switch (theme.platform) {
  //     case TargetPlatform.android:
  //     case TargetPlatform.fuchsia:
  //     case TargetPlatform.linux:
  //     case TargetPlatform.windows:
  //       return buildMaterialDatePicker(context);
  //     case TargetPlatform.iOS:
  //     case TargetPlatform.macOS:
  //       return buildCupertinoDatePicker(context);
  //   }
  // }
  // /// This builds material date picker in Android
  // buildMaterialDatePicker(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2025),
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light(),
  //         child: child,
  //       );
  //     },
  //   );
  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  // }
  // /// This builds cupertion date picker in iOS
  // buildCupertinoDatePicker(BuildContext context) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext builder) {
  //         return Container(
  //           height: MediaQuery.of(context).copyWith().size.height / 3,
  //           color: Colors.white,
  //           child: CupertinoDatePicker(
  //             mode: CupertinoDatePickerMode.date,
  //             onDateTimeChanged: (picked) {
  //               if (picked != null && picked != _selectedDate)
  //                 setState(() {
  //                   _selectedDate = picked;
  //                 });
  //             },
  //             initialDateTime: _selectedDate,
  //             minimumYear: 2000,
  //             maximumYear: 2025,
  //           ),
  //         );
  //       });
  // }



  _selectDateAsync(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    String languageCode = Localizations.localeOf(context).toLanguageTag();
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2040),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
         //locale : const Locale("en",dateformat),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: MyColors.kPrimaryColor,
                onPrimary: MyColors.black,
                surface: MyColors.white,
                onSurface: MyColors.black,
                primaryVariant: MyColors.black,
                secondary: MyColors.black,
                secondaryVariant: MyColors.black,
              ),
              dialogBackgroundColor: MyColors.white,
              textTheme: Theme.of(context).textTheme.apply(
                bodyColor: MyColors.black,
                displayColor: MyColors.black,
              ),
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      widget.controller!
        ..text = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").format(_selectedDate)
            :dateformat == "CA"?DateFormat("yyyy/MM/dd").format(_selectedDate) :DateFormat("dd/MM/yyyy").format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: widget.controller!.text.length,
            affinity: TextAffinity.upstream));
      FocusManager.instance.primaryFocus?.requestFocus();

    }
  }
}

class MyTextFieldDatePicker extends StatefulWidget {
  final ValueChanged<DateTime>? onDateChanged;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? dateFormat;
  final FocusNode? focusNode;
  final String? labelText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final TextEditingController? controller;
  final void Function(String)? onChange;
  final void Function(String)? onFieldSubmit;
  final String Function(String?)? validator;
  final void Function(String?)? onSave;

  MyTextFieldDatePicker({
    Key? key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.controller,
    this.validator,
    this.dateFormat,
    this.onChange,
    this.onSave,
    this.onFieldSubmit,
    @required this.lastDate,
    @required this.firstDate,
    @required this.initialDate,
    @required this.onDateChanged,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        assert(!initialDate!.isBefore(firstDate!),
            'initialDate must be on or after firstDate'),
        assert(!initialDate!.isAfter(lastDate!),
            'initialDate must be on or before lastDate'),
        assert(!firstDate!.isAfter(lastDate!),
            'lastDate must be on or after firstDate'),
        assert(onDateChanged != null, 'onDateChanged must not be null'),
        super(key: key);

  @override
  _MyTextFieldDatePicker createState() => _MyTextFieldDatePicker();
}

class _MyTextFieldDatePicker extends State<MyTextFieldDatePicker> {
  TextEditingController? _controllerDate;
  DateFormat? _dateFormat;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    if (widget.dateFormat != null) {
      _dateFormat = widget.dateFormat;
    } else {
      _dateFormat = DateFormat("dd-MM-yyyy");
    }

    _selectedDate = widget.initialDate;

    _controllerDate = TextEditingController();
    _controllerDate!.text = _dateFormat!.format(_selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: _controllerDate,
      decoration: InputDecoration(
        hintText: 'DD/MM/YYYY',
        counterText: '',
        border: OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
      ),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
        LengthLimitingTextInputFormatter(10),
      //  DateFormatter()
      ],
      onTap: () {
        _selectDate(context);
      },
      readOnly: false,
    );
  }

  @override
  void dispose() {
    _controllerDate!.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: widget.firstDate!,
      lastDate: widget.lastDate!,
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate!.text = _dateFormat!.format(_selectedDate!);
      widget.onDateChanged!(_selectedDate!);
    }

    if (widget.focusNode != null) {
      widget.focusNode!.nextFocus();
    }
  }
}
