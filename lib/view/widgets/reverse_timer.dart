import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ReverseTimer extends StatefulWidget {
  final TimeOfDay targetTime;

  const ReverseTimer({super.key, required this.targetTime});

  @override
  ReverseTimerState createState() => ReverseTimerState();
}

class ReverseTimerState extends State<ReverseTimer> {
  late Timer _timer;
  late DateTime _targetDateTime;
  Duration _duration = const Duration();

  @override
  void initState() {
    super.initState();

    final currentTime = DateTime.now();
    _targetDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      widget.targetTime.hour,
      widget.targetTime.minute,
    );

    // Check if the target time has already passed today
    if (_targetDateTime.isBefore(currentTime)) {
      _targetDateTime = _targetDateTime.add(const Duration(days: 1)); // Add one day to target time
    }

    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now();
      if (_targetDateTime.isAfter(currentTime)) {
        setState(() {
          _duration = _targetDateTime.difference(currentTime);
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Format the time remaining
    String hours = _duration.inHours.toString().padLeft(2, '0');
    String minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');

    return Text(
      ArabicNumbers().convert('$hours:$minutes:$seconds'),
      style: const TextStyle(fontSize: 24,color: Colors.white),
    );
  }
}