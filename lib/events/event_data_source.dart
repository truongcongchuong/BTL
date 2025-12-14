import '../models/event_models.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventModel> source) {
    // Map EventModel -> Appointment
    appointments = source.map((e) {
      return Appointment(
        id: e.id,
        startTime: e.startTime,
        endTime: e.endTime,
        subject: e.subject,
        notes: e.note,
        isAllDay: e.isAllDay,
        recurrenceRule: e.recurrenceRule, // giữ nguyên RRULE
      );
    }).toList();
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].subject;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String? getNotes(int index) {
    return appointments![index].notes;
  }

  @override
  String? getRecurrenceRule(int index) {
    return appointments![index].recurrenceRule;
  }
}
