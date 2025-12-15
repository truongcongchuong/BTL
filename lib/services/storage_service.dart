import 'package:localstore/localstore.dart';
import '../models/event_models.dart';

final db = Localstore.instance;
const String collectionName = 'events';


// Lưu hoặc cập nhật sự kiện
Future<void> saveEvent(EventModel event) async {
  final id = event.id ?? DateTime.now().millisecondsSinceEpoch.toString();
  event.id = id;
  await db.collection(collectionName).doc(id).set(event.toMap());
}

// Lấy tất cả sự kiện
Future<List<EventModel>> getAllEvents() async {
  final all = await db.collection(collectionName).get();
  if (all == null) return [];
  return all.values.map((e) => EventModelMap.fromMap(e)).toList();
}

// Xóa sự kiện
Future<void> deleteEvent(String id) async {
  await db.collection(collectionName).doc(id).delete();
}
