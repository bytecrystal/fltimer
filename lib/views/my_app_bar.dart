import 'package:flipclock/model/user_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../state/app_state.dart';

class MyAppBar extends StatefulWidget {
  const MyAppBar({
    super.key,
  });

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  bool _editing = false;
  late FocusNode _focusNode;
  final TextEditingController _controller = TextEditingController();
  late Offset _tapPosition;

  @override
  void initState() {
    var appState = Provider.of<AppState>(context, listen: false);
    _focusNode = FocusNode();
    _controller.text = appState.userConfig.headTitle.title;

    _focusNode.addListener(() {
      _handleFocusChange(appState);
    });
    super.initState();
  }

  void _handleFocusChange(AppState appState) {
    if (!_focusNode.hasFocus) {
      setState(() {
        _editing = false;
      });
      appState.updateHeadTitle(_controller.text);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context, listen: false);
    UserConfig userConfig = appState.userConfig;
    Color titleBgColor = Color(userConfig.headTitle.bgColor);
    Color titleTextColor = Color(userConfig.headTitle.color);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        // 当用户在这个区域按下鼠标时，调用 WindowManager.startDragging
        onPanStart: (_) => windowManager.startDragging(),
        onDoubleTap: () {
          setState(() {
            _editing = true;
            _focusNode.requestFocus();
            // 调用requestFocus来强制文本字段获取焦点
            // FocusScope.of(context).requestFocus(_focusNode);
          });
        },
        onSecondaryTapDown: (TapDownDetails details) {
          setState(() {
            _tapPosition = details.globalPosition;
          });
        },
        onSecondaryTap: () {
          // 在此处显示弹出菜单
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject() as RenderBox;
          showMenu<Color>(
            context: context,
            position: RelativeRect.fromRect(
              _tapPosition & const Size(48, 48), // 小方块大小作为点击区域
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
            color: titleBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            alignment: Alignment.center,
            child: _editing
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLength: 36,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    onSubmitted: (value) {
                      setState(() {
                        _editing = false;
                      });
                      appState.updateHeadTitle(value);
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      counterText: "", // 隐藏TextField右下角的计数器
                    ),
                  )
                : Text(
                    userConfig.headTitle.title,
                    style: TextStyle(
                      color: titleTextColor,
                      fontSize: 20,
                    ),
                  )),
      ),
    );
  }
}
