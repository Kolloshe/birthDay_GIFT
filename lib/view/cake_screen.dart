import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';

import 'package:rive/rive.dart';

import 'rive_artbord.dart';

class CakeScreen extends StatefulWidget {
  CakeScreen({super.key, required this.artboard}) : _avatar = RiveAvatar(artboard);
  final Artboard artboard;

  final RiveAvatar _avatar;

  @override
  State<CakeScreen> createState() => _CakeScreenState();
}

class _CakeScreenState extends State<CakeScreen> {
  @override
  void initState() {
    //  startRecording();
    super.initState();
  }

  double animationTrigger = 0.0;

  String personName = 'OMNYA';

  String mainMessage = 'Happy birthday! I hope all your birthday wishes and dreams come true.';

  String subMessage =
      "A wish for you on your birthday, whatever you ask may you receive, whatever you seek may you find, whatever you wish may it be fulfilled on your birthday and always. Happy birthday!";

  bool isLighting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(237, 244, 139, 167),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: FittedBox(
              child: GestureDetector(
                onTapDown: (details) {
                  isLighting = widget._avatar.onTapDown(details);

                  if (isLighting) {
                    animationTrigger = 1.0;
                    setState(() {});
                  }
                },
                onPanUpdate: (details) {
                  widget._avatar.recognizeUserSwap(details.localPosition);
                },
                child: MouseRegion(
                  onExit: (_) => widget._avatar.onExit(),
                  onHover: (event) => widget._avatar.move(event.localPosition),
                  // The useArtboardSize is important for accurate pointer position.
                  child: RepaintBoundary(
                    child: Rive(
                      fit: BoxFit.cover,
                      artboard: widget._avatar.artboard,
                      useArtboardSize: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned(child: Image.asset('asset/images/8793602.png'))
          //     .animate()
          //     .move(begin: Offset(0, 0), end: Offset(10, 10))
          //     .scaleXY(begin: 0.5, end: 1),
          Positioned(
            top: 20,
            left: 10,
            child: Text(
              "$mainMessage $personName",
              style:
                  const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ).animate(target: animationTrigger).fade(),
          Positioned(
            bottom: 10,
            left: 20,
            width: MediaQuery.of(context).size.width * 0.95,
            child: Text(
              subMessage,
              maxLines: 2,
              style:
                  const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ).animate(target: animationTrigger).fade(),

          Positioned(
              top: 90,
              left: 230,
              child: GestureDetector(
                onLongPressStart: (details) async {
                  await Future.delayed(1.seconds);
                  widget._avatar.onTapAir();
                  isLighting = false;
                  setState(() {});
                },
                child: Container(
                  color: Colors.transparent,
                  width: 80,
                  height: 80,
                ),
              )),
          // AnimatedPositioned(
          //     left: 2,
          //     top: isLighting ? -350 : 500,
          //     child: Image.asset(
          //       'asset/images/pngwing.com.png',
          //       width: 90,
          //     ),
          //     duration: 1.seconds),
          // AnimatedPositioned(
          //         right: 2,
          //         top: isLighting ? -350 : 500,
          //         child: Image.asset(
          //           'asset/images/pngwing.com.png',
          //           width: 90,
          //         ),
          //         duration: 1.seconds)
          //     .animate()
          //     .shake(duration: 1.seconds)
        ],
      ),
    );
  }

  // void startRecording() async {
  //   TfliteAudio.loadModel(
  //     model: 'asset/mod/soundclassifier_with_metadata.tflite',
  //     label: 'asset/mod/labels.txt',
  //     inputType: 'rawAudio',
  //   );
  // }

  // String _sound = "Press the button to start";
  // bool _recording = false;
  // late Stream<Map<dynamic, dynamic>> result;
  // bool isDone = false;
  // void _recorder() async {
  //   String recognition = "";
  //   if (!_recording) {
  //     // setState(() => _recording = true);
  //     result = TfliteAudio.startAudioRecognition(
  //       numOfInferences: 1,
  //       sampleRate: 44100,
  //       bufferSize: 22016,
  //     );

  //     result.listen((event) {
  //       recognition = event["recognitionResult"];
  //     }).onDone(() {
  //       setState(() {
  //         _recording = false;
  //         _sound = recognition.split(" ")[1];
  //       });
  //     });
  //     if (_sound.toLowerCase() == 'backgrond') {
  //       widget._avatar.blowingTheCandle();
  //       setState(() {});
  //     }

  //     await Future.delayed(1.seconds);
  //   }
  // }

  // void stopRecording() => TfliteAudio.stopAudioRecognition();
}
