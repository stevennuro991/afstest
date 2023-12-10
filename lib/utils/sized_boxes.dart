import 'package:flutter/material.dart';

Widget xBox(double width) => XYBox(width: width);

Widget yBox(double height) => XYBox(height: height);

class XYBox extends StatelessWidget {
  final double width, height;

  const XYBox({Key? key, this.width = 0, this.height = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
