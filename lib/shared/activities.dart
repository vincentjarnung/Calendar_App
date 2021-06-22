import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Activities extends StatefulWidget {
  const Activities(
      {Key? key,
      required this.title,
      required this.info,
      required this.startDate,
      required this.endDate,
      required this.onClick,
      required this.onDeleteClick})
      : super(key: key);

  final String title;
  final String info;
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onClick;
  final VoidCallback onDeleteClick;

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities>
    with SingleTickerProviderStateMixin {
  AnimationController? rotationController;
  double _start = 0;
  VoidCallback? onTap;
  bool isAnimating = false;
  @override
  void initState() {
    super.initState();

    rotationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    onTap = widget.onClick;
  }

  @override
  void dispose() {
    rotationController!.dispose();
    super.dispose();
  }

  _stop() {
    print('stopping');
    rotationController!.animateTo(0);
    _start = 0;
    setState(() {
      onTap = widget.onClick;
      isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        _start = -0.005;
        rotationController!.repeat(reverse: true);
        setState(() {
          onTap = _stop;
          isAnimating = true;
        });
      },
      child: Stack(
        children: [
          isAnimating
              ? Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: widget.onDeleteClick,
                    icon: Icon(
                      Icons.delete,
                      size: 50,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: RotationTransition(
              turns:
                  Tween(begin: _start, end: 0.005).animate(rotationController!),
              child: Container(
                width: maxWidth / 2.6,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        textScaleFactor: 1.4,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.info,
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
                        DateFormat('HH:mm').format(widget.startDate),
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
                        DateFormat('HH:mm').format(widget.endDate),
                        textScaleFactor: 1.2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
