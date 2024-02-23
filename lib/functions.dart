import 'package:flutter/material.dart';

Future<void> showTimePickerDialog({
  required BuildContext context,
  required Duration initialDuration,
  required ValueChanged<Duration> onDurationChanged,
}) async {
  final TimeOfDay initialTime = TimeOfDay(
      hour: initialDuration.inHours,
      minute: initialDuration.inMinutes.remainder(60),
  );
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: initialTime,
    confirmText: "确定",
    cancelText: "取消",
    helpText: '选择时间',
  );

  if (pickedTime != null) {
    final newDuration = Duration(
      hours: pickedTime.hour,
      minutes: pickedTime.minute,
    );
    onDurationChanged(newDuration);
  }
}


String formatTime(Duration duration, bool displayCurrentTime) {
  // 获取当前系统时间
  final now = DateTime.now();
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(displayCurrentTime ? now.hour : duration.inHours);
  final minutes = twoDigits(
      displayCurrentTime ? now.minute : duration.inMinutes.remainder(60));
  final seconds = twoDigits(
      displayCurrentTime ? now.second : duration.inSeconds.remainder(60));

  return "$hours:$minutes:$seconds";
}
