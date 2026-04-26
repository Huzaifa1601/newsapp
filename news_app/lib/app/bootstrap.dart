import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/service_providers.dart';

Future<void> bootstrapApp(ProviderContainer container) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (_) {
    // The UI can still render demo and cached data before Firebase is configured.
  }

  await container.read(appPreferencesProvider).init();
  await container.read(newsCacheServiceProvider).init();
  await container.read(notificationServiceProvider).initialize();
  await container.read(voicePlaybackServiceProvider).initialize();
}
