import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/gestures.dart'
    show Offset, PointerDeviceKind, PointerDownEvent, TapDownDetails;
import 'package:rive/math.dart';
import 'package:rive/rive.dart';
import 'package:temp_app/helper/helper.dart';

/// Controller for an interactive avatar.
class RiveAvatar {
  /// The main artboard from which controller, inputs, etc. will be taken.
  late final Artboard _artboard;

  /// Storing all inputs and used here for [pointerMove()] method mainly.
  late final StateMachineController _controller;

  final assetsAudioPlayer = AssetsAudioPlayer();

  /// Additional exit and onTap/onPress animation triggers.
  SMITrigger? _hoverInput;
  SMITrigger? _pressInput;
  SMITrigger? _isBlowingInput;

  int isPressedID = 3626;
  int isHoverID = 3627;
  int isBlowingID = 3628;

  ///  Artboard to provide for [Rive] widget.
  Artboard get artboard => _artboard;

  /// Shorthand for animations caching, if used before the runApp(),
  /// WidgetsFlutterBinding.ensureInitialized() has to be called first.
  static Future<RiveFile> get cachedAnimation =>
      RiveFile.asset('asset/images/light_the_candle.riv');

  RiveAvatar(Artboard? artboard) {
    if (artboard == null) {
      throw Exception('No artboards cached!');
    }
    _artboard = artboard;

    /// To find proper artboard there is also _artboard.stateMachines list,
    /// or use static [StateMachineController.fromArtboard] method.
    _controller = StateMachineController(_artboard.stateMachines.first);
    _artboard.addController(_controller);

    /// Also available in _controller.inputs list.

    _hoverInput = _controller.findTrigger('Hover');

    _pressInput = _controller.findTrigger('IsPressed');

    _isBlowingInput = _controller.findTrigger('IsBlowing');
  }

  /// Interface for eyes/head moving from pointer's offset coordinates.
  void move(Offset pointer) => _controller.pointerMoveFromOffset(pointer);

  /// Fires "exit" animation.
  // void onExit() => _hoverInput?.fire();

  void onTapAir() {
    _controller.setInputValue(isPressedID, false);
    _controller.setInputValue(isHoverID, false);
    _controller.setInputValue(isBlowingID, true);
  }

  /// If there was a tap/click on avatar, plays background animation,
  /// and if it was touch input, move eyes/head to follow it and
  /// reset it after one second with "exit" animation.
  bool onTapDown(TapDownDetails details) {
    final isHovered = _controller.getInputValue(isHoverID);

    if (isHovered) {
      _controller.setInputValue(isBlowingID, false);
      _controller.setInputValue(isPressedID, true);
      _controller.setInputValue(isHoverID, true);

      // Fire background animation.
      assetsAudioPlayer.stop();
      final result = assetsAudioPlayer.isPlaying;
      if (result.value == false) {
        assetsAudioPlayer.open(Audio("asset/audio/happy-birthday-to-you-piano-version-13976.mp3"),
            loopMode: LoopMode.single);
      }

      return true;
    } else {
      return false;
    }

    /// If it's a touch input (typically from smartphone, tablet) - continue,
    /// so users on those devices can enjoy a some interactivity too.
  }

  void recognizeUserSwap(Offset offset) {
    move(offset); // Move head/eyes to the tap position.
    // Future.delayed(const Duration(seconds: 1), onExit);
    // Exit after one sec.
    final isHovered = _controller.getInputValue(isHoverID);

    if (isHovered) {
      _controller.setInputValue(isBlowingID, false);
      _controller.setInputValue(isPressedID, true);

      // Fire background animation.
      assetsAudioPlayer.stop();
      final result = assetsAudioPlayer.isPlaying;
      if (result.value == false) {
        assetsAudioPlayer.open(Audio("asset/audio/happy-birthday-to-you-piano-version-13976.mp3"),
            loopMode: LoopMode.single);
      }
    }
  }

  void blowingTheCandle() {
    _controller.setInputValue(isBlowingID, true);
  }
}
