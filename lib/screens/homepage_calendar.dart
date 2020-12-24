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
  String viewFormat;
  int _selectedIndex = 0;

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

    // viewFormat = _calendarController.calendarFormat.toString();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      events.isEmpty
          ? eventController.selectedEvents = <UltimateEvent>[]
          : eventController.selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');

    _calendarController.setSelectedDay(DateTime.now());
  }

  void _bottomNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    bool _useMobileLayout = shortestSide < 600;

    return _useMobileLayout
        ? _buildMobileDisplay(context)
        : _buildNotMobileDisplay(context);
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(widget.title),
      centerTitle: true,
      leading: ElevatedButton(
        onPressed: () {
          final dateTime = DateTime.now();
          _calendarController.setSelectedDay(
            DateTime(dateTime.year, dateTime.month, dateTime.day),
            runCallback: true,
          );
        },
        child: Text('Today'),
      ),
      actions: <Widget>[
        GetX(builder: (_) {
          return authController.user != null
              ? IconButton(
                  icon: Icon(Icons.logout),
                  tooltip: 'Sign out',
                  onPressed: () => authController.signOut(),
                )
              : IconButton(
                  icon: Icon(Icons.login),
                  tooltip: 'Sign in',
                  onPressed: () => SignInScreenRouter.navigate(),
                );
        }),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return authController.user == null
        ? Container()
        : FloatingActionButton(
            tooltip: 'Create event',
            onPressed: () => UltimateEventCreateScreenRouter.navigate(),
            child: Icon(Icons.add),
          );
  }

  Widget _buildMobileDisplay(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _selectedIndex == 0
          ? Column(
              children: <Widget>[
                _buildTableCalendar(),
                if (eventController.selectedEvents.isNotEmpty)
                  Expanded(child: _buildEventList()),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: Obx(
                    () => _displayContacts(),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        onTap: _bottomNavItemTapped,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildNotMobileDisplay(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                Flexible(
                  child: Text(
                    'Contacts',
                    style: TextStyle().copyWith(fontSize: 20),
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => _displayContacts(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Material(
              elevation: 5.0,
              child: Align(
                alignment: Alignment.topLeft,
                child: _buildTableCalendar(),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Align(
              child: eventController.selectedEvents.isNotEmpty
                  ? _buildEventList()
                  : Container(
                      child: Text('No events today'),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
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
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).accentColor),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle:
            TextStyle().copyWith(color: Theme.of(context).primaryColor),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: true,
      ),
      builders: CalendarBuilders(
        // dayBuilder: (context, date, _) {
        //   return Container(
        //     margin: const EdgeInsets.all(2.0),
        //     padding: const EdgeInsets.only(top: 5.0, left: 6.0),
        //     width: 80,
        //     height: 80,
        //     decoration: BoxDecoration(
        //       border: Border.all(
        //         color: Colors.black,
        //         width: 0.8,
        //       ),
        //     ),
        //     child: Text(
        //       '${date.day}',
        //       style: TextStyle().copyWith(fontSize: 16.0),
        //     ),
        //   );
        // },
        selectedDayBuilder: (context, date, _) {
          eventController.selectedDay = date;
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Theme.of(context).primaryColor,
              width: 150,
              height: 150,
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
            color: Theme.of(context).accentColor,
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
            ? Theme.of(context).accentColor
            : _calendarController.isToday(date)
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
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

  Widget _displayContacts() {
    return ListView(
        children: authController.users
            .map(
              (user) => Container(
                child: Card(
                  child: ListTile(
                    title: Text('${user.firstName} ${user.lastName}'),
                    subtitle: !user.phoneNumber.isNull
                        ? Text(user.phoneNumber)
                        : Container(),
                  ),
                ),
              ),
            )
            .toList());
  }

  Widget _buildEventList() {
    return ListView(
      children: eventController.selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 9.0),
              child: ListTile(
                title: Center(child: Text(event.location)),
                subtitle: Center(
                    child: Text(DateFormat.yMd()
                        .add_jm()
                        .format(event.time)
                        .toString())),
                onTap: () => {
                  eventController.selectedEvent = event,
                  // Get.toNamed('/events/details/${event.id}', arguments: event.id),
                  UltimateEventDetailsScreenRouter.navigate(event.id),
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
