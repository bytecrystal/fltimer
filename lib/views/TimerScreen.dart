import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

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
  Color _timeColor = Colors.black; // 初始化文字颜色为黑色，默认状态

  // 从 Shared Preferences 读取颜色
  Future<void> _loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt("timeColor");
    if (colorValue != null) {
      setState(() {
        _timeColor = Color(colorValue);
      });
    }
  }

  // 将颜色保存到 Shared Preferences
  Future<void> _saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('timeColor', color.value);
  }

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

  Future<void> _colorPickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('选择颜色'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _timeColor,
              onColorChanged: (Color color) {
                setState(() => _timeColor = color);
              },
              colorPickerWidth: 80,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  // 添加一个功能来选择颜色
  void _pickColor() async {
    await _colorPickerDialog();
    _saveColor(_timeColor);
  }

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
    _loadColor(); // 加载颜色
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
      confirmText: "确定",
      cancelText: "取消",
      helpText: '选择时间',
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
      // 创建一个可拖动的自定义标题栏
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            // 当用户在这个区域按下鼠标时，调用 WindowManager.startDragging
            onPanStart: (_) => windowManager.startDragging(),
            child: Container(
              // 装饰你的自定义标题栏
              color: Colors.blue,
              child: Center(
                child: Text(
                  '长路不必问归程',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
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
                color: _timeColor
              ),
            ),
            // SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(_isRunning ? Icons.pause_circle_outline : Icons.play_arrow),
                  onPressed: _toggleTimer,
                  iconSize: 36, // 可以自定义图标大小
                ),
                // 定义按钮来选择颜色
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: _pickColor,
                  iconSize: 36,
                  tooltip: '选择颜色', // 提供一个工具提示
                ),
                // SizedBox(height: 20,),
                IconButton(
                  icon: Icon(Icons.timer_outlined),
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
