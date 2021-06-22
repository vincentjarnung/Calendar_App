import 'package:calendar_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Activities extends StatelessWidget {
  const Activities(
      {Key? key,
      required this.title,
      required this.info,
      required this.startDate,
      required this.endDate,
      required this.onClick,
      required this.onLongClick})
      : super(key: key);

  final String title;
  final String info;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onClick;
  final VoidCallback onLongClick;

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onClick,
      onLongPress: onLongClick,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: maxWidth / 2.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      textScaleFactor: 1.4,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      info,
                      textScaleFactor: 1.2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Starts:',
                      textScaleFactor: 1.2,
                    ),
                    Text(
                      DateFormat('HH:mm').format(startDate),
                      textScaleFactor: 1.2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Ends:',
                      textScaleFactor: 1.2,
                    ),
                    Text(
                      DateFormat('HH:mm').format(endDate),
                      textScaleFactor: 1.2,
                    ),
                  ],
                ),
              ),
              Container(
                height: 150,
                width: 1,
                color: Colors.grey[300],
              )
            ],
          ),
        ),
      ),
    );
  }
}
