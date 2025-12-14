// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "calendar": "Calendar",
  "searchEvent": "Search Event",
  "addEvent": "Add Event",
  "detailEvent": "Detail event",
  "dayView": "Day View",
  "weekView": "Week View",
  "monthView": "Month View",
  "workWeek": "Work week",
  "save": "Save",
  "delete": "Delete",
  "search": "Search",
  "none": "No Loop",
  "dayly": "Dayly",
  "weekly": "Weekly",
  "monthly": "Monthly",
  "yearly": "Yearly",
  "nameEvent": "Name event",
  "start": "Start",
  "choose": "Choose",
  "end": "End"
};
static const Map<String,dynamic> _vi = {
  "calendar": "Lịch",
  "searchEvent": "Tìm kiếm sự kiện",
  "addEvent": "Thêm sự kiện",
  "detailEvent": "Chi tiết sự kiện",
  "dayView": "Ngày",
  "weekView": "Tuần",
  "monthView": "Tháng",
  "workWeek": "Ngày làm việc",
  "save": "Lưu",
  "delete": "Xóa",
  "search": "Tìm kiếm",
  "none": "không lặp",
  "dayly": "Hằng ngày",
  "weekly": "Hằng tuần",
  "monthly": "Hằng tháng",
  "yearly": "Hằng năm",
  "nameEvent": "Tên sự kiện",
  "start": "Bắt đầu",
  "choose": "Chọn",
  "end": "Kết thúc"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "vi": _vi};
}
