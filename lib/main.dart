import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:qr_make_read/advertise/advertise.dart';

import 'package:qr_make_read/application.dart';
import 'database/database.dart';

void main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // final crashlytics = FirebaseCrashlytics.instance;
  // crashlytics.setCrashlyticsCollectionEnabled(true);

  // 광고 init
  AdManager.init();

  runApp(Application(
    databaseRepository: DatabaseRepository())
  );
}