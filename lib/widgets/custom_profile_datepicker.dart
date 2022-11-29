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

class DatePickerProfileWidget extends StatefulWidget {
  DatePickerProfileWidget(
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
        this.inputAction = TextInputAction.go,
        this.focusNode,
        this.onChange,
        this.onFieldSubmit,
        this.prefixImage,
        this.prefixIcon,
        this.helperText,
        this.validator,
        this.onTab,
        this.onSave,
        this.groupText});

  final String? labelText;
  final String? prefix;
  final bool? isPwdType;
  final bool? isBoolType;
  final String? errorText;
  final bool? isEnabled;
  final Icon? suffixImage;
  final Icon? prefixIcon;
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
  final String Function(String?)? validator;
  final void Function(String?)? onSave;
  final VoidCallback? onTab;
  final String? groupText;


  @override
  _DatePickerProfileWidgetState createState() =>
      _DatePickerProfileWidgetState();
}

class _DatePickerProfileWidgetState extends State<DatePickerProfileWidget> {
  DateTime _selectedDate = DateTime.now();

  // TextEditingController _textEditingController = TextEditingController();
  String? dateformat, first;
  bool _webDatePicker = false;

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
    return Container(
      // height: Dimens.standard_70,
      child: GestureDetector(
        // onTap: widget.onTap,
        child: Card(
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: widget.suffixImage,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupText == null ? " " : widget.groupText!,
                      style: TextStyle(
                          letterSpacing: Dimens.letterSpacing_25,
                          color: MyColors.colorGray_818181),
                    ),
                    SizedBox(
                      height: 40,

                      child: TextFormField(
                          showCursor: false,
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
                          focusNode: widget.focusNode,
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
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimens.dp_8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
    String languageCode = Localizations.localeOf(context).toLanguageTag();
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2040),
        // locale : const Locale("en","EN"),
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
                secondaryVariant: MyColors.colorGray_818181,
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
            :dateformat == "CA"?DateFormat("yyyy/MM/dd").format(_selectedDate)
            : DateFormat("dd/MM/yyyy").format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: widget.controller!.text.length,
            affinity: TextAffinity.upstream));
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
