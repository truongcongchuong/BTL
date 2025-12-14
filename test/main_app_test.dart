import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:event_manager/main.dart';
import 'package:easy_localization/easy_localization.dart';

void main() {
  testWidgets('EventApp hiển thị calendar', (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: [Locale('vi')],
        path: 'assets/translations',
        startLocale: Locale('vi'),
        child: MaterialApp(home: EventApp()),
      ),
    );

    await tester.pumpAndSettle(); // đợi widget build xong

    expect(find.byType(SfCalendar), findsOneWidget); // kiểm tra có Calendar
  });
}
