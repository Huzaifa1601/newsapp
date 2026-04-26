import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'app_preferences.dart';
import 'news_cache_service.dart';
import 'notification_service.dart';
import 'voice_playback_service.dart';

final httpClientProvider = Provider<http.Client>((ref) => http.Client());

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences();
});

final newsCacheServiceProvider = Provider<NewsCacheService>((ref) {
  return NewsCacheService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final voicePlaybackServiceProvider = Provider<VoicePlaybackService>((ref) {
  return VoicePlaybackService();
});
