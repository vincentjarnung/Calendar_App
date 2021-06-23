import 'package:calendar_app/models/activity.dart';
import 'package:calendar_app/services/database_service.dart';
import 'package:calendar_app/shared/borderd_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SetActivity extends StatefulWidget {
  const SetActivity(
      {Key? key,
      required this.title,
      required this.info,
      required this.startTime,
      required this.endTime})
      : super(key: key);

  final String title;
  final String info;
  final DateTime startTime;
  final DateTime endTime;

  @override
  _SetActivityState createState() => _SetActivityState();
}

class _SetActivityState extends State<SetActivity>
    with SingleTickerProviderStateMixin {
  DatabaseService _databaseService = DatabaseService();

  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  final _formKey = GlobalKey<FormState>();

  String _insertTitle = '';
  String _insertInfo = '';
  DateTime? _insertStartTime;
  DateTime? _insertEndTime;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _scaleAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.bounceOut);

    _controller!.addListener(() {
      setState(() {});
    });
    _controller!.forward();
    _insertTitle = widget.title;
    _insertInfo = widget.info;
    _insertStartTime = widget.startTime;
    _insertEndTime = widget.endTime;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    var mediaQuery = MediaQuery.of(context);

    if (!_insertStartTime!.compareTo(_insertEndTime!).isNegative) {
      _insertEndTime = _insertStartTime;
    }
    return _SystemPadding(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: ScaleTransition(
              scale: _scaleAnimation!,
              child: Container(
                height: 460,
                width: maxWidth,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BorderdTextField(
                          hintText: 'Title',
                          prefixIconData: Icons.title,
                          onChanged: (val) {
                            _insertTitle = val;
                          },
                          validatior: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          isLast: false,
                          initVal: widget.title,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BorderdTextField(
                          hintText: 'Info',
                          prefixIconData: Icons.info,
                          onChanged: (val) {
                            _insertInfo = val;
                          },
                          validatior: (val) {
                            return null;
                          },
                          isLast: false,
                          initVal: widget.title,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Start Time:',
                        ),
                        Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Text(
                                    DateFormat('EEE d MMMM')
                                        .format(_insertStartTime!),
                                    textScaleFactor: 1.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    _selectStartTime(
                                        context, _insertStartTime!);
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(_insertStartTime!),
                                          textScaleFactor: 1.5,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              _selectStartTime(
                                                  context, _insertStartTime!);
                                            },
                                            icon: Icon(Icons.edit))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'End Time:',
                        ),
                        Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  child: Text(
                                    DateFormat('EEE d MMMM')
                                        .format(_insertEndTime!),
                                    textScaleFactor: 1.5,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    _selectEndTime(context, _insertEndTime!);
                                  },
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          DateFormat('HH:mm')
                                              .format(_insertEndTime!),
                                          textScaleFactor: 1.5,
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              _selectEndTime(
                                                  context, _insertEndTime!);
                                            },
                                            icon: Icon(Icons.edit))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _databaseService.insertAlarm(ActivityModel(
                                        year: _insertStartTime!.year,
                                        month: _insertStartTime!.month,
                                        day: _insertStartTime!.day,
                                        title: _insertTitle,
                                        info: _insertInfo,
                                        startTime: _insertStartTime!.toString(),
                                        endTime: _insertEndTime!.toString()));
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text('Save')),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectStartDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(selectedDate.year - 5),
        lastDate: DateTime(selectedDate.year + 5));
    if (picked != null)
      setState(() {
        _insertStartTime = DateTime(picked.year, picked.month, picked.day,
            _insertStartTime!.hour, _insertStartTime!.minute);
      });
  }

  Future<Null> _selectEndDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: _insertStartTime!,
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _insertEndTime = DateTime(picked.year, picked.month, picked.day,
            _insertEndTime!.hour, _insertEndTime!.minute);
      });
  }

  Future<Null> _selectStartTime(
      BuildContext context, DateTime selectedTime) async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime:
          TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
    );
    if (picked != null)
      setState(() {
        _insertStartTime = DateTime(
            _insertStartTime!.year,
            _insertStartTime!.month,
            _insertStartTime!.day,
            picked.hour,
            picked.minute);
      });
  }

  Future<Null> _selectEndTime(
      BuildContext context, DateTime selectedTime) async {
    final TimeOfDay? picked = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime:
          TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
    );
    if (picked != null)
      setState(() {
        _insertEndTime = DateTime(_insertEndTime!.year, _insertEndTime!.month,
            _insertEndTime!.day, picked.hour, picked.minute);
      });
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 200),
        child: child);
  }
}
