import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playDeletionSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/remove.mp3'));
    } catch (e) {
      debugPrint('Error playing deletion sound: $e');
    }
  }

  static Future<void> playCompletionSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/complete.mp3'));
    } catch (e) {
      debugPrint('Error playing completion sound: $e');
    }
  }
}
