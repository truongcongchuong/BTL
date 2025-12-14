import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../models/event_models.dart';
import '../services/storage_service.dart';

class AddEventPage extends StatefulWidget {
  final DateTime selectedDate;

  const AddEventPage({super.key, required this.selectedDate});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _subjectController = TextEditingController();
  late DateTime _startTime;
  late DateTime _endTime;
  String _recurrence = 'None';

  @override
  void initState() {
    super.initState();
    _startTime = widget.selectedDate;
    _endTime = widget.selectedDate.add(const Duration(hours: 1));
  }
  Future<void> addEvent(EventModel event) async {
    await saveEvent(event);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("addEvent".tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: "start".tr()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text("start".tr()+": $_startTime")),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _startTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_startTime),
                      );
                      if (pickedTime != null) { 
                        setState(() {
                          _startTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Text("choose".tr()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text("${'end'.tr()} + : $_endTime")),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _endTime,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      if (!mounted) return; 
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_endTime),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _endTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Text("choose".tr()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _recurrence,
              items:  [
                DropdownMenuItem(value: 'None', child: Text("none".tr())),
                DropdownMenuItem(value: 'DAILY', child: Text("dayly".tr())),
                DropdownMenuItem(value: 'WEEKLY', child: Text("weekly".tr())),
                DropdownMenuItem(value: 'MONTHLY', child: Text("monthly".tr())),
                DropdownMenuItem(value: 'YEARLY', child: Text("yearly".tr())),
              ],
              onChanged: (value) {
                setState(() {
                  _recurrence = value!;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                String? rule;
                switch (_recurrence) {
                  case 'DAILY':
                    rule = 'FREQ=DAILY';
                    break;
                  case 'WEEKLY':
                    rule = 'FREQ=WEEKLY';
                    break;
                  case 'MONTHLY':
                    rule = 'FREQ=MONTHLY';
                    break;
                  case 'YEARLY':
                    rule = 'FREQ=YEARLY';
                    break;
                }

                final newEvent = EventModel(
                  subject: _subjectController.text,
                  startTime: _startTime,
                  endTime: _endTime,
                  recurrenceRule: rule,
                );

                // Thêm vào danh sách sự kiện
                addEvent(newEvent);

                Navigator.pop(context); // quay về Calendar
              },
              child: Text("save".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
