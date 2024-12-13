library event_calendar;

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'appointment-editor.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  EventCalendarState createState() => EventCalendarState();
}

int selectedResourceIndex = 0;
late DataSource events;
Appointment? selectedAppointment;
late DateTime startDate;
late TimeOfDay startTime;
late DateTime endDate;
late TimeOfDay endTime;
late bool isAllDay;
String subject = '';
String notes = '';
late List<CalendarResource> operatoryCollection;
List<String> nameCollection = [];

class EventCalendarState extends State<EventCalendar> {
  late List<String> apptNameCollection;
  final CalendarController _controller = CalendarController();
  DateRangePickerController datePickerController = DateRangePickerController();
  DateRangePickerView dateRangePickerView = DateRangePickerView.month;

  @override
  void initState() {
    _addOperatoryDetails();
    operatoryCollection = <CalendarResource>[];
    _addOperatory();
    events = DataSource(getAppointmentDetails(), operatoryCollection);
    selectedAppointment = null;

    selectedResourceIndex = 0;
    subject = '';
    notes = '';
    _controller.view = CalendarView.timelineDay;

    setState(() {});
    super.initState();
  }

  final now = DateTime.now();
  var selectedItem = 'Day';
  int? currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: SafeArea(
                child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: CupertinoSlidingSegmentedControl(
                      groupValue: currentTab,
                      children: const <int, Widget>{
                        0: Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 6),
                          child: Text(
                            'ListView',
                          ),
                        ),
                        1: Text(
                          'Operatory View',
                        ),
                      },
                      onValueChanged: (value) {
                        setState(() {
                          currentTab = value! as int;
                        });
                      }),
                ),
                header(),
                if (currentTab == 0) scheduleView() else operatoryView()
              ],
            ))));
  }

  Expanded scheduleView() {
    return const Expanded(
        child: Center(child: Text('Appointment Data will show...')));
  }

  Expanded operatoryView() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SfCalendar(
              viewNavigationMode: ViewNavigationMode.none,
              controller: _controller,
              //view: CalendarView.timelineDay,
              showDatePickerButton: false,
              // showTodayButton: true,
              headerHeight: 0,

              allowDragAndDrop: true,
              onLongPress: (daya) {},
              showCurrentTimeIndicator: false,
              timeRegionBuilder: (context, timeRegionDetails) {
                final String title = timeRegionDetails.region.text ?? "";

                return Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(2),
                  decoration: blockOutColor(title == "lunch" ? 200 : 200,
                      Color(0xFFFC4C4C4).withOpacity(.5)),
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              specialRegions: [
                TimeRegion(
                  text: 'Lunch',
                  startTime: DateTime(now.year, now.month, now.day, 6),
                  endTime: DateTime(now.year, now.month, now.day, 8),
                  enablePointerInteraction:
                      false, // only is a bug when it is false
                ),
                TimeRegion(
                  text: 'Lunch',
                  startTime: DateTime(now.year, now.month, now.day, 16),
                  endTime: DateTime(now.year, now.month, now.day, 17),
                  enablePointerInteraction:
                      false, // only is a bug when it is false
                ),
                TimeRegion(
                  text: 'Break',
                  startTime: DateTime(now.year, now.month, now.day, 19),
                  endTime: DateTime(now.year, now.month, now.day, 20),
                  enablePointerInteraction:
                      false, // only is a bug when it is false
                )
              ],
              appointmentBuilder: (context, calendarAppointmentDetails) {
                final Appointment appointment =
                    calendarAppointmentDetails.appointments.first;
                String time =
                    "${DateFormat('hh:mm a').format(appointment.startTime)} ${DateFormat('hh:mm a').format(appointment.endTime)}";

                return Container(
                  //color: Colors.red,
                  child: SingleChildScrollView(
                    child: Container(
                      //  padding: EdgeInsets.all(8),
                      // margin: const EdgeInsets.only(left: 10,right: 10),
                      margin: const EdgeInsets.all(0),
                      //color: appointment.color,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: appointment.color,
                        boxShadow: [
                          BoxShadow(color: appointment.color, spreadRadius: 3),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.subject,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            time,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          // Text(
                          //   appointment.subject,
                          //   style: const TextStyle(
                          //       color: Colors.black, fontWeight: FontWeight.bold),
                          //   textAlign: TextAlign.center,
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              onDragStart: (appointmentDragStartDetails) {
                // print(appointmentDragStartDetails);
              },
              onDragEnd: (appointmentDragEndDetails) {
                //  dragEnd(appointmentDragEndDetails);
              },
              onDragUpdate: (appointmentDragUpdateDetails) {
                // print(appointmentDragUpdateDetails);
              },
              allowedViews: const <CalendarView>[
                CalendarView.timelineDay,
                CalendarView.timelineWeek,
                CalendarView.timelineMonth,
                CalendarView.week,
              ],
              dataSource: events,
              timeSlotViewSettings: const TimeSlotViewSettings(
                  //numberOfDaysInView: 3,
                  //timeIntervalHeight: 120,

                  timeIntervalWidth: 110,
                  timeFormat: 'h a',
                  //dateFormat: 'd',
                  //dayFormat: 'EEE',
                  timeInterval: Duration(minutes: 60)),
              onTap: (calendarTapDetails) {
                onCalendarTapped(calendarTapDetails);
              },
              resourceViewHeaderBuilder: (context, details) {
                return Center(
                    child: Container(
                        // color: Colors.white,
                        child: Text(details.resource.displayName)));
              },
              resourceViewSettings: const ResourceViewSettings(
                  displayNameTextStyle: TextStyle(color: Colors.black),
                  showAvatar: false,
                  size: 80,
                  visibleResourceCount: 4),
            ),
          ),
        ],
      ),
    );
  }

  Row header() {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    _controller.backward!();

                    setState(() {});
                  },
                  icon: const Icon(Icons.navigate_before)),
              GestureDetector(
                onTap: () {
                  showCustomDialog();
                },
                child: Text(_controller.displayDate != null
                    ? DateFormat('EEE, MMM dd yyyy')
                        .format(_controller.displayDate!)
                    : DateFormat('EEE, MMM dd yyyy').format(DateTime.now())),
              ),
              IconButton(
                  onPressed: () {
                    _controller.forward!();
                    setState(() {});
                  },
                  icon: const Icon(Icons.navigate_next)),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              final DateTime now = DateTime.now();
              _controller.displayDate =
                  DateTime(now.year, now.month, now.day, 0, 0, 0);

              setState(() {});
            },
            icon: const Icon(Icons.today)),
        const SizedBox(
          width: 10,
        ),
        DropdownButton<String>(
          value: selectedItem,
          items: <String>['Day', 'Week', 'Month']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            );
          }).toList(),
          // Step 5.
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = newValue!;
              if (newValue == 'Month') {
                _controller.view = CalendarView.timelineMonth;
                datePickerController.view = DateRangePickerView.year;
              } else if (newValue == 'Week') {
                _controller.view = CalendarView.timelineWeek;
                datePickerController.view = DateRangePickerView.month;
              } else {
                _controller.view = CalendarView.timelineDay;
                datePickerController.view = DateRangePickerView.month;
              }
            });
          },
        )
      ],
    );
  }

  Future<dynamic> showCustomDialog() {
    datePickerController.displayDate = _controller.selectedDate;

    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.5,
            child: SfDateRangePickerTheme(
              data: const SfDateRangePickerThemeData(
                backgroundColor: Colors.white,
                headerBackgroundColor: Colors.white,
                todayCellTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                selectionColor: Color.fromRGBO(35, 188, 1, 1),
                todayTextStyle: TextStyle(
                  color: Color.fromRGBO(35, 188, 1, 1),
                ),
                todayHighlightColor: Color.fromRGBO(35, 188, 1, 1),
                headerTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              child: SfDateRangePicker(
                showNavigationArrow: true,
                allowViewNavigation: false,
                controller: datePickerController,
                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                  // selectedDate = args.value;
                  _controller.displayDate = args.value;
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void dragEnd(AppointmentDragEndDetails details) {
    if (details.targetResource != null) {
      print('dragEnd');
      // setState(() {
      var appointment = details.appointment as Appointment;
      final index = events.appointments!.indexOf(appointment);
      events.appointments![index] = Appointment(
        startTime: details.droppingTime!,
        endTime: details.droppingTime!
            .add(appointment.endTime.difference(appointment.startTime)),
        subject: appointment.subject,
        color: appointment.color,
        notes: appointment.notes ?? "",
        resourceIds: [details.targetResource!.id], // Update resource
      );
      events.notifyListeners(
          CalendarDataSourceAction.reset, events.appointments ?? []);
      // });
    }
  }

  calculateBlockSize(int length) {
    if (length == 30) {
      return Alignment(-0.952, -0.859);
    } else if (length == 15) {
      //return Alignment(-0.956, -0.66);
      return Alignment(-0.90, -0.76);
    } else if (length <= 15) {
      //return Alignment(-0.956, -0.66);
      return Alignment(-0.956, -0.659);
    } else if (length <= 20) {
      //return Alignment(-0.90, 0.20);
      return Alignment(-0.90, -0.75);
    } else if (length <= 30) {
      //return Alignment(-0.952, -0.859);
      return Alignment(-0.90, -0.82);
    } else if (length <= 60) {
      return Alignment(-0.90, -0.80);
    } else if (length <= 120) {
      return Alignment(-0.90, -0.90);
    } else if (length <= 180) {
      return Alignment(-0.90, -0.93);
    } else {
      return Alignment(-0.89, -0.980);
      //return Alignment(-0.98, -0.98);
    }
  }

  BoxDecoration blockOutColor(int differenceMinutesDuration, Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: calculateBlockSize(differenceMinutesDuration),
        stops: [0.0, 0.5, 0.5, 1],
        colors: [
          color,
          color,
          Colors.white,
          Colors.white,
        ],
        tileMode: TileMode.repeated,
      ),
    );
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    selectedAppointment = null;
    isAllDay = false;
    //_selectedColorIndex = 0;
    //_selectedTimeZoneIndex = 0;
    selectedResourceIndex = 0;
    subject = '';
    notes = '';

    if (calendarTapDetails.appointments != null &&
        calendarTapDetails.appointments?.length == 1) {
      final Appointment meetingDetails = calendarTapDetails.appointments![0];
      startDate = meetingDetails.startTime;
      endDate = meetingDetails.endTime;
      isAllDay = meetingDetails.isAllDay;
      //_selectedColorIndex = _colorCollection.indexOf(meetingDetails.color);
      // _selectedTimeZoneIndex = meetingDetails.startTimeZone == ''
      //     ? 0
      //     : _timeZoneCollection.indexOf(meetingDetails.startTimeZone ?? "");
      subject =
          meetingDetails.subject == '(No title)' ? '' : meetingDetails.subject;
      notes = meetingDetails.notes ?? "";
      selectedResourceIndex = nameCollection
          .indexOf(calendarTapDetails.resource?.displayName ?? "");
      selectedAppointment = meetingDetails;
    } else {
      final DateTime date = calendarTapDetails!.date!;
      startDate = date;
      endDate = date.add(const Duration(hours: 1));
      selectedResourceIndex = nameCollection
          .indexOf(calendarTapDetails.resource?.displayName ?? "");
    }
    startTime = TimeOfDay(hour: startDate.hour, minute: startDate.minute);
    endTime = TimeOfDay(hour: endDate.hour, minute: endDate.minute);
    Navigator.push<Widget>(
      context,
      MaterialPageRoute(builder: (BuildContext context) => AppointmentEditor()),
    );
  }

  List<Appointment> getAppointmentDetails() {
    final List<Appointment> meetingCollection = <Appointment>[];

    // nameCollection = <String>[];
    // nameCollection.add('Dr Stevia Johsnon');
    // nameCollection.add("Dr Perry O'Dontist");
    // nameCollection.add('Dr John Smith');
    // nameCollection.add('Dr Grant Gums');
    // nameCollection.add('Dr. Lance Incisor');
    // nameCollection.add('Dr. Flora Fillings');
    // nameCollection.add('Dr. Cody Crown');

    apptNameCollection = <String>[];
    apptNameCollection.add('General Meeting');
    apptNameCollection.add('Plan Execution');
    apptNameCollection.add('Project Plan');
    apptNameCollection.add('Consulting');
    apptNameCollection.add('Support');
    apptNameCollection.add('Development Meeting');
    apptNameCollection.add('Scrum');

    final Random random = Random();
    for (int i = 0; i < operatoryCollection.length; i++) {
      final List<String> _employeeIds = <String>[
        operatoryCollection[i].id.toString()
      ];
      if (i == operatoryCollection.length - 1) {
        int index = random.nextInt(5);
        index = index == i ? index + 1 : index;
        _employeeIds.add(operatoryCollection[index].id.toString());
      }
      for (int j = 0; j < 4; j++) {
        final DateTime date = DateTime.now();
        int startHour = 9 + random.nextInt(6);
        startHour =
            startHour >= 13 && startHour <= 14 ? startHour + 1 : startHour;
        final DateTime _shiftStartTime =
            DateTime(date.year, date.month, date.day, startHour, 0, 0);
        List<Color> colorCollection = <Color>[];
        colorCollection.add(const Color(0xFF83C9A9));
        colorCollection.add(const Color(0xFFF1BD6C));
        colorCollection.add(const Color(0xFFF8DF72));
        colorCollection.add(const Color(0xFF86ABF9));

        meetingCollection.add(Appointment(
            startTime: _shiftStartTime,
            endTime: _shiftStartTime.add(const Duration(hours: 1)),
            subject: apptNameCollection[random.nextInt(7)],
            color: colorCollection[random.nextInt(4)],
            notes: '',
            id: operatoryCollection[i].id.toString(),
            resourceIds: <String>[operatoryCollection[i].id.toString()]));
      }
    }
    return meetingCollection;
  }

  void _addOperatoryDetails() {
    nameCollection = <String>[];
    nameCollection.add('Dr Stevia Johsnon');
    nameCollection.add("Dr Perry O'Dontist");
    nameCollection.add('Dr John Smith');
    nameCollection.add('Dr Grant Gums');
    nameCollection.add('Dr. Lance Incisor');
    nameCollection.add('Dr. Flora Fillings');
    nameCollection.add('Dr. Cody Crown');
  }

  void _addOperatory() {
    for (int i = 0; i < nameCollection.length; i++) {
      operatoryCollection.add(CalendarResource(
        displayName: nameCollection[i],
        id: '000' + i.toString(),
        color: Colors.transparent,
      ));
    }
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }
}

// class Meeting {
//   Meeting(
//       {required this.from,
//       required this.to,
//       this.background = Colors.green,
//       this.isAllDay = false,
//       this.eventName = '',
//       this.startTimeZone = '',
//       this.endTimeZone = '',
//       this.description = '',
//       required this.ids});
//
//   final String eventName;
//   final DateTime from;
//   final DateTime to;
//   final Color background;
//   final bool isAllDay;
//   final String startTimeZone;
//   final String endTimeZone;
//   final String description;
//   final List<String> ids;
// }
