import 'dart:typed_data';
import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  Uint8List bytes;
  SecondScreen({Key? key, required this.bytes}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Second Screen'),
          Image.memory(widget.bytes),
        ],
      ));
  }
}