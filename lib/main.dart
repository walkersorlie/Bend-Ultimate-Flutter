import 'package:bend_ultimate_flutter/controllers/bindings/event_binding.dart';
import 'package:bend_ultimate_flutter/controllers/bindings/event_form_binding.dart';
import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/screens/create_ultimate_event_screen.dart';
import 'package:bend_ultimate_flutter/screens/ultimate_event_details_screen.dart';
import 'package:bend_ultimate_flutter/screens/unknown_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: ErrorWidget.withDetails(error: snapshot.error));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            initialRoute: '/',
            initialBinding: EventBinding(),
            unknownRoute: GetPage(
              name: '/404',
              page: () => UnknownScreen(),
            ),
            getPages: [
              GetPage(
                name: '/',
                page: () => HomepageCalendar(title: 'Calendar'),
                binding: EventBinding(),
              ),
              GetPage(
                name: '/events/create',
                page: () => CreateUltimateEventScreen(),
                binding: EventFormBinding(),
              ),
              GetPage(
                name: '/events/details/:id',
                page: () => UltimateEventDetailsScreen(),
                binding: EventBinding(),
              )
            ]
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class HomepageCalendar extends StatefulWidget {
  final String title;

  HomepageCalendar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _HomepageCalendarState createState() => _HomepageCalendarState();
}

class _HomepageCalendarState extends State<HomepageCalendar>
    with TickerProviderStateMixin {

  AnimationController _animationController;
  CalendarController _calendarController;
  final EventController controller = Get.find<EventController>();


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      if (events.isEmpty)
        controller.selectedEvents = <UltimateEvent>[];
      else
        controller.selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');

    var keys = controller.mapEvents.keys;
    print(keys.length);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          if (controller.selectedEvents.isNotEmpty)
            SelectedEvents(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create event',
        onPressed: () => Get.toNamed('/events/create'),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: controller.mapEvents,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    // print(_mapEvents.length);
    // var test = _mapEvents.length == 1 ? _mapEvents.keys.elementAt(_mapEvents.length) : _mapEvents.keys.elementAt(_mapEvents.length - 1);
    // print('_buildButtons: ' + test.toString());
    // final dateTime = _mapEvents.keys.elementAt(_mapEvents.length - 1);
    final dateTime = DateTime.now();

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }
}

class SelectedEvents extends GetView<EventController> {

  SelectedEvents({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: _buildEventList());
  }

  Widget _buildEventList() {
    return ListView(
      children: controller.selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text('Ultimate'),
                  subtitle: Text(event.location),
                  onTap: () => {
                    controller.selectedEvent = event,
                    Get.toNamed('/events/details/${event.id}'),
                  },
                ),
              ))
          .toList(),
    );
  }
}

