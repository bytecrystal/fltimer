
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../state/time_info.dart';


class TopCustomAppBar extends StatelessWidget {
  final TimerInfo timerInfo;

  const TopCustomAppBar({
    super.key,
    required this.timerInfo
  });

  @override
  Widget build(BuildContext context) {
   return MouseRegion(
     cursor: SystemMouseCursors.click,
     child: GestureDetector(
       // 当用户在这个区域按下鼠标时，调用 WindowManager.startDragging
       onPanStart: (_) => windowManager.startDragging(),
       onDoubleTap: () {
         timerInfo.setEditing(true);
         timerInfo.focusNode.requestFocus();
         // 调用requestFocus来强制文本字段获取焦点
         // FocusScope.of(context).requestFocus(focusNode);
       },
       onSecondaryTapDown: (TapDownDetails details) {
         timerInfo.setTapPosition(details.globalPosition);
       },
       onSecondaryTap: () {
         // 在此处显示弹出菜单
         final RenderBox overlay = Overlay.of(context)
             .context
             .findRenderObject() as RenderBox;
         showMenu<Color>(
           context: context,
           position: RelativeRect.fromRect(
             timerInfo.tapPosition &
             const Size(48, 48), // 小方块大小作为点击区域
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
           color: timerInfo.timeColor,
           padding:
           const EdgeInsets.symmetric(horizontal: 8.0),
           alignment: Alignment.center,
           child: timerInfo.isEditing
               ? TextField(
             controller: timerInfo.controller,
             focusNode: timerInfo.focusNode,
             autofocus: true,
             maxLength: 36,
             textAlign: TextAlign.center,
             style: const TextStyle(
                 fontSize: 20, color: Colors.white),
             onSubmitted: (value) {
               timerInfo.setEditing(false);
               timerInfo.updateTitleText(value);
             },
             decoration: const InputDecoration(
               isDense: true,
               border: InputBorder.none,
               counterText: "", // 隐藏TextField右下角的计数器
             ),
           )
               : Text(
             timerInfo.controller.text.isEmpty
                 ? ''
                 : timerInfo.controller.text,
             style: const TextStyle(
               color: Colors.white,
               fontSize: 20,
             ),
           )),
     ),
   );
  }
}