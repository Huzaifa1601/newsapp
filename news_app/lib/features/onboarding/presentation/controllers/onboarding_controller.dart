import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/services/app_preferences.dart';
import '../../../../core/services/service_providers.dart';

class OnboardingController extends StateNotifier<bool> {
  OnboardingController(this._preferences)
    : super(_preferences.isOnboardingSeen);

  final AppPreferences _preferences;

  Future<void> complete() async {
    state = true;
    await _preferences.setOnboardingSeen();
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, bool>((ref) {
      return OnboardingController(ref.read(appPreferencesProvider));
    });
