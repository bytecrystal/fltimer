import 'package:flipclock/service/local_storage_service.dart';
import 'package:flipclock/state/app_state.dart';
import 'package:flipclock/views/icon_bar.dart';
import 'package:flipclock/views/my_app_bar.dart';
import 'package:flipclock/views/widget/clock/flip_clock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});


  @override
  TimerScreenState createState() => TimerScreenState();
}

class TimerScreenState extends State<TimerScreen> {
  double iconSize = 30;
  final GlobalKey _timeContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      Color clockBgColor = Color(appState.userConfig.clock.bgColor);
      Color clockDigitColor = Color(appState.userConfig.clock.color);
      return Listener(
          onPointerDown: (PointerDownEvent event) =>
              windowManager.startDragging(), // 当鼠标按下时开始拖拽
          child: Scaffold(
            // 创建一个可拖动的自定义标题栏
            appBar: appState.userConfig.showHeader
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: MyAppBar()
                  )
                : null,
            body: GestureDetector(
              onDoubleTap: () => {
                appState.toggleWindowSizeWhereDoubleClick(_timeContainerKey)
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                Container(
                alignment: Alignment.center,
                    key: _timeContainerKey,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      // borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    padding: const EdgeInsets.all(5.0),
                    child: FlipClock(
                      digitSize: appState.userConfig.clock.digitSize,
                      width: appState.userConfig.clock.cardWidth,
                      height: appState.userConfig.clock.cardHeight,
                      digitColor: clockDigitColor,
                      separatorWidth: 40.0,
                      backgroundColor: clockBgColor,
                      separatorColor: clockBgColor,
                      borderColor: clockBgColor,
                      hingeColor: Colors.grey[300],
                      showSeconds: true,
                      showBorder: true,
                      hingeWidth: 0.8,
                      // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                    if (appState.userConfig.showIconButton)
                      IconBar(iconSize: iconSize)
                  ],
                ),
              ),
            ),
          ));
    });
  }
}
