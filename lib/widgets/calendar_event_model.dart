import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class CalendarEventModel extends Equatable {
  final String? eventTitle;
  final String? eventDescription;
  final String? location;
  final int? eventDurationInHours;
  final DateTime? statDate;

  const CalendarEventModel({
    @required this.eventTitle,
    @required this.eventDescription,
    @required this.statDate,
    @required this.location,
    @required this.eventDurationInHours
  });

  @override
  List<Object> get props => [
    eventTitle!,
    eventDescription!,
    statDate!,
    location!,
    eventDurationInHours!
  ];
}
