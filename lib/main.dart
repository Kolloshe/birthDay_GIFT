import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:temp_app/view/cake_screen.dart';
import 'package:temp_app/view/rive_artbord.dart';

void main() async {
  //setUrlStrategy(PathUrlStrategy());
  // DivRemover.removeFromHTML();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);

  final cachedAnimation = await RiveAvatar.cachedAnimation;
  runApp(MainApp(
    artboard: cachedAnimation.mainArtboard,
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.artboard});
  final Artboard? artboard;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'GreatVibes'),
      home: CakeScreen(
        artboard: artboard!,
      ),
    );
  }
}
// ignore: avoid_web_libraries_in_flutter

// ignore: avoid_classes_with_only_static_members
// class DivRemover {
//   static void removeFromHTML() {
//     final loader = document.getElementsByClassName('loader');
//     if (loader.isNotEmpty) {
//       loader.first.remove();
//     }
//   }
// }
