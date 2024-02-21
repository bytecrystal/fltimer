import 'dart:async';
import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  final DateTime targetDateTime;

  CountdownScreen({required Key key, required this.targetDateTime}) : super(key: key);

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration();
  bool _isRunning = true;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
    _isRunning = true;
  }

  void _updateTime() {
    final now = DateTime.now();
    _timeLeft = widget.targetDateTime.difference(now);

    if (_timeLeft.isNegative) {
      _timer.cancel();
      _timeLeft = Duration.zero; // 避免显示负数
    }

    setState(() {});
  }

  void _toggleTimer() {
    if (_timer == null || !_timer.isActive) {
      startTimer();
    } else if (_timer.isActive) {
      _timer.cancel();
    }

    setState(() {
      _isRunning = _timer != null && _timer.isActive;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTime();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours.remainder(24);
    final minutes = _timeLeft.inMinutes.remainder(60);
    final seconds = _timeLeft.inSeconds.remainder(60);

    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer to Specific Date'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              days > 0 ?
              '$days:${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}' :
              '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20,),
            IconButton(
              onPressed: _toggleTimer,
              icon: Icon(_isRunning ? Icons.pause_circle : Icons.play_circle),
            )
          ],
        ),
      ),
    );
  }
}