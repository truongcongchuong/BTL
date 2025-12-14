import 'package:flutter_test/flutter_test.dart';
import 'package:event_manager/models/event_models.dart';
import 'package:event_manager/services/storage_service.dart';

void main() {
  group('StorageService', () {
    test('Lưu và lấy EventModel', () async {
      final event = EventModel(
        id: 'test1',
        subject: 'Storage Test',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 1)),
      );

      await saveEvent(event); // Lưu sự kiện
      final events = await getAllEvents(); // Lấy tất cả sự kiện
      expect(events.any((e) => e.subject == 'Storage Test'), true);

      // Xóa sự kiện để reset trạng thái
      await deleteEvent('test1');
      final eventsAfterDelete = await getAllEvents();
      expect(eventsAfterDelete.any((e) => e.id == 'test1'), false);
    });
  });
}
