class EventModel {
  String? id;
  DateTime startTime;
  DateTime endTime;
  bool isAllDay;
  String subject;
  String? note;
  String? recurrenceRule;

  EventModel({
    this.id,
    required this.startTime,
    required this.endTime,
    this.isAllDay = false,
    this.subject = "",
    this.note,
    this.recurrenceRule,
  });
}
extension EventModelMap on EventModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isAllDay': isAllDay,
      'subject': subject,
      'note': note,
      'recurrenceRule': recurrenceRule,
    };
  }

  static EventModel fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id']?.toString(), // đảm bảo là String hoặc null
      startTime: map['startTime'] != null
          ? DateTime.parse(map['startTime'])
          : DateTime.now(), // fallback nếu null
      endTime: map['endTime'] != null
          ? DateTime.parse(map['endTime'])
          : DateTime.now().add(const Duration(hours: 1)),
      isAllDay: map['isAllDay'] ?? false,
      subject: map['subject'] ?? '',
      note: map['note'],
      recurrenceRule: map['recurrenceRule'],
    );
  }
}
