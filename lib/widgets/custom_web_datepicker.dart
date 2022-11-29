

import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:intl/intl.dart';
import 'package:spaid/support/constants.dart';
import 'package:spaid/utils/shared_pref_manager.dart';



/// Page with [dp.DayPicker].
class DayPickerPage extends StatefulWidget {
  /// Custom events.
 // final List<Event> events;
   TextEditingController? controller;
  String? selectedYear;

  ///
  DayPickerPage({
    Key? key,
    //this.events = const [],
    this.controller,
    this.selectedYear,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DayPickerPageState();
}

class _DayPickerPageState extends State<DayPickerPage> {
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDates = DateTime.now();
  List<DateTime> _onselectedDates = [];


  DateTime _firstDate = DateTime.now().subtract(Duration(days: 45));
  DateTime _lastDate = DateTime.now().add(Duration(days: 45));

  Color selectedDateStyleColor = Colors.blue;
  Color selectedSingleDateDecorationColor = Colors.red;
  String? dateformat, first;
  String? _selectedFormat;
  bool dateChange = false;
  bool yearChange = false;
  List<String> year=[];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Color? bodyTextColor = Theme.of(context).accentTextTheme.bodyText1?.color;
    if (bodyTextColor != null) selectedDateStyleColor = bodyTextColor;

    selectedSingleDateDecorationColor = Theme.of(context).accentColor;
  }
  @override
  void initState() {
    super.initState();
    getYearCount();
    getCountryCodeAsync();
  }
  getYearCount(){
    for(int i=1967;i<2022;i++){
      year.add(i.toString());
    }
    setState(() {

    });
  }
  Future<void> getCountryCodeAsync() async {
    first = "${await SharedPrefManager.instance.getStringAsync(Constants.countryCode)}";
    setState(() {
      dateformat = first;
      print(dateformat);
    });
  }
  @override
  Widget build(BuildContext context) {
    // add selected colors to default settings
    dp.DatePickerRangeStyles styles = dp.DatePickerRangeStyles(
        selectedDateStyle: Theme.of(context)
            .accentTextTheme
            .bodyText1
            ?.copyWith(color: selectedDateStyleColor),
        selectedSingleDateDecoration: BoxDecoration(
            color: selectedSingleDateDecorationColor,
            shape: BoxShape.circle
        ),
        dayHeaderStyle: DayHeaderStyle(
            textStyle: TextStyle(
                color: Colors.red
            )
        )
    );

    return Flex(
      direction: MediaQuery.of(context).orientation == Orientation.portrait
          ? Axis.vertical
          : Axis.horizontal,
      children: <Widget>[
        yearChange==false ?
        Expanded(
          child: SizedBox(
            height: 200,
            child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 16/4,
                children: List.generate(year.length, (index) {
                  return Center(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          _selectedDates = DateFormat("yyyy").parse(year[index]);
                          yearChange=true;
                          print(year[index]);
                        });
                      },
                        child: Text(year[index])),
                  );
                }
                )
            ),
          ),
        ):
        dateChange == false ?
        Expanded(
          child: dp.MonthPicker.single(
            selectedDate: _selectedDates,
            onChanged: _onSelectedDateChanged,
            firstDate: DateTime(1967),
            lastDate: DateTime(2022),
            datePickerStyles: styles,
          ),
        )
            :
        Expanded(
          child: dp.DayPicker.single(
            selectedDate: widget.controller!.text.isNotEmpty? DateFormat("dd/MM/yyyy").parse(widget.controller!.text): _selectedDate,
            //selectedDates: _onselectedDates,
            onChanged: _onSelectedDateChanged,
            firstDate: DateTime(1967),
            lastDate: DateTime(2022),

            //initiallyShowDate: DateFormat("yyyy").parse(widget.selectedYear),
            initiallyShowDate: DateFormat("dd/MM/yyyy").parse(widget.controller!.text),
            datePickerStyles: styles,
            datePickerLayoutSettings: dp.DatePickerLayoutSettings(
              maxDayPickerRowCount: 5,
              showPrevMonthEnd: true,
              showNextMonthStart: true,

            ),
            selectableDayPredicate: _isSelectableCustom,
            // eventDecorationBuilder: _eventDecorationBuilder,
          ),
        )

      ],
    );
  }
/*
  void _onSelectedDatesChanged(List<DateTime> newDates) {
    setState(() {
      if(_onselectedDates.length>0){
        _onselectedDates.clear();
      }
      _onselectedDates = newDates;
      widget.controller
        ..text = dateformat == "US"
            ? DateFormat("mm/dd/yyyy").format(_onselectedDates.first)
            : DateFormat("dd/mm/yyyy").format(_onselectedDates.first)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: widget.controller.text.length,
            affinity: TextAffinity.upstream));
    });
  }*/


  void _onSelectedDateChanged(DateTime newDate) {
    setState(() {
      dateChange = true;
      _selectedDate = newDate;
      print(newDate);
      _selectedFormat =  DateFormat("yyyy").format(newDate);
      print(_selectedFormat);
      // _selectedDates = DateFormat("yyyy").format(_selectedDate);
      widget.selectedYear = _selectedFormat;
      widget.controller!
        ..text = dateformat == "US"
            ? DateFormat("MM/dd/yyyy").format(_selectedDate)
            :dateformat == "CA"?DateFormat("yyyy/MM/dd").format(_selectedDate)
            : DateFormat("dd/MM/yyyy").format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: widget.controller!.text.length,
            affinity: TextAffinity.upstream));
    });
  }

  // ignore: prefer_expression_function_bodies
  bool _isSelectableCustom (DateTime day) {
    return day.weekday <= 7;
  }

// dp.EventDecoration _eventDecorationBuilder(DateTime date) {
//   List<DateTime> eventsDates = widget.events
//       .map<DateTime>((Event e) => e.date)
//       .toList();
//
//   bool isEventDate = eventsDates.any((DateTime d) =>
//   date.year == d.year
//       && date.month == d.month
//       && d.day == date.day);
//
//   BoxDecoration roundedBorder = BoxDecoration(
//       border: Border.all(
//         color: Colors.deepOrange,
//       ),
//       borderRadius: BorderRadius.all(Radius.circular(3.0))
//   );
//
//   return isEventDate
//       ? dp.EventDecoration(boxDecoration: roundedBorder)
//       : null;
// }
}