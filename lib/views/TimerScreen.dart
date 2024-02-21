import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  final Duration duration;

  TimerScreen({required Key key, required this.duration}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  late Duration _duration;
  bool _isRunning = false;

  void _toggleTimer() {
    if (_timer != null && _timer!.isActive) {
      // 使用 '!' 运算符来断言 _timer 不为 null。
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    } else {
      setState(() {
        _isRunning = true;
        _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
      });
    }
  }

  void _updateTime() {
    if (_duration.inSeconds == 0) {
      _timer?.cancel();
    } else {
      setState(() {
        _duration = _duration - Duration(seconds: 1);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: Text('人生如棋，落子无悔！'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$hours:$minutes:$seconds",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleTimer,
              child: Text(_isRunning ? 'Pause' : 'Start'),
            ),
            if (!_isRunning && _duration.inSeconds == 0)
              ElevatedButton(
                onPressed: () {
                  // Reset the timer
                  setState(() {
                    _duration = widget.duration;
                  });
                },
                child: Text('Reset'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
