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
  bool _displayCurrentTime = false;
  bool _showIcons = true; // 控制下方所有IconButton显示的状态，默认为true
  double iconSize = 30;
  Offset _tapPosition = Offset.zero; // 初始化为零偏移
  final TextEditingController _controller = TextEditingController(text: "长路不必问归程");
  final GlobalKey _timeWidgetKey = GlobalKey();
  bool _showAppBar = true; // 默认显示AppBar
  final FocusNode _focusNode = FocusNode();
  StreamController<Duration>? _streamController = StreamController<Duration>.broadcast();
  Duration? _remainingDuration;
  DateTime? _pauseTime;
  double _timeWidth = 54.0;
  double _timeHeight=  84.0;
  double _windowWidth = 600;
  double _windowHeight = 280;

  final PreferencesService _prefs = PreferencesService();

  TimerInfo(this._duration);

  Timer? get timer => _timer;

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

  double get timeWidth => _timeWidth;

  double get timeHeight => _timeHeight;

  GlobalKey get timeWidgetKey => _timeWidgetKey;

  double get windowWidth => _windowWidth;

  double get windowHeight => _windowHeight;

  StreamController<Duration>? get streamController => _streamController;

  Stream<Duration> get durationStream => _streamController?.stream.asBroadcastStream() ?? const Stream.empty();

  void setStreamController(StreamController<Duration> streamController) {
    _streamController = streamController;
  }

  void toggleTimer(VoidCallback? onDone) {
    if (!_isRunning) {
      start(onDone);
    } else {
      _pauseTime = DateTime.now(); // 记录暂停时间
      stop();
    }
    notifyListeners();
  }

  void start(VoidCallback? onDone) {
    // 如果是第一次开始或者从暂停恢复，设置剩余时间
    if (_remainingDuration == null || _remainingDuration!.inSeconds == 0) {
      _remainingDuration = _duration;
    } else if (_pauseTime != null) {
      final pauseDuration = DateTime.now().difference(_pauseTime!);
      _remainingDuration = _remainingDuration! - pauseDuration;
    }

    final endTime = DateTime.now().add(_remainingDuration!);
    var done = false;

    _timer?.cancel(); // 取消之前的Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final now = DateTime.now();
      if (now.isBefore(endTime)) {
        _remainingDuration = endTime.difference(now);
        _streamController?.add(_remainingDuration!);
      } else {
        if (!done && onDone != null) {
          onDone();
        }
        done = true;
        _streamController?.add(Duration.zero);
        stop(); // 倒计时完成，停止Timer
        _remainingDuration = Duration.zero; // 重置剩余时间
      }
    });

    _pauseTime = null; // 清除暂停时间
    _isRunning = true;
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
  }

  void increaseSize() {
    _timeWidth += 3;
    _timeHeight += 3;


    _prefs.saveTimeWidthAndHeight(_timeWidth, _timeHeight);
    notifyListeners();
  }


  void decreaseSize() {
    _timeWidth -= 3;
    _timeHeight -= 3;

    _prefs.saveTimeWidthAndHeight(_timeWidth, _timeHeight);
    notifyListeners();
  }

  void toggleDisplayTime() {
      _displayCurrentTime = !_displayCurrentTime;
      _prefs.saveDisplayCurrentTime(_displayCurrentTime);
      if (!_displayCurrentTime) {
        start(null);
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


  void loadColor() async {
    _timeColor = await _prefs.loadTimeColor();
    notifyListeners();
  }

  void loadTitleText() async {
    controller.text = await _prefs.loadTitleText();
    notifyListeners();
  }

  void loadShowAppBar() async {
    _showAppBar = await _prefs.loadShowAppBar();
    notifyListeners();
  }

  void loadTimeWidthAndHeight() async {
    _timeWidth = await _prefs.loadTimeWidth();
    _timeHeight = await _prefs.loadTimeHeight();
    notifyListeners();
  }

  void saveCurrentWindowSize() async {
    Size size = await windowManager.getSize();
    // 获取当前窗口界限
    // Rect bounds = await windowManager.getBounds();
    await _prefs.saveWindowSize(size.width, size.height);
  }


  void loadDisplayCurrentTime() async {
    _displayCurrentTime = await _prefs.loadDisplayCurrentTime();
    if (!_displayCurrentTime) {
      start(null);
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

  void updateWindowSize() async {
    _windowWidth = await _prefs.loadWindowWidth();
    _windowHeight = await _prefs.loadWindowHeight();
    notifyListeners();
    windowManager.setSize(Size(_windowWidth, _windowHeight));
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
            renderBox.paintBounds.width + 5,
            _showAppBar
                ? renderBox.paintBounds.height + 5 + kToolbarHeight
                : renderBox.paintBounds.height + 5));
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
