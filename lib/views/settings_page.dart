import 'package:flipclock/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'color_picker_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildCard({ required Widget child}) {
    return Card(
      // 卡片的阴影挥发
      elevation: 5.0,
      // 卡片的角度
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }

  Widget _buildCardContainer({ double height = 200,required Widget child, required String title}) {
    return Container(
      width: 300,
      height: height,
      padding: EdgeInsets.all(16),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20), // 用于添加空间
          child
        ],
      ),
    );
  }

  Widget _buildColorConfig({required AppState appState, required String type}) {
    Color bgColor = Color(type == 'clock' ? appState.userConfig.clock.bgColor : appState.userConfig.headTitle.bgColor);
    Color color = Color(type == 'clock' ? appState.userConfig.clock.color : appState.userConfig.headTitle.color);
    return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '背景颜色',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  )
              ),
              SizedBox(height: 5,),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  // color: Colors.black, // 容器内的填充颜色
                  border: Border.all(
                    color: Colors.grey, // 边框颜色
                    width: 5, // 边框宽度
                  ),
                  borderRadius: BorderRadius.circular(5), // 边框的圆角
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ColorPickerDialog(
                        initialColor: bgColor,
                        colorPickerWidth: 350.0,
                        onColorChanged: (Color color) {
                          appState.updateBgColor(type: type, bgColor: color.value);
                        },
                      ),
                    );
                  },
                  child: Container(
                    // width: 30,
                    // height: 30,
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(width: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '文字颜色',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  )
              ),
              SizedBox(height: 5,),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // 边框颜色
                    width: 5, // 边框宽度
                  ),
                  borderRadius: BorderRadius.circular(5), // 边框的圆角
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ColorPickerDialog(
                        initialColor: color,
                        colorPickerWidth: 350.0,
                        onColorChanged: (Color color) {
                          appState.updateColor(type: type, color: color.value);
                        },
                      ),
                    );
                  },
                  child: Container(
                    // width: 30,
                    // height: 30,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              )
            ],
          ),
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.requestFocus();
    return Listener(
      onPointerDown: (PointerDownEvent event) =>
          windowManager.startDragging(), // 当鼠标按下时开始拖拽
      child: Consumer(builder: (context, AppState appState, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("设置"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // 自定义的返回事件
                // 可以调用Navigator.pop()或者你希望执行的其他逻辑
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                  appState.setWindowSizeFromStorage();
                }
              },
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => {},
                child: const Row(
                  children: [
                    Text('重置默认'),
                  ],
                ),
              )
            ],
          ),
          body: KeyboardListener(
            focusNode: _focusNode,
            onKeyEvent: (KeyEvent event) {
              // 检查是否是esc键被按下
              if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
                Navigator.of(context).pop();
                appState.setWindowSizeFromStorage();
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: [
                  _buildCard(
                    child: Container(
                      width: 300,
                      height: 160,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '时钟颜色',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20), // 用于添加空间
                          _buildColorConfig(appState: appState, type: 'clock')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  _buildCard(
                    child: _buildCardContainer(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => {},
                            icon: Icon(Icons.timer_outlined, color: Colors.black),
                          ),
                          SizedBox(width: 10,),
                          Text('10:30:00', style: TextStyle(fontSize: 24),),
                        ],
                      ),
                      title: '倒计时时间',
                      height: 150
                    )
                  ),
                  SizedBox(height: 20,),
                  _buildCard(
                      child: _buildCardContainer(
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  onPressed: () => {},
                                  icon: Icon(Icons.remove, color: Colors.black),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: '', // 输入框上方的标签文本
                                    hintText: '', // 占位符文本
                                  ),
                                  keyboardType: TextInputType.text, // 弹出文本类型的键盘
                                  obscureText: false, // 不隐藏输入（不用于密码类型）
                                  onChanged: (value) {
                                    // 当输入内容变化时调用
                                    print('Input: $value');
                                  },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () => {},
                                  icon: Icon(Icons.add, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          title: '时钟大小',
                          height: 150
                      )
                  ),
                  SizedBox(height: 20,),
                  _buildCard(
                      child: _buildCardContainer(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        labelText: '标题内容', // 输入框上方的标签文本
                                      ),
                                      keyboardType: TextInputType.text, // 弹出文本类型的键盘
                                      obscureText: false, // 不隐藏输入（不用于密码类型）
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30,),
                              Row(
                                children: [
                                  _buildColorConfig(appState: appState, type: 'timer')
                                ],
                              )
                            ],
                          ),
                          title: '标题区域',
                          height: 250
                      )
                  ),
                ]
              )
            ),
          ),
        );
      }),
    );
  }
}