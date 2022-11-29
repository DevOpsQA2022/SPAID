import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/support/icons.dart';
import 'package:spaid/support/images.dart';
import 'package:spaid/support/strings.dart';
import 'package:spaid/support/style_sizes.dart';
import 'package:spaid/ui/add_event_screen/add_event_provider.dart';
import 'package:spaid/utils/code_snippet.dart';
import 'package:spaid/utils/shared_pref_manager.dart';
import 'package:spaid/widgets/custom_appbar.dart';
import 'package:spaid/widgets/custom_background/custom_tab_bar.dart';
import 'package:spaid/widgets/custom_background/custom_web_background_card.dart';
import 'package:spaid/widgets/custom_datepicker.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:weekday_selector/weekday_selector.dart';

class RepeatScreen extends StatefulWidget {
  bool isEdit;
  RepeatScreen(this.isEdit);

  @override
  _RepeatScreenState createState() => _RepeatScreenState();
}

class _RepeatScreenState extends State<RepeatScreen>
    with SingleTickerProviderStateMixin {
  //region Private Members

  bool showFlagColor = false;
  bool showHomeAway = false;
  bool showTimezone = false;
  bool arriveEarlyColor = false;
  bool showduration = false;
  bool showDateTime = false;

  TextEditingController searchController = TextEditingController();

  // Group Value for Radio Button.
  String id = "";

  DateTime _dateTime = DateTime.now();

  TextEditingController? StartDatePickerController;
  TextEditingController? EndDatePickerController;
  var weekdayvalues = List.filled(7, false);
  String repeatvalue = MyStrings.doesNotRepeat;
  bool _webDatePicker = false;
  bool _webDatePicker1 = false;

  DateTime? _selectedDate ;
  DateTime? _selectedEndDate ;
  AddEventProvider? _addEventProvider;
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  String? dateformat, first;

//endregion
  @override
  initState() {
    super.initState();
    print(_dateTime.timeZoneName);
    _addEventProvider = Provider.of<AddEventProvider>(context, listen: false);
    StartDatePickerController = TextEditingController();
    EndDatePickerController = TextEditingController();
    getCountryCodeAsyncs();
    StartDatePickerController = _addEventProvider!.StartDatePickerController;
    EndDatePickerController = _addEventProvider!.EndDatePickerController;
    try {
      _selectedDate = DateFormat('dd/MM/yyyy').parse(_addEventProvider!.StartDatePickerController!.text);
      _selectedEndDate = DateFormat('dd/MM/yyyy').parse(_addEventProvider!.EndDatePickerController!.text);
    } catch (e) {
      print(e);
    }
    weekdayvalues = _addEventProvider!.weekdayvalues;
    repeatvalue = _addEventProvider!.repeatvalue;
  }

  Future<void> getCountryCodeAsyncs() async {
    first =
        "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value;
        // DatepickerController.text = _selectedDate.toString();
        StartDatePickerController!
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedDate!)
              : dateformat == "CA"
                  ? DateFormat("yyyy/MM/dd").format(_selectedDate!)
                  : DateFormat("dd/MM/yyyy").format(_selectedDate!)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: StartDatePickerController!.text.length,
              affinity: TextAffinity.upstream));

        print("ll" + _selectedDate.toString());
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
      _webDatePicker == true ? _webDatePicker = false : _webDatePicker = true;
    });
  }

  void _onSelectionChange(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedEndDate = args.value;
        // DatepickerController.text = _selectedDate.toString();
        EndDatePickerController!
          ..text = dateformat == "US"
              ? DateFormat("MM/dd/yyyy").format(_selectedEndDate!)
              : dateformat == "CA"
                  ? DateFormat("yyyy/MM/dd").format(_selectedEndDate!)
                  : DateFormat("dd/MM/yyyy").format(_selectedEndDate!)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: EndDatePickerController!.text.length,
              affinity: TextAffinity.upstream));

        print("ll" + _selectedEndDate.toString());
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
      _webDatePicker1 == true
          ? _webDatePicker1 = false
          : _webDatePicker1 = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TopBar(
      child: Row(
        children: [
          if (getValueForScreenType<bool>(
            context: context,
            mobile: false,
            tablet: false,
            desktop: false,
          ))
            Expanded(
              child: Image.asset(
                MyImages.signin,
                height: size.height * ImageSize.signInImageSize,
              ),
            ),
          Expanded(
            child: WebCard(
              marginVertical: 20,
              marginhorizontal: 40,
              child: Scaffold(
                backgroundColor: MyColors.white,
                appBar: CustomAppBar(
                  title: MyStrings.repeats,
                  iconLeft: MyIcons.cancel,
                  tooltipMessageLeft: MyStrings.cancel,
                  iconRight: MyIcons.done,
                  tooltipMessageRight: MyStrings.save,
                  onClickRightImage: () {
                    try {
                      if (repeatvalue == MyStrings.doesNotRepeat) {
                        _addEventProvider!.repeatvalue = repeatvalue;
                        _addEventProvider!.setRefreshScreen();
                        Navigator.of(context).pop();
                      } else {
                        DateTime startDate = dateformat == "US"
                            ? DateFormat("MM/dd/yyyy")
                                .parse(StartDatePickerController!.text)
                            : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd")
                                    .parse(StartDatePickerController!.text)
                                : DateFormat("dd/MM/yyyy")
                                    .parse(StartDatePickerController!.text);
                        DateTime endDate = dateformat == "US"
                            ? DateFormat("MM/dd/yyyy")
                                .parse(EndDatePickerController!.text)
                            : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd")
                                    .parse(EndDatePickerController!.text)
                                : DateFormat("dd/MM/yyyy")
                                    .parse(EndDatePickerController!.text);
                        //DateFormat("yMd").parse(DateFormat('yMd').format(DateTime.now()));
                        DateTime now = dateformat == "US"
                            ? DateFormat("MM/dd/yyyy").parse(
                                DateFormat("MM/dd/yyyy").format(DateTime.now()))
                            : dateformat == "CA"
                                ? DateFormat("yyyy/MM/dd").parse(
                                    DateFormat("yyyy/MM/dd")
                                        .format(DateTime.now()))
                                : DateFormat("dd/MM/yyyy").parse(
                                    DateFormat("dd/MM/yyyy")
                                        .format(DateTime.now()));
                        if (startDate.compareTo(now) >= 0 &&
                            endDate.compareTo(now) >= 0) {
                          if (startDate.compareTo(endDate) < 0) {
                            if (repeatvalue == MyStrings.weekly) {
                              bool isWeekSelected = false;
                              List<String> daysList=[];
                              String selectedDays="";
                              for (int i = 0;
                                  i < weekdayvalues.toList().length;
                                  i++) {
                                if (weekdayvalues[i] == true) {
                                  isWeekSelected = true;
                                  daysList.add(i==0?"Sun":i==1?"Mon":i==2?"Tue":i==3?"Wed":i==4?"Thu":i==5?"Fri":"Sat");
                                }
                              }
                              for(int i=0;i<daysList.length;i++){
                                if(daysList.length-1==i){
                                  selectedDays=selectedDays+" "+daysList[i];
                                }else{
                                  selectedDays=selectedDays+" "+daysList[i]+",";
                                }
                              }
                              if (isWeekSelected) {
                                _addEventProvider!.StartDatePickerController =
                                    StartDatePickerController;
                                _addEventProvider!.EndDatePickerController =
                                    EndDatePickerController;
                                _addEventProvider!.weekdayvalues = weekdayvalues;
                                _addEventProvider!.repeatvalue = repeatvalue;
                                _addEventProvider!.selectedDays = selectedDays;
                                _addEventProvider!.setRefreshScreen();
                                Navigator.of(context).pop();
                              } else {
                                CodeSnippet.instance.showMsg("Select days");
                              }
                            } else {
                              _addEventProvider!.StartDatePickerController =
                                  StartDatePickerController;
                              _addEventProvider!.EndDatePickerController =
                                  EndDatePickerController;
                              _addEventProvider!.weekdayvalues = weekdayvalues;
                              _addEventProvider!.repeatvalue = repeatvalue;
                              _addEventProvider!.setRefreshScreen();
                              Navigator.of(context).pop();
                            }
                          } else {
                            CodeSnippet.instance.showMsg(
                                "The end date must be after the start date.");
                          }
                        } else {
                          /* ValidateInput.requiredFieldsDate(startDate,endDate,DateTime.now());
                                            ValidateInput.requiredFieldsDate(startDate,endDate,DateTime.now());*/
                          if (startDate.compareTo(endDate) <= 0) {
                            CodeSnippet.instance.showMsg(
                                "The start date must be on or after the current date.");
                          } else {
                            CodeSnippet.instance.showMsg(
                                "The end date must be after the start date.");
                          }
                        }
                      }
                    } catch (e) {
                      print(e);
                      CodeSnippet.instance.showMsg("Select Date");
                    }
                  },
                  onClickLeftImage: () {
                    Navigator.of(context).pop();
                  },
                ),
                body: SizedBox(
                  height: 870,
                  child: Padding(
                    padding: EdgeInsets.all(getValueForScreenType<bool>(
                      context: context,
                      mobile: false,
                      tablet: true,
                      desktop: true,
                    )
                        ? PaddingSize.headerPadding1
                        : PaddingSize.headerPadding2),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: new Column(children: <Widget>[
                        // if(!widget.isEdit)
                        ListTile(
                          title: Text(MyStrings.doesNotRepeat),
                          leading: Radio(
                            value: MyStrings.doesNotRepeat,
                            groupValue: repeatvalue,
                            activeColor: MyColors.kPrimaryColor,
                            onChanged: (String? value) {
                              setState(() {
                                if(!widget.isEdit) {
                                  repeatvalue = value!;
                                }
                              });
                            },
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // if(!widget.isEdit)
                              SizedBox(
                                width: getValueForScreenType<bool>(
                                  context: context,
                                  mobile: false,
                                  tablet: false,
                                  desktop: true,
                                )
                                    ? MediaQuery.of(context).size.width / 8
                                    : getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: false,
                                      )
                                        ? MediaQuery.of(context).size.width / 6
                                        : MediaQuery.of(context).size.width / 2,
                                child: ListTile(
                                  title: Text(MyStrings.weekly),
                                  leading: Radio(
                                    value: MyStrings.weekly,
                                    groupValue: repeatvalue,
                                    activeColor: MyColors.kPrimaryColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        if(!widget.isEdit) {
                                          repeatvalue = value!;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // if(!widget.isEdit)
                              SizedBox(
                                width: getValueForScreenType<bool>(
                                  context: context,
                                  mobile: false,
                                  tablet: false,
                                  desktop: true,
                                )
                                    ? MediaQuery.of(context).size.width / 8
                                    : getValueForScreenType<bool>(
                                        context: context,
                                        mobile: false,
                                        tablet: true,
                                        desktop: false,
                                      )
                                        ? MediaQuery.of(context).size.width / 5
                                        : MediaQuery.of(context).size.width / 2,
                                child: ListTile(
                                  title: Text(MyStrings.daily),
                                  leading: Radio(
                                    value: MyStrings.daily,
                                    groupValue: repeatvalue,
                                    activeColor: MyColors.kPrimaryColor,
                                    onChanged: (String? value) {
                                      setState(() {
                                        if(!widget.isEdit) {
                                          repeatvalue = value!;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ]),
                        repeatvalue == MyStrings.weekly ||
                                repeatvalue == MyStrings.daily
                            ? Padding(
                                padding: const EdgeInsets.all(
                                    PaddingSize.boxPaddingAllSide),
                                child: Column(
                                  children: [
                                    DatePickerTextfieldWidget(
                                      suffixIcon: MyIcons.calendar,
                                      labelText: MyStrings.startDate,
                                      controller: StartDatePickerController,
                                      inputAction: TextInputAction.next,
                                      // isEnabled: widget.isEdit?false:true,
                                      //validator: ValidateInput.requiredStartDateFields,
                                      onTab: () {
                                        setState(() {
                                          _webDatePicker == true
                                              ? _webDatePicker = false
                                              : _webDatePicker = true;
                                          _webDatePicker1 == true
                                              ? _webDatePicker1 = false
                                              : _webDatePicker1 = false;
                                        });
                                      },
                                      onSave: (value) {
                                        StartDatePickerController!.text = value!;
                                        // print(provider.startDateController.text);

                                        print(value);
                                      },
                                    ),
                                  ],
                                ),
                                /*DatePickerTextfieldWidget(
                                          suffixIcon: MyIcons.calendar,
                                          labelText: MyStrings.startDate,
                                          controller:
                                              StartDatePickerController,
                                          //validator: ValidateInput.verifyDOB,
                                          onSave: (value) {
                                            StartDatePickerController.text =
                                                value;
                                            // print(provider.startDateController.text);
                                            print(value);
                                          },
                                        ),*/
                              )
                            : Container(),
                        Stack(
                          children: [
                            repeatvalue == MyStrings.weekly ||
                                    repeatvalue == MyStrings.daily
                                ? Padding(
                                    padding: const EdgeInsets.all(
                                        PaddingSize.boxPaddingAllSide),
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            DatePickerTextfieldWidget(
                                              suffixIcon: MyIcons.calendar,
                                              labelText: MyStrings.endDate,
                                              controller:
                                                  EndDatePickerController,
                                              inputAction: TextInputAction.done,
                                              isEnabled: widget.isEdit?false:true,
                                              //validator: ValidateInput.requiredEndDateFields,
                                              onTab: () {
                                                setState(() {
                                                  _webDatePicker1 == true
                                                      ? _webDatePicker1 = false
                                                      : _webDatePicker1 = true;
                                                  _webDatePicker == true
                                                      ? _webDatePicker = false
                                                      : _webDatePicker = false;
                                                });
                                              },

                                              onSave: (value) {
                                                EndDatePickerController!.text =
                                                    value!;
                                                // print(provider.startDateController.text);

                                                print(value);
                                              },
                                            ),
                                            Stack(
                                              children: [
                                                repeatvalue == MyStrings.weekly
                                                    ? WeekdaySelector(
                                                        elevation: PaddingSize
                                                            .cardElevation,
                                                        /* shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimens.standard_12)),*/
                                                        onChanged: (int day) {
                                                          setState(() {
                                                            // Use module % 7 as Sunday's index in the array is 0 and
                                                            // DateTime.sunday constant integer value is 7.
                                                            final index =
                                                                day % 7;
                                                            // We "flip" the value in this example, but you may also
                                                            // perform validation, a DB write, an HTTP call or anything
                                                            // else before you actually flip the value,
                                                            // it's up to your app's needs.
                                                            print(index);
                                                            if(!widget.isEdit) {
                                                              weekdayvalues[
                                                              index] =
                                                              !weekdayvalues[
                                                              index];
                                                            }
                                                          });
                                                        },
                                                        values: weekdayvalues,
                                                      )
                                                    : Container(),
                                                _webDatePicker1 == true &&
                                                        getValueForScreenType<
                                                            bool>(
                                                          context: context,
                                                          mobile: false,
                                                          tablet: true,
                                                          desktop: true,
                                                        )
                                                    ? Container(
                                                        width: 330,
                                                        child: Card(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 3.0,
                                                                  left: 0.0,
                                                                  top: 0.0,
                                                                  bottom: 30.0),
                                                          elevation: 10,
                                                          shadowColor: MyColors
                                                              .colorGray_666BC,
                                                          child:
                                                              SfDateRangePicker(
                                                            initialDisplayDate:
                                                            _selectedEndDate !=
                                                                        null
                                                                    ? _selectedEndDate
                                                                    : null,
                                                                initialSelectedDate:
                                                                _selectedEndDate !=
                                                                    null
                                                                    ? _selectedEndDate
                                                                    : null,
                                                            view:
                                                                DateRangePickerView
                                                                    .month,
                                                            todayHighlightColor:
                                                                MyColors.red,
                                                            allowViewNavigation:
                                                                true,
                                                            showNavigationArrow:
                                                                true,
                                                            navigationMode:
                                                                DateRangePickerNavigationMode
                                                                    .snap,
                                                            endRangeSelectionColor:
                                                                MyColors
                                                                    .kPrimaryColor,
                                                            rangeSelectionColor:
                                                                MyColors
                                                                    .kPrimaryColor,
                                                            selectionColor:
                                                                MyColors
                                                                    .kPrimaryColor,
                                                            startRangeSelectionColor:
                                                                MyColors
                                                                    .kPrimaryColor,
                                                            onSelectionChanged:
                                                                _onSelectionChange,
                                                            selectionMode:
                                                                DateRangePickerSelectionMode
                                                                    .single,
                                                            onSubmit: (value) {
                                                              EndDatePickerController!.text =
                                                                  value.toString();
                                                            },
                                                            initialSelectedRange: PickerDateRange(
                                                                DateTime.now().subtract(
                                                                    const Duration(
                                                                        days:
                                                                            4)),
                                                                DateTime.now().add(
                                                                    const Duration(
                                                                        days:
                                                                            3))),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            _webDatePicker == true &&
                                    getValueForScreenType<bool>(
                                      context: context,
                                      mobile: false,
                                      tablet: true,
                                      desktop: true,
                                    )
                                ? Container(
                                    width: 330,
                                    child: Card(
                                      margin: const EdgeInsets.only(
                                          right: 3.0,
                                          left: 0.0,
                                          top: 0.0,
                                          bottom: 30.0),
                                      elevation: 10,
                                      shadowColor: MyColors.colorGray_666BC,
                                      child: SfDateRangePicker(
                                        initialDisplayDate:
                                            _selectedDate != null
                                                ? _selectedDate
                                                : null,
                                        initialSelectedDate:
                                        _selectedDate !=
                                            null
                                            ? _selectedDate
                                            : null,
                                        view: DateRangePickerView.month,
                                        todayHighlightColor: MyColors.red,
                                        allowViewNavigation: true,
                                        showNavigationArrow: true,
                                        navigationMode:
                                            DateRangePickerNavigationMode.snap,
                                        endRangeSelectionColor:
                                            MyColors.kPrimaryColor,
                                        rangeSelectionColor:
                                            MyColors.kPrimaryColor,
                                        selectionColor: MyColors.kPrimaryColor,
                                        startRangeSelectionColor:
                                            MyColors.kPrimaryColor,
                                        onSelectionChanged: _onSelectionChanged,
                                        selectionMode:
                                            DateRangePickerSelectionMode.single,
                                        onSubmit: (value) {
                                          StartDatePickerController!.text = value.toString();
                                        },
                                        initialSelectedRange: PickerDateRange(
                                            DateTime.now().subtract(
                                                const Duration(days: 4)),
                                            DateTime.now()
                                                .add(const Duration(days: 3))),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



