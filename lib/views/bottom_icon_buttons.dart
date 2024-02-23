
import 'package:flutter/material.dart';

import '../functions.dart';
import '../state/time_info.dart';

class BottomIconButtons extends StatelessWidget {
  final double iconSize;
  final TimerInfo timerInfo;

  const BottomIconButtons({
    super.key,
    required this.iconSize,
    required this.timerInfo
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!timerInfo.displayCurrentTime &&
            timerInfo.duration.inSeconds > 0)
          IconButton(
            icon: Icon(timerInfo.isRunning
                ? Icons.pause_circle_outline
                : Icons.play_circle_outline),
            onPressed: timerInfo.toggleTimer,
            iconSize: iconSize, // 可以自定义图标大小
            tooltip: '开始/暂停', // 提供一个工具提示
          ),
        // 定义按钮来选择颜色
        IconButton(
          icon: const Icon(Icons.color_lens_outlined),
          onPressed: () => timerInfo.pickColor(context),
          iconSize: iconSize,
          tooltip: '选择颜色', // 提供一个工具提示
        ),
        // SizedBox(height: 20,),
        if (!timerInfo.displayCurrentTime)
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => {
              showTimePickerDialog(
                context: context,
                initialDuration: timerInfo.duration,
                onDurationChanged: (value) {
                  timerInfo.setDuration(value);
                },
              )
            },
            iconSize: iconSize, // 可以自定义图标大小
            tooltip: '选择时间', // 提供一个工具提示
          ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          iconSize: iconSize,
          onPressed: timerInfo.increaseTextSize,
          tooltip: '增加时间文字大小',
        ),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          iconSize: iconSize,
          onPressed: timerInfo.decreaseTextSize,
          tooltip: '减少时间文字大小',
        ),
        IconButton(
          icon: Icon(
            timerInfo.displayCurrentTime
                ? Icons.access_time_outlined
                : Icons.timer_outlined, // 使用条件图标来指示时间类型
          ),
          onPressed: timerInfo.toggleDisplayTime, // 切换显示时间类型
          iconSize: iconSize, // 可以自定义图标大小
          tooltip: '定时器/时钟', // 提供一个工具提示
        ),
        IconButton(
            icon: Icon(
              timerInfo.showAppBar
                  ? Icons.visibility_off_outlined
                  : Icons
                  .visibility_outlined, // 用来表示AppBar的显示状态
            ),
            iconSize: iconSize,
            tooltip: '显示/隐藏标题栏',
            onPressed: timerInfo.toggleAppBar),
        if (!timerInfo.displayCurrentTime &&
            !timerInfo.isRunning &&
            timerInfo.duration.inSeconds == 0)
          IconButton(
            icon: const Icon(Icons.restore_outlined),
            onPressed: () {
              timerInfo.setDuration(timerInfo.duration);
            },
            iconSize: 36,
            // 可以自定义图标大小
            color: Colors.red,
            // Reset 按钮的颜色是红色
            tooltip: '重置', // 提供一个工具提示
          ),
      ],
    );
  }

}