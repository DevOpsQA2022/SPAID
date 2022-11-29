import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:device_calendar/device_calendar.dart';

import 'package:equatable/equatable.dart';
import 'package:spaid/base/base_provider.dart';
import 'package:spaid/support/colors.dart';
import 'package:spaid/widgets/calendar_event_model.dart';
import 'package:spaid/widgets/calendar_strings.dart';

part 'calendar_state.dart';

class CalendarCubit extends BaseProvider {
   final DeviceCalendarPlugin _deviceCalendarPlugin;


  CalendarCubit(this._deviceCalendarPlugin);

  Future<List<Calendar>> loadCalendars() async {
   // emit(CalendarsLoadInProgress());
    //Added for visual purposes
    await Future.delayed(const Duration(seconds: 1));
    // Retrieve user's calendars from mobile device
    // Request permissions first if they haven't been granted
    var _calendars;
    try {
      var arePermissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (arePermissionsGranted.isSuccess && !arePermissionsGranted.data!) {
        arePermissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!arePermissionsGranted.isSuccess || !arePermissionsGranted.data!) {
         /* emit(CalendarsLoadFailure(
              CalendarStrings.noPermission));*/
          return List.empty();
        }
      }
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult?.data;
      if (_calendars.isEmpty || calendarsResult.errors.length > 0) {
        /*emit(CalendarsLoadFailure(
            CalendarStrings.noCalendars));*/
        return List.empty();
      }
    } catch (e) {
      print(e.toString());
    }
    //emit(CalendarsLoadSuccess());
    return _calendars;
  }
   Future<Result<UnmodifiableListView<Event>>> retrieveEvents(String calendarId, RetrieveEventsParams retrieveEventsParams) async {
     final eventCalendarResult =
         await _deviceCalendarPlugin.retrieveEvents(calendarId,retrieveEventsParams);
     for(int i=0;i<eventCalendarResult.data!.length;i++){
       deleteEventInstance(calendarId,eventCalendarResult.data![i].eventId!);

     }

     return eventCalendarResult;
   }
   Future<Result<String>> createCalendar() async {
     final createCalendarResult =
         await _deviceCalendarPlugin.createCalendar("Spaid",localAccountName:"Spaid",calendarColor: MyColors.kPrimaryColor );
     print(createCalendarResult.data);
     return createCalendarResult;
   }

   Future<Result<bool>> deleteCalendar(String i) async {
     final deleteCalendarResult =
         await _deviceCalendarPlugin.deleteCalendar(i.toString());
     return deleteCalendarResult;
   }
   Future<Result<bool>> deleteEventInstance(String calendarId, String eventId) async {
     final deleteCalendarResult =
         await _deviceCalendarPlugin.deleteEvent(calendarId,eventId);
     return deleteCalendarResult;
   }
  Future<void> addToCalendar(
      CalendarEventModel calendarEventModel, String selectedCalendarId) async {
   // emit(AddToCalendarInProgress());
    //Added for visual purposes
    await Future.delayed(const Duration(seconds: 2));

    final eventTime = DateTime.now();
    final eventToCreate = Event(
      selectedCalendarId,
      title: calendarEventModel.eventTitle,
      description: calendarEventModel.eventDescription,
      start: calendarEventModel.statDate,
      end: calendarEventModel.statDate!.add(Duration(hours: calendarEventModel.eventDurationInHours!)),
      location:calendarEventModel.location ,
     // eventId: calendarEventModel.eventId,
    );

    final createEventResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(eventToCreate);

    print(createEventResult!.data);

    if (createEventResult.isSuccess &&
        (createEventResult.data?.isNotEmpty ?? false)) {
     // emit(AddToCalendarSuccess('Event was successfully created.'));
    } else {
      var errorMessage =
          'Could not create : ${createEventResult.errors.toString()}';
     // emit(AddToCalendarFailure(errorMessage));
    }
  }
}
