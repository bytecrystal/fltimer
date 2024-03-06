
import 'package:flipclock/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../state/app_state.dart';

class IconBar extends StatelessWidget {
  final double iconSize;

  const IconBar({
    super.key,
    required this.iconSize,
  });



  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            appState.userConfig.clock.type == 'clock'
                ? Icons.access_time_outlined
                : Icons.timer_outlined, // 使用条件图标来指示时间类型
          ),
          onPressed: appState.toggleDisplay, // 切换显示时间类型
          iconSize: iconSize, // 可以自定义图标大小
          tooltip: '定时器/时钟', // 提供一个工具提示
        ),
        if (appState.userConfig.clock.type == 'timer')
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => {
              appState.resetTimer(context)
            },
            iconSize: iconSize, // 可以自定义图标大小
            tooltip: '重置', // 提供一个工具提示
          ),
        IconButton(
            icon: Icon(
              appState.userConfig.showHeader
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined, // 用来表示AppBar的显示状态
            ),
            iconSize: iconSize,
            tooltip: '显示/隐藏标题栏',
            onPressed: appState.toggleWindowSizeWhereShowHeader),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => {
            appState.saveCurrentWindowSize(),
            // 设置窗口大小
            windowManager.setSize(const Size(580, 900), animate: true),
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ).then((value) => {
              Phoenix.rebirth(context)
            })
          },
          iconSize: iconSize, // 可以自定义图标大小
          tooltip: '设置', // 提供一个工具提示
        ),
        // if (!timerInfo.displayCurrentTime &&
        //     timerInfo.duration.inSeconds == 0)
        //   IconButton(
        //     icon: const Icon(Icons.restore_outlined),
        //     onPressed: () {
        //       timerInfo.setDuration(timerInfo.duration);
        //     },
        //     iconSize: 36,
        //     // 可以自定义图标大小
        //     color: Colors.red,
        //     // Reset 按钮的颜色是红色
        //     tooltip: '重置', // 提供一个工具提示
        //   ),
      ],
    );
  }

}