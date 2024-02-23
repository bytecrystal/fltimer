import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;
  final double colorPickerWidth;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
    required this.colorPickerWidth
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('选择颜色'),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: initialColor,
          onColorChanged: onColorChanged,
          colorPickerWidth: 80.0,
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('确定'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
