import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pocketwise/provider/category_provider.dart';
import 'package:pocketwise/provider/dropdown_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'provider/income_provider.dart';
import 'repository/budget.repo.dart';
import 'router/approuter.dart';
import 'utils/constants/colors.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(EasyLocalization(
      path: 'assets/lang',
      supportedLocales: const [
        Locale('en'),
      ],
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => IncomeProvider()),
          ChangeNotifierProvider(create: (context) => BudgetRepository()),
          ChangeNotifierProvider(create: (context) => BudgetLimits()),
          ChangeNotifierProvider(create: (_) => DropdownProvider()),
          ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ],
        child: const MyApp(),
      ),
    ));
  }, (dynamic error, dynamic stack) {});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  List<String> messages = [];
  static const EventChannel _smsChannel = EventChannel('sms_stream');

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _listenToSMS();
  }

  void _listenToSMS() {
    _smsChannel.receiveBroadcastStream().listen((dynamic message) {
      setState(() {
        messages.insert(0, message.toString()); // Add new messages at the top
      });
    }, onError: (dynamic error) {
      print('Received error: ${error}');
    });
  }

  Future<void> requestPermissions() async {
    // Request SMS permission
    final smsStatus = await Permission.sms.status;
    if (!smsStatus.isGranted) {
      final smsResult = await Permission.sms.request();
      if (smsResult.isGranted) {
        print("SMS Permission granted");
      } else if (smsResult.isPermanentlyDenied) {
        openAppSettings(); // Open app settings if permission is permanently denied
      }
    }

    // Request notification permission
    final notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      final notificationResult = await Permission.notification.request();
      if (notificationResult.isGranted) {
        print("Notification Permission granted");
      } else if (notificationResult.isPermanentlyDenied) {
        print("Notification Permission permanently denied");
        openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: AppRouter.initial,
      onGenerateRoute: AppRouter.onGenerateRoute,
      title: 'Pockets - Manage your finances',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'SpaceGrotesk',
      ),
    );
  }
}
