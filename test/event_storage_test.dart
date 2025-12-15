import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'dart:io';
import 'package:event_manager/services/storage_service.dart';
import 'package:event_manager/models/event_models.dart';

Future<void> clearEvents() async {
  final all = await db.collection(collectionName).get();
  if (all != null) {
    for (final key in all.keys) {
      await db.collection(collectionName).doc(key).delete();
    }
  }
}
Future<void> silencePrint(Future<void> Function() action) async {
  final spec = ZoneSpecification(
    print: (self, parent, zone, line) {},
  );

  await Zone.current.fork(specification: spec).run(action);
}
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EventModel Localstore CRUD Test', () {
    setUp(() async {
      await clearEvents();
    });

    test('Create - saveEvent should store event', () async {
      final event = EventModel(
        startTime: DateTime(2025, 1, 1, 8),
        endTime: DateTime(2025, 1, 1, 9),
        subject: 'Morning meeting',
      );

      await saveEvent(event);

      final events = await getAllEvents();

      expect(
        events.any((e) => e.subject == 'Morning meeting'),
        true,
      );
    });


    test('Read - getAllEvents should return stored events', () async {
      final event = EventModel(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        subject: 'Workshop',
      );

      await saveEvent(event);

      final events = await getAllEvents();

      expect(events.isNotEmpty, true);
    });

    test('Update - saveEvent should update existing event', () async {
      final event = EventModel(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        subject: 'Old subject',
      );

      await saveEvent(event);

      final saved = (await getAllEvents()).first;

      saved.subject = 'Updated subject';
      saved.isAllDay = true;

      await saveEvent(saved);

      final updated = (await getAllEvents()).first;

      expect(updated.subject, 'Updated subject');
      expect(updated.isAllDay, true);
    });

    test('Delete - deleteEvent should remove event', () async {
      final event = EventModel(
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        subject: 'Temp event',
      );

      await saveEvent(event);

      final saved = (await getAllEvents())
          .firstWhere((e) => e.subject == 'Temp event');

      await deleteEvent(saved.id!);

      final events = await getAllEvents();

      expect(
        events.any((e) => e.id == saved.id),
        false,
      );
    });
  });
}
