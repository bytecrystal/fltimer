import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  TextEditingController controller = TextEditingController(text: "长路不必问归程");
  bool isEditing = false;
  FocusNode focusNode = FocusNode();
  Offset _tapPosition = Offset.zero; // 初始化为零偏移
  bool _showAppBar = true; // 默认显示AppBar
  double _textSize = 80.0; // 初始文本大小
  final double _minTextSize = 20.0; // 最小文本大小
  final double _maxTextSize = 200.0; // 最大文本大小
  bool _displayCurrentTime = false;


  void _toggleDisplayTime() {
    setState(() {
      _displayCurrentTime = !_displayCurrentTime;
      _saveDisplayCurrentTime(_displayCurrentTime);

      if (_displayCurrentTime) {
        // 如果显示系统时间，设置一个新的定时器，每秒更新时间
        _timer?.cancel(); // 取消之前的定时器，因为我们现在只是更新系统时间
        _isRunning = false;
        _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
      } else {
        _timer?.cancel();
      }
    });
  }

  void _increaseTextSize() {
    setState(() {
      if (_textSize < _maxTextSize) {
        _textSize += 2; // 增加大小，每次增加2pt
        _saveTextSize(_textSize);
      }
    });
  }

  void _decreaseTextSize() {
    setState(() {
      if (_textSize > _minTextSize) {
        _textSize -= 2; // 减小大小，每次减少2pt
        _saveTextSize(_textSize);
      }
    });
  }

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

  // 从 Shared Preferences 读取文本
  Future<void> _loadTitleText() async {
    final prefs = await SharedPreferences.getInstance();
    String? titleText = prefs.getString("titleText");
    if (titleText != null) {
      setState(() {
        controller.text = titleText;
      });
    }
  }

  Future<void> _loadTextSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getDouble('textSize') != null) {
        _textSize = prefs.getDouble('textSize')!;
      }
    });
  }

  Future<void> _loadShowAppBar() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('showAppBar') != null) {
        _showAppBar = prefs.getBool('showAppBar')!;
      }
    });
  }

  Future<void> _loadDisplayCurrentTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getBool('displayCurrentTime') != null) {
        _displayCurrentTime = prefs.getBool('displayCurrentTime')!;
        if (_displayCurrentTime) {
          // 如果显示系统时间，设置一个新的定时器，每秒更新时间
          _timer?.cancel(); // 取消之前的定时器，因为我们现在只是更新系统时间
          _isRunning = false;
          _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
        } else {
          _timer?.cancel();
        }
      }
    });
  }

  // 将颜色保存到 Shared Preferences
  Future<void> _saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('timeColor', color.value);
  }

  // 将标题保存到 Shared Preferences
  Future<void> _saveTitleText(String text) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('titleText', text);
  }

  Future<void> _saveTextSize(double textSize) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSize', textSize);
  }

  Future<void> _saveShowAppBar(bool showAppBar) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showAppBar', showAppBar);
  }

  Future<void> _saveDisplayCurrentTime(bool displayCurrentTime) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('displayCurrentTime', displayCurrentTime);
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
      setState(() {
        _isRunning = false;
      });
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
    _loadTitleText(); // 加载标题文本
    _loadTextSize(); // 加载时间文本大小
    _loadShowAppBar(); // 加载是否展示AppBar
    _loadDisplayCurrentTime(); // 加载是否展示当前时间
    _changeWindowSize(_showAppBar);
    // 添加焦点变化的监听器
    focusNode.addListener(_handleFocusChange);
  }

  // 焦点变化的处理函数
  void _handleFocusChange() {
    if (focusNode.hasFocus == false) { // 当TextField失去焦点时
      setState(() {
        isEditing = false;
        _saveTitleText(controller.text);
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    controller.dispose();
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

  Future<void> _toggleAppBar() async {
    setState(() {
      _showAppBar = !_showAppBar; // 切换状态
      _saveShowAppBar(_showAppBar);
      _changeWindowSize(_showAppBar);
    });
  }

  Future<void> _changeWindowSize(bool showAppBar) async {
    // 获取当前窗口界限
    Rect bounds = await windowManager.getBounds();
    if (showAppBar) {
      // 显示AppBar时，增加窗口高度
      windowManager.setSize(Size(bounds.width, bounds.height + kToolbarHeight));
    } else {
      // 隐藏AppBar时，减少窗口高度
      windowManager.setSize(Size(bounds.width, bounds.height - kToolbarHeight));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 获取当前系统时间，移至此处以确保它在_build方法中动态更新
    final now = DateTime.now();
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_displayCurrentTime ? now.hour : _duration.inHours);
    final minutes = twoDigits(_displayCurrentTime ? now.minute : _duration.inMinutes.remainder(60));
    final seconds = twoDigits(_displayCurrentTime ? now.second : _duration.inSeconds.remainder(60));

    double iconSize = 30;

    return Listener(
      onPointerDown: (PointerDownEvent event) => windowManager.startDragging(), // 当鼠标按下时开始拖拽
      child: Scaffold(
        // 创建一个可拖动的自定义标题栏
        appBar: _showAppBar ? PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              // 当用户在这个区域按下鼠标时，调用 WindowManager.startDragging
              onPanStart: (_) => windowManager.startDragging(),
              onDoubleTap: () {
                setState(() {
                  isEditing = true;
                });
                focusNode.requestFocus();
                // 调用requestFocus来强制文本字段获取焦点
                // FocusScope.of(context).requestFocus(focusNode);
              },
              onSecondaryTapDown: (TapDownDetails details) {
                _tapPosition = details.globalPosition;
              },
              onSecondaryTap: () {
                // 在此处显示弹出菜单
                final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                showMenu<Color>(
                  context: context,
                  position: RelativeRect.fromRect(
                    _tapPosition & Size(48, 48), // 小方块大小作为点击区域
                    Offset.zero & overlay.size, // 不设置偏移
                  ),
                  items: [
                    PopupMenuItem<Color>(
                      value: Colors.red,
                      onTap: () {
                        // SystemNavigator.pop(); // 调用此方法关闭应用程序
                        windowManager.close();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.close, color: Colors.black),
                          Text('关闭')
                        ],
                      ),
                    ),
                  ],
                );
              },
              child: Container(
                // 装饰你的自定义标题栏
                  color: _timeColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  alignment: Alignment.center,
                  child: isEditing ? TextField(
                    controller: controller,
                    focusNode: focusNode,
                    autofocus: true,
                    maxLength: 36,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                    ),
                    onSubmitted: (value) {
                      setState(() {
                        isEditing = false;
                        _saveTitleText(value);
                      });
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      counterText: "", // 隐藏TextField右下角的计数器
                    ),
                  ) : Text(
                    controller.text.isEmpty ? '' : controller.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
              ),
            ),
          ),
        ) : null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "$hours:$minutes:$seconds",
                style: TextStyle(
                    fontSize: _textSize,
                    fontWeight: FontWeight.bold,
                    color: _timeColor.withOpacity(0.8)
                ),
              ),
              // SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_displayCurrentTime && _duration.inSeconds > 0)
                    IconButton(
                      icon: Icon(_isRunning ? Icons.pause_circle_outline : Icons.play_circle_outline),
                      onPressed: _toggleTimer,
                      iconSize: iconSize, // 可以自定义图标大小
                      tooltip: '开始/暂停', // 提供一个工具提示
                    ),
                  // 定义按钮来选择颜色
                  IconButton(
                    icon: Icon(Icons.color_lens_outlined),
                    onPressed: _pickColor,
                    iconSize: iconSize,
                    tooltip: '选择颜色', // 提供一个工具提示
                  ),
                  // SizedBox(height: 20,),
                  if (!_displayCurrentTime)
                    IconButton(
                      icon: Icon(Icons.settings_outlined),
                      onPressed: _showTimePickerDialog,
                      iconSize: iconSize, // 可以自定义图标大小
                      tooltip: '选择时间', // 提供一个工具提示
                    ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    iconSize: iconSize,
                    onPressed: _increaseTextSize,
                    tooltip: '增加时间文字大小',
                  ),
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    iconSize: iconSize,
                    onPressed: _decreaseTextSize,
                    tooltip: '减少时间文字大小',
                  ),
                  IconButton(
                    icon: Icon(
                      _displayCurrentTime ? Icons.access_time_outlined : Icons.timer_outlined, // 使用条件图标来指示时间类型
                    ),
                    onPressed: _toggleDisplayTime, // 切换显示时间类型
                    iconSize: iconSize, // 可以自定义图标大小
                    tooltip: '定时器/时钟', // 提供一个工具提示
                  ),
                  IconButton(
                    icon: Icon(
                      _showAppBar ? Icons.visibility_off_outlined : Icons.visibility_outlined, // 用来表示AppBar的显示状态
                    ),
                    iconSize: iconSize,
                    tooltip: '显示/隐藏标题栏',
                    onPressed: _toggleAppBar
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
                      tooltip: '重置', // 提供一个工具提示
                    ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
