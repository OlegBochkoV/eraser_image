import 'dart:typed_data';
import 'package:eraser_project/secondScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scratcher/scratcher.dart';
import 'package:screenshot/screenshot.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: BasicScreen())));

class BasicScreen extends StatefulWidget {
  const BasicScreen({Key? key}) : super(key: key);
  @override
  _BasicScreenState createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  double brushSize = 30;
  bool thresholdReached = false;
  List<Uint8List> stageEraser = [];
  bool imageState = true;

  @override
  void initState() {
    super.initState();
    getDirect();
  }

  void getDirect() async {
    ByteData byte = await rootBundle.load('assets/photo.png');
    var bytes = byte.buffer.asUint8List();
    stageEraser.add(bytes);
    imageState = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('log ${stageEraser.length}');
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.arrow_back_ios),
              const Text('Remove the background'),
              InkWell(
                onTap: () {
                  imageState = true;
                  if(stageEraser.length > 1) stageEraser.removeLast();
                  setState(() {});
                  Future.delayed(const Duration(milliseconds: 10)).then((value) {
                    imageState = false;
                    setState(() {});
                  });
                },
                child: const Icon(Icons.arrow_circle_left_outlined)),
              const Icon(Icons.arrow_circle_right_outlined),
            ],
          ),
          const SizedBox(height: 15),
          Expanded(child: Stack(children: [
                ImageEraser(
                  stageEraser: stageEraser, 
                  imageState: imageState, 
                  thresholdReached: thresholdReached, 
                  brushSize: brushSize,
                  pressfunct: pressfunct)])),
          const SizedBox(height: 15),
          Column(
            children: [
              const Text('Eraser size'),
              Slider(
                activeColor: Colors.red,
                value: brushSize,
                onChanged: (v) => setState(() => brushSize = v),
                min: 5,
                max: 100,
              ),
            ],
          ),
          RaisedButton(
            color: Colors.red,
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SecondScreen(bytes: stageEraser.last)
                )
              );
            },
            child: const Text('Continue', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  void pressfunct () => setState(() {});
}

class ImageEraser extends StatefulWidget {
  double brushSize;
  bool thresholdReached;
  List<Uint8List> stageEraser;
  bool imageState;
  VoidCallback pressfunct;
  ImageEraser({
    required this.brushSize, 
    required this.thresholdReached, 
    required this.stageEraser, 
    required this.imageState, 
    required this.pressfunct});
  @override
  _ImageEraserState createState() => _ImageEraserState();
}

class _ImageEraserState extends State<ImageEraser> {
  ScreenshotController screenshotController1 = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return widget.imageState
    ? const CircularProgressIndicator()
    : Screenshot(
      controller: screenshotController1,
      child: Scratcher(
        color: Colors.transparent,
        enabled: true,
        brushSize: widget.brushSize,
        accuracy: ScratchAccuracy.low,
        threshold: 10,
        image: Image.memory(widget.stageEraser.last),
        onScratchEnd: () async {
          final image = await screenshotController1.capture();
          if(image == null) return;
          widget.stageEraser.add(image);
          widget.pressfunct();
        },
        child: Container(),
      ),
    );
  }
}
