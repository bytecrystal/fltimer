import 'dart:async';

import 'package:flipclock/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../model/user_config.dart';

class AppState extends ChangeNotifier {
  Duration timerDuration;
  Stream<Duration>? durationStream;
  bool? timerIsRunning;
  UserConfig userConfig = LocalStorageService().getUserConfig()!;

  AppState(this.timerDuration) {
    Duration? duration = LocalStorageService().getTimerDuration();
    if (duration != null) {
      timerDuration = duration;
    }
  }

  void toggleShowHeader() {
    userConfig.setShowHeader(!userConfig.showHeader);
    notifyListeners();
  }

  void toggleShowIconButton() {
    userConfig.setShowIconButton(!userConfig.showIconButton);
    notifyListeners();
  }

  void toggleDisplay() {
    if (userConfig.clock.type == 'clock') {
      userConfig.clock.type = 'timer';
    } else {
      userConfig.clock.type = 'clock';
      // stopTimer();
    }
    notifyListeners();
  }

  String formattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    String formattedTime = "$hours:$minutes:$seconds";
    return formattedTime;
  }


  Future<void> showTimePickerDialog(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      confirmText: "确定",
      cancelText: "取消",
      helpText: '选择时间',
      initialTime: TimeOfDay(
        hour: timerDuration.inHours,
        minute: timerDuration.inMinutes.remainder(60),
      ),
    );
    if (picked != null) {
        timerDuration = Duration(hours: picked.hour, minutes: picked.minute);
        LocalStorageService().setTimerDuration(timerDuration);
        notifyListeners();
    }
  }

  // 重置或启动计时器的函数
  void startOrResetTimer(Duration targetDuration, VoidCallback? onDone) {
    timerDuration = targetDuration;
    durationStream = Stream.periodic(const Duration(seconds: 1), (int count) {
      final newTimeLeft = timerDuration - const Duration(seconds: 1);

      // 更新 AppState
      timerDuration = newTimeLeft > Duration.zero ? newTimeLeft : Duration.zero;

      // 检查时间是否用完并可能调用完成处理程序
      if (newTimeLeft <= Duration.zero) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          onDone!();
        });
      }

      return newTimeLeft;
    }).asBroadcastStream();
    notifyListeners();

  }

  // 启动计时器
  void startTimer({VoidCallback? onDone}) {
    const step = Duration(seconds: 1);

    // 初始化时从全局状态（appState）获取剩余时长
    durationStream = Stream<Duration>.periodic(step, (int count) {
      timerDuration -= step;

      if (timerDuration.inSeconds > 0) {
        return timerDuration;
      } else {
        if (onDone != null) {
          onDone();
        }
        return Duration.zero;
      }
    }).takeWhile((duration) => duration.inSeconds > 0).asBroadcastStream();
    // notifyListeners();
  }

  // 重置计时器
  void resetTimer() {
    startOrResetTimer(const Duration(minutes: 30, seconds: 1), () => {}); // 重置时间为30分钟
    notifyListeners();
  }

  // 停止计时器
  void stopTimer() {
    timerDuration = Duration.zero;
    notifyListeners();
  }


  void updateHeadTitle(String title) {
    userConfig.headTitle.title = title;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateClockCardWidth(double value) {
    userConfig.clock.cardWidth = value;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateClockCardHeight(double value) {
    userConfig.clock.cardHeight = value;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateClockDigitSize(double value) {
    userConfig.clock.digitSize = value;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateBgColor({required String type, required int bgColor}) {
    if (type == 'clock') {
      userConfig.clock.bgColor = bgColor;
    } else if (type == 'headTitle') {
      userConfig.headTitle.bgColor = bgColor;
    }
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateAppBgColor({required int bgColor}) {
    userConfig.appBgColor = bgColor;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateColor({required String type, required int color}) {
    if (type == 'clock') {
      userConfig.clock.color = color;
    } else if (type == 'headTitle') {
      userConfig.headTitle.color = color;
    }
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateClockHingeColor({required int color}) {
    userConfig.clock.hingeColor = color;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateClockBorderColor({required int color}) {
    userConfig.clock.borderColor = color;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void updateClockSeparatorColor({required int color}) {
    userConfig.clock.separatorColor = color;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void toggleWindowSizeWhereDoubleClick(GlobalKey timeWidgetKey) {
    final RenderObject? renderBox =
    timeWidgetKey.currentContext?.findRenderObject();
    double width = 585;
    double height = 280;
    toggleShowIconButton();
    if (renderBox != null) {
      if (!userConfig.showIconButton) {
        width = renderBox.paintBounds.width;
        height = renderBox.paintBounds.height + 30;
        width = userConfig.showHeader ? width : width - 40.0;
        updateWindowSize(width, height);
        windowManager.setSize(Size(
            width,
           userConfig.showHeader
                ? height + kToolbarHeight
                : height));
      }
    }
    if (userConfig.showIconButton) {
      if (!userConfig.showHeader) {
        height = height - kToolbarHeight;
      }
      width = 600;
      updateWindowSize(width, height);
      windowManager.setSize(Size(width, height));
    }
    notifyListeners();
  }

  void toggleWindowSizeWhereShowHeader() {
    toggleShowHeader();
    double height = userConfig.windowHeight;
    if (!userConfig.showHeader) {
      height = height - kToolbarHeight;
    } else {
      height = height + kToolbarHeight;
    }
    double width = userConfig.windowWidth;
    updateWindowSize(width, height);
    windowManager.setSize(Size(width, height));
  }

  void updateWindowSize(double width, double height) {
    userConfig.windowWidth = width;
    userConfig.windowHeight = height;
    LocalStorageService().setUserConfig(userConfig);
    notifyListeners();
  }

  void setWindowSizeFromStorage() {
    Size size = Size(userConfig.windowWidth, userConfig.windowHeight);
    windowManager.setSize(size);
  }

  void saveCurrentWindowSize() async {
    Size size = await windowManager.getSize();
    updateWindowSize(size.width, size.height);
    notifyListeners();
  }

  void test() {
  }

}