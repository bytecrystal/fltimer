import 'package:flipclock/views/top_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../functions.dart';
import '../state/time_info.dart';
import 'bottom_icon_buttons.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});


  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  double iconSize = 30;

  // 从 Shared Preferences 读取配置
  void _loadPreferences() async {
    TimerInfo timerInfo = Provider.of<TimerInfo>(context, listen: false);
    timerInfo.loadColor();
    timerInfo.loadTitleText();
    timerInfo.loadTextSize();
    timerInfo.loadShowAppBar();
    timerInfo.loadDisplayCurrentTime();
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    TimerInfo timerInfo = Provider.of<TimerInfo>(context, listen: false);
    timerInfo.updateWindowSizeWithAppBar();
    // 添加焦点变化的监听器
    timerInfo.focusNode.addListener(timerInfo.handleFocusChange);
  }

  @override
  void dispose() {
    // if (_timer != null) {
    //   _timer!.cancel();
    // }
    TimerInfo timerInfo = Provider.of<TimerInfo>(context, listen: false);
    timerInfo.focusNode.removeListener(timerInfo.handleFocusChange);
    timerInfo.focusNode.dispose();
    timerInfo.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerInfo>(builder: (context, timerInfo, child) {
      String formatTimeStr =
         formatTime(timerInfo.duration, timerInfo.displayCurrentTime);

      return Listener(
          onPointerDown: (PointerDownEvent event) =>
              windowManager.startDragging(), // 当鼠标按下时开始拖拽
          child: Scaffold(
            // 创建一个可拖动的自定义标题栏
            appBar: timerInfo.showAppBar
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: TopCustomAppBar(timerInfo: timerInfo,)
                  )
                : null,
            body: GestureDetector(
              onDoubleTap: timerInfo.toggleShowIcons,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      key: timerInfo.timeWidgetKey,
                      formatTimeStr,
                      style: TextStyle(
                          fontSize: timerInfo.textSize,
                          fontWeight: FontWeight.bold,
                          color: timerInfo.timeColor.withOpacity(0.8)),
                    ),
                    // SizedBox(height: 5),
                    if (timerInfo.showIcons)
                      BottomIconButtons(iconSize: iconSize, timerInfo: timerInfo)
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
