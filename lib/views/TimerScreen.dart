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

  Future<void> _showTimePickerDialog() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _duration.inHours,
        minute: _duration.inMinutes.remainder(60),
      ),
    );
    if (picked != null) {
      setState(() {
        _duration = Duration(hours: picked.hour, minutes: picked.minute);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_duration.inHours);
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: Text('My Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$hours:$minutes:$seconds",
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause_circle_outline : Icons.play_arrow),
                  onPressed: _toggleTimer,
                  iconSize: 36, // 可以自定义图标大小
                ),
                // SizedBox(height: 20,),
                IconButton(
                  icon: Icon(Icons.settings_outlined),
                  onPressed: _showTimePickerDialog,
                  iconSize: 36, // 可以自定义图标大小
                ),
                if (!_isRunning && _duration.inSeconds == 0)
                  IconButton(
                    icon: Icon(Icons.restore_outlined),
                    onPressed: () {
                      setState(() {
                        _duration = widget.duration;
                      });
                    },
                    iconSize: 36, // 可以自定义图标大小
                    color: Colors.red, // Reset 按钮的颜色是红色
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
