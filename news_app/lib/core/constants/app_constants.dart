import 'package:flutter/material.dart';

abstract final class AppConstants {
  static const appName = 'PulseWire';
  static const defaultBackendUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/api/v1',
  );
  static const pageSize = 6;
  static const onboardingPageCount = 4;

  static const supportedLocales = <Locale>[Locale('en'), Locale('ur')];

  static const defaultPreferredCategories = <String>[
    'technology',
    'business',
    'world',
  ];

  static const homeCategories = <String>[
    'all',
    'technology',
    'business',
    'politics',
    'sports',
    'science',
    'culture',
    'health',
  ];
}
