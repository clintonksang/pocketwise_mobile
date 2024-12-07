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
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    final status = await Permission.sms.status;
    if (!status.isGranted) {
      final result = await Permission.sms.request();
      if (result.isGranted) {
        // Permission granted
        print("SMS Permission granted");
      } else if (result.isPermanentlyDenied) {
        // The user opted not to grant permission and chose not to be asked again (Android).
        // You can open app settings here if you want to let your user manually enable permissions.
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


