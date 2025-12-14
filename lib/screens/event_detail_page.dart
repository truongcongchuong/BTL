import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/event_models.dart';
import '../services/storage_service.dart';

class EventDetailPage extends StatefulWidget {
  final EventModel? event; // null nếu thêm mới
  const EventDetailPage({super.key, this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  late TextEditingController _subjectController;
  late DateTime _startTime;
  late DateTime _endTime;
  String _recurrence = 'None';

  @override
  void initState() {
    super.initState();
    _subjectController =
        TextEditingController(text: widget.event?.subject ?? '');
    _startTime = widget.event?.startTime ?? DateTime.now();
    _endTime = widget.event?.endTime ?? DateTime.now().add(const Duration(hours: 1));
    _recurrence = widget.event?.recurrenceRule ?? 'None';
  }

  Future<void> _deleteEvent() async {
    if (widget.event != null && widget.event!.id != null) {
      await deleteEvent(widget.event!.id!);
      if (!mounted) return; 
      Navigator.pop(context, true); // trả về true để refresh list
    }
  }

  Future<void> _saveEvent() async {
    EventModel event;
    if (widget.event == null) {
      // Thêm mới
      event = EventModel(
        id: null,
        subject: _subjectController.text,
        startTime: _startTime,
        endTime: _endTime,
        recurrenceRule: _recurrence,
        note: '',
        isAllDay: false,
      );
    } else {
      // Cập nhật
      event = widget.event!;
      event.subject = _subjectController.text;
      event.startTime = _startTime;
      event.endTime = _endTime;
      event.recurrenceRule = _recurrence;
    }
    await saveEvent(event);
    if (!mounted) return; 
    Navigator.pop(context, true);
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    DateTime initial = isStart ? _startTime : _endTime;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      if (!mounted) return; 
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initial),
      );
      if (pickedTime != null) {
        setState(() {
          DateTime newDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStart) {
            _startTime = newDateTime;
            if (_endTime.isBefore(_startTime)) {
              _endTime = _startTime.add(const Duration(hours: 1));
            }
          } else {
            _endTime = newDateTime;
            if (_endTime.isBefore(_startTime)) {
              _startTime = _endTime.subtract(const Duration(hours: 1));
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? "addEvent".tr() : "detailEvent".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: "nameEvent".tr()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                      "Bắt đầu: ${DateFormat('yyyy-MM-dd HH:mm').format(_startTime)}"),
                ),
                ElevatedButton(
                  onPressed: () => _pickDateTime(isStart: true),
                  child: Text("choose".tr()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                      "${'end'.tr()}: ${DateFormat('yyyy-MM-dd HH:mm').format(_endTime)}"),
                ),
                ElevatedButton(
                  onPressed: () => _pickDateTime(isStart: false),
                  child: Text("choose".tr()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _recurrence,
              items: [
                DropdownMenuItem(value: 'None', child: Text("none".tr())),
                DropdownMenuItem(value: 'FREQ=DAILY', child: Text("dayly".tr())),
                DropdownMenuItem(value: 'FREQ=WEEKLY', child: Text("weekly".tr())),
                DropdownMenuItem(value: 'FREQ=MONTHLY', child: Text("monthly".tr())),
                DropdownMenuItem(value: 'FREQ=YEARLY', child: Text("yearly".tr())),
              ],
              onChanged: (value) {
                setState(() {
                  _recurrence = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _saveEvent,
                  child: Text(widget.event == null ?  "addEvent".tr(): "save".tr()),
                ),
                if (widget.event != null)
                  ElevatedButton(
                    onPressed: _deleteEvent,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text("delete".tr()),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
