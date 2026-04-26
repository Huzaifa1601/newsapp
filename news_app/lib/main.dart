import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart'; // ✅ ADD THIS

import 'app/app.dart';
import 'app/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ CORRECT WAY
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final container = ProviderContainer();

  await bootstrapApp(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const PulseWireApp(),
    ),
  );
}
