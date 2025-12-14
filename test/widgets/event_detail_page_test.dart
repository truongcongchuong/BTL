import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_manager/screens/event_detail_page.dart';
import 'package:event_manager/models/event_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('EventDetailPage hiển thị chi tiết sự kiện', (WidgetTester tester) async {
    final testEvent = EventModel(
      id: '1',
      subject: 'Detail Test',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 1)),
      note: 'Test description',
    );

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('vi')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        startLocale: Locale('en'), // bắt buộc khi test
        child: MaterialApp(home: EventDetailPage(event: testEvent)),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Detail Test'), findsOneWidget);
    expect(find.text('Test description'), findsOneWidget);
  });
}
