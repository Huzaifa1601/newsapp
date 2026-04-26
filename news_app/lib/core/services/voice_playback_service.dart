import 'package:flutter_tts/flutter_tts.dart';

class VoicePlaybackService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initialize() async {
    await _tts.awaitSpeakCompletion(true);
    await _tts.setSpeechRate(0.48);
    await _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
