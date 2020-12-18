import 'package:bend_ultimate_flutter/controllers/auth_controller.dart';
import 'package:bend_ultimate_flutter/controllers/event_controller.dart';
import 'package:bend_ultimate_flutter/models/ultimate_event.dart';
import 'package:bend_ultimate_flutter/routers/sign_in_screen_router.dart';
import 'package:bend_ultimate_flutter/routers/ultimate_event_create_screen_router.dart';
import 'package:bend_ultimate_flutter/routers/ultimate_event_details_screen_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

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
  final EventController eventController = Get.find<EventController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();

    _calendarController = CalendarController();
    // _calendarController.setCalendarFormat(CalendarFormat.month);
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
        eventController.selectedEvents = <UltimateEvent>[];
      else
        eventController.selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');

    var keys = eventController.mapEvents.keys;
    _calendarController.setSelectedDay(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;

    return useMobileLayout ? _buildMobileLayout() : _buildNonMobileLayout();
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          GetX(builder: (_) {
            if (authController.user != null) {
              return IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Sign out',
                onPressed: () => authController.signOut(),
              );
            } else {
              return IconButton(
                icon: Icon(Icons.login),
                tooltip: 'Sign in',
                onPressed: () => SignInScreenRouter.navigate(),
              );
            }
          })
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildTableCalendar(),
          _buildButtons(),
          if (eventController.selectedEvents.isNotEmpty) _buildEventList(),
        ],
      ),
      floatingActionButton: authController.user == null
          ? Container()
          : FloatingActionButton(
              tooltip: 'Create event',
              onPressed: () => UltimateEventCreateScreenRouter.navigate(),
              child: Icon(Icons.add),
            ),
    );
  }

  Widget _buildNonMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        leading: RaisedButton(
            onPressed: () {
              final dateTime = DateTime.now();
              _calendarController.setSelectedDay(
                DateTime(dateTime.year, dateTime.month, dateTime.day),
                runCallback: true,
              );
            },
            child: Text('Today')),
        actions: <Widget>[
          DropdownButton(
            // icon: Text(_calendarController?.calendarFormat.toString() ?? 'Month'),
            icon: Text('Month'),
            onChanged: (String selected) {
              selected == 'Month'
                  ? setState(() {
                      _calendarController
                          .setCalendarFormat(CalendarFormat.month);
                    })
                  : setState(() {
                      _calendarController
                          .setCalendarFormat(CalendarFormat.week);
                    });
            },
            items: <String>['Month', 'Week']
                .map<DropdownMenuItem<String>>((String choice) {
              return DropdownMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList(),
          ),
          GetX(builder: (_) {
            if (authController.user != null) {
              return IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Sign out',
                onPressed: () => authController.signOut(),
              );
            } else {
              return IconButton(
                icon: Icon(Icons.login),
                tooltip: 'Sign in',
                onPressed: () => SignInScreenRouter.navigate(),
              );
            }
          })
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Material(
              elevation: 4.0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildTableCalendar(),
                  // _buildButtons(),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                eventController.selectedEvents.isNotEmpty
                    ? _buildEventList()
                    : Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text('No events today'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: authController.user == null
          ? Container()
          : FloatingActionButton(
              tooltip: 'Create event',
              onPressed: () => UltimateEventCreateScreenRouter.navigate(),
              child: Icon(Icons.add),
            ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: eventController.mapEvents,
      initialCalendarFormat: CalendarFormat.month,
      initialSelectedDay: DateTime.now(),
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.week: 'Week',
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
          eventController.selectedDay = date;
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
              child: Text('Set today'),
              onPressed: () {
                _calendarController.setSelectedDay(
                  DateTime(dateTime.year, dateTime.month, dateTime.day),
                  runCallback: true,
                );
              },
            ),
            RaisedButton(
              child: Text('Month view'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('Week view'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return Expanded(
        child: ListView(
      children: eventController.selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.location),
                  subtitle: Text(
                      DateFormat.yMd().add_jm().format(event.time).toString()),
                  onTap: () => {
                    eventController.selectedEvent = event,
                    // Get.toNamed('/events/details/${event.id}', arguments: event.id),
                    UltimateEventDetailsScreenRouter.navigate(event.id),
                  },
                ),
              ))
          .toList(),
    ));
  }
}
