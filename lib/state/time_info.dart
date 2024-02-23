import 'dart:async';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../service/preferences_service.dart';
import '../views/color_picker_dialog.dart';


class TimerInfo extends ChangeNotifier {
  Timer? _timer;
  Duration _duration;
  bool _isRunning = false;
  Color _timeColor = Colors.black;
  bool _isEditing = false;
  double _textSize = 80.0; // 初始文本大小
  final double _minTextSize = 20.0; // 最小文本大小
  final double _maxTextSize = 120.0; // 最大文本大小
  bool _displayCurrentTime = false;
  bool _showIcons = true; // 控制下方所有IconButton显示的状态，默认为true
  double iconSize = 30;
  Offset _tapPosition = Offset.zero; // 初始化为零偏移
  final TextEditingController _controller = TextEditingController(text: "长路不必问归程");
  final GlobalKey _timeWidgetKey = GlobalKey();
  bool _showAppBar = true; // 默认显示AppBar
  final FocusNode _focusNode = FocusNode();


  final PreferencesService _prefs = PreferencesService();

  TimerInfo(this._duration);

  Duration get duration => _duration;

  Color get timeColor => _timeColor;

  bool get isRunning => _isRunning;

  bool get displayCurrentTime => _displayCurrentTime;

  TextEditingController get controller => _controller;

  FocusNode get focusNode => _focusNode;

  Offset get tapPosition => _tapPosition;

  bool get showAppBar => _showAppBar;

  bool get showIcons => _showIcons;

  bool get isEditing => _isEditing;

  double get textSize => _textSize;

  GlobalKey get timeWidgetKey => _timeWidgetKey;


  // A method to toggle the timer
  void toggleTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
    }
    _isRunning = !_isRunning;
    notifyListeners();
  }

  void toggleDisplayTime() {
      _displayCurrentTime = !_displayCurrentTime;
      _prefs.saveDisplayCurrentTime(_displayCurrentTime);

      if (_displayCurrentTime) {
        // 如果显示系统时间，设置一个新的定时器，每秒更新时间
        _timer?.cancel(); // 取消之前的定时器，因为我们现在只是更新系统时间
        _isRunning = false;
        _timer =
            Timer.periodic(const Duration(seconds: 1), (Timer t) => notifyListeners());
      } else {
        _timer?.cancel();
      }
      notifyListeners();
  }



  void setEditing(bool value) {
    _isEditing = value;
    notifyListeners();
  }


  void setTapPosition(Offset value) {
    _tapPosition = value;
    notifyListeners();
  }

  void setDuration(Duration value) {
    _duration = value;
    notifyListeners();
  }

  // A method update the time
  void _updateTime() {
    if (_duration.inSeconds == 0) {
      _timer?.cancel();
    } else {
      _duration = _duration - const Duration(seconds: 1);
    }
    notifyListeners();
  }

  void loadColor() async {
    _timeColor = await _prefs.loadTimeColor();
    notifyListeners();
  }

  void loadTitleText() async {
    controller.text = await _prefs.loadTitleText();
    notifyListeners();
  }

  void loadTextSize() async {
    _textSize = await _prefs.loadTextSize();
    notifyListeners();
  }

  void loadShowAppBar() async {
    _showAppBar = await _prefs.loadShowAppBar();
    notifyListeners();
  }


  void loadDisplayCurrentTime() async {
    _displayCurrentTime = await _prefs.loadDisplayCurrentTime();
    if (_displayCurrentTime) {
      // 如果显示系统时间，设置一个新的定时器，每秒更新时间
      _timer?.cancel(); // 取消之前的定时器，因为我们现在只是更新系统时间
      _isRunning = false;
      _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => notifyListeners());
    } else {
      _timer?.cancel();
    }
    notifyListeners();
  }

  // 焦点变化的处理函数
  void _handleFocusChange() {
    if (focusNode.hasFocus == false) { // 当TextField失去焦点时
      _isEditing = false;
      _prefs.saveTitleText(controller.text);
    }
    notifyListeners();
  }


  void increaseTextSize() {
    if (_textSize < _maxTextSize) {
      _textSize += 2; // 增加大小，每次增加2pt
      _prefs.saveTextSize(_textSize);
    }
    notifyListeners();
  }

  void decreaseTextSize() {
    if (_textSize > _minTextSize) {
      _textSize -= 2; // 减小大小，每次减少2pt
      _prefs.saveTextSize(_textSize);
    }
    notifyListeners();
  }

  // Remember to dispose of the timer
  @override
  void dispose() {
    _timer?.cancel();
    focusNode.removeListener(_handleFocusChange);
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void toggleShowIcons() async {
    _showIcons = !_showIcons;
    _updateWindowSizeWithShowIcons(_showIcons);
    notifyListeners();
  }

  void _updateWindowSizeWithShowIcons(bool showIcons) {
    final RenderObject? renderBox =
    _timeWidgetKey.currentContext?.findRenderObject();
    if (renderBox != null) {
      if (!_showIcons) {
        windowManager.setSize(Size(
            renderBox.paintBounds.width + 10,
            _showAppBar
                ? renderBox.paintBounds.height + kToolbarHeight
                : renderBox.paintBounds.height));
      }
    }
    double height = 280;
    if (_showIcons) {
      if (!_showAppBar) {
        height = height - kToolbarHeight;
      }
      windowManager.setSize(Size(600, height));
    }
  }

  void toggleAppBar() {
    _showAppBar = !_showAppBar; // 切换状态
    _prefs.saveShowAppBar(_showAppBar);
    updateWindowSizeWithAppBar();
    notifyListeners();
  }

  void updateWindowSizeWithAppBar() async {
    // 获取当前窗口界限
    Rect bounds = await windowManager.getBounds();
    if (_showAppBar) {
      // 显示AppBar时，增加窗口高度
      windowManager.setSize(Size(bounds.width, bounds.height + kToolbarHeight));
    } else {
      // 隐藏AppBar时，减少窗口高度
      windowManager.setSize(Size(bounds.width, bounds.height - kToolbarHeight));
    }
  }

  void updateTimeColor(Color newColor) {
    _timeColor = newColor;
    notifyListeners();
    // 保存新的颜色到偏好设置中
    _prefs.saveTimeColor(newColor);
  }

  void updateTitleText(String text) {
    controller.text = text;
    notifyListeners();
    _prefs.saveTitleText(text);
  }

  void pickColor(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => ColorPickerDialog(
        initialColor: _timeColor,
        colorPickerWidth: 80.0,
        onColorChanged: (Color color) {
          updateTimeColor(color);
        },
      ),
    );
  }

  // 焦点变化的处理函数
  void handleFocusChange() {
    if (focusNode.hasFocus == false) {
      // 当TextField失去焦点时
      _isEditing = false;
      _prefs.saveTitleText(controller.text);
      notifyListeners();
    }
  }

}
