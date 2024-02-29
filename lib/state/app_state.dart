import 'dart:async';

import 'package:flipclock/service/local_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../model/user_config.dart';

class AppState extends ChangeNotifier {
  Duration timerDuration;
  Timer? timer;
  bool? timerIsRunning;
  UserConfig userConfig = LocalStorageService().getUserConfig()!;

  AppState(this.timerDuration);

  void toggleShowHeader() {
    userConfig.setShowHeader(!userConfig.showHeader);
    notifyListeners();
  }

  void toggleShowIconButton() {
    userConfig.setShowIconButton(!userConfig.showIconButton);
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
    } else if (type == 'timer') {
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