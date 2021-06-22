import 'dart:async';

import 'package:calendar_app/main.dart';
import 'package:flutter/material.dart';

class MonthItem extends StatefulWidget {
  const MonthItem({
    Key? key,
    this.isCurrDay = false,
    required this.txt,
    this.isCurrMonth = false,
    required this.date,
    this.numActivities = 0,
    required this.onClick,
    required this.stream,
  }) : super(key: key);
  final int txt;
  final bool isCurrMonth;
  final bool isCurrDay;
  final DateTime date;
  final int numActivities;
  final VoidCallback onClick;
  final Stream stream;

  @override
  _MonthItemState createState() => _MonthItemState();
}

class _MonthItemState extends State<MonthItem> {
  DateTime? selDate;
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();

    streamSubscription = widget.stream.listen((date) {
      _changeDate(date);
    });
  }

  void _changeDate(newDate) {
    setState(() {
      selDate = newDate;
    });
  }

  @override
  void dispose() {
    streamSubscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClick,
      child: Card(
        elevation: 0.2,
        margin: EdgeInsets.all(1),
        color: selDate == widget.date
            ? Colors.grey[350]
            : widget.isCurrDay
                ? Colors.grey[200]
                : Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.txt.toString(),
                  style: TextStyle(
                      color: widget.isCurrMonth
                          ? Colors.grey[700]
                          : Colors.grey[400]),
                ),
              ),
              widget.numActivities != 0
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.numActivities}',
                        ),
                      ),
                    )
                  : Container(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
