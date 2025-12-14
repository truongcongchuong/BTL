import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'events/event_data_source.dart';
import 'screens/add_event.dart';
import 'screens/event_detail_page.dart';
import 'models/event_models.dart';
import 'services/storage_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      ignorePluralRules: false,
      supportedLocales: [Locale('vi'), Locale('en')],
      path: 'assets/translations',
      assetLoader: const CodegenLoader(),
      startLocale: Locale('vi'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: EventApp(),
    );
  }
}

class EventApp extends StatefulWidget {
  const EventApp({super.key});

  @override
  State<EventApp> createState() => _EventAppState();
}

class _EventAppState extends State<EventApp> {
  CalendarView _currentView = CalendarView.month;
  TextEditingController search = TextEditingController();
  Locale currentLocale = Locale('vi');
  List<EventModel> listEvents = [];
  List<EventModel> originalEvents = []; 

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentLocale = context.locale; 
  }

  Future<void> _loadEvents() async {
    final events = await getAllEvents();
    setState(() {
      listEvents = events;
      originalEvents = List.from(events);
      isLoading = false;
    });
  }

  void _filterEvents(String query) {
    setState(() {
      if (query.isEmpty) {
        listEvents = List.from(originalEvents);
      } else {
        listEvents = originalEvents
            .where((e) => e.subject.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("calendar".tr()),

        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                  labelText: "search".tr(),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
                onChanged: _filterEvents,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'Day':
                    _currentView = CalendarView.day;
                    break;
                  case 'Week':
                    _currentView = CalendarView.week;
                    break;
                  case 'WorkWeek':
                    _currentView = CalendarView.workWeek;
                    break;
                  case 'Month':
                    _currentView = CalendarView.month;
                    break;
                }
              });
            },
            itemBuilder: (context) =>  [
              PopupMenuItem(value: 'Day', child: Text("dayView".tr())),
              PopupMenuItem(value: 'Week', child: Text("weekView".tr())),
              PopupMenuItem(value: 'WorkWeek', child: Text("workWeek".tr())),
              PopupMenuItem(value: 'Month', child: Text("monthView".tr())),
            ],
          ),
          DropdownButton<Locale>(
            value: context.locale, // dùng trực tiếp context.locale
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(value: Locale('vi'), child: Text('Tiếng Việt')),
              DropdownMenuItem(value: Locale('en'), child: Text('English')),
            ],
            onChanged: (locale) {
              if (locale != null) {
                context.setLocale(locale); // chuyển ngôn ngữ ngay
              }
            },
          ),
        ],
      ),
      body: SfCalendar(
        key: ValueKey(_currentView),
        view: _currentView,
        dataSource: EventDataSource(listEvents),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment) {
            final Appointment appt = details.appointments!.first;
            final EventModel event = EventModel(
              id: appt.id.toString(),
              startTime: appt.startTime,
              endTime: appt.endTime,
              subject: appt.subject,
              note: appt.notes,
              recurrenceRule: appt.recurrenceRule,
              isAllDay: appt.isAllDay,
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventDetailPage(event: event)),
            ).then((_) async {
              _loadEvents();
            });
          } else if (details.targetElement == CalendarElement.calendarCell) {
            final selectedDate = details.date!;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEventPage(selectedDate: selectedDate)),
            ).then((_) async {
               _loadEvents();
              }); 
            }
        },
      ),
    );
  }
}
