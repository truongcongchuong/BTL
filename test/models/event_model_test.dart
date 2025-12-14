import 'package:flutter_test/flutter_test.dart';
import 'package:event_manager/models/event_models.dart';

void main() {
  test('EventModel tạo đúng dữ liệu', () {
    final event = EventModel(id: '1', subject: 'Test', startTime: DateTime.now(), endTime: DateTime.now().add(Duration(hours: 1)));
    expect(event.subject, 'Test');
  });
}
