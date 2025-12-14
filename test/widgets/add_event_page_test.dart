import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:event_manager/screens/add_event.dart';
import 'package:easy_localization/easy_localization.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AddEventPage hiển thị và thêm sự kiện', (WidgetTester tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: [Locale('en'), Locale('vi')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MaterialApp(home: AddEventPage(selectedDate: DateTime.now())),
      ),
    );

    await tester.pumpAndSettle();

    // Kiểm tra các field cơ bản
    expect(find.byType(TextField), findsWidgets);

    // Nhập dữ liệu vào tên sự kiện
    await tester.enterText(find.byKey(Key('eventName')), 'Test Event');
    await tester.pump();

    // Nhấn nút save
    await tester.tap(find.byKey(Key('saveButton')));
    await tester.pumpAndSettle();

    // Kiểm tra thông báo thành công hiển thị (SnackBar)
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
