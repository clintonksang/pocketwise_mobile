import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

 
// import 'dart:io';

// import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'router/approuter.dart';
import 'utils/constants/colors.dart';

void main() {
  runZonedGuarded(() async{
      
     WidgetsFlutterBinding.ensureInitialized();
 await EasyLocalization.ensureInitialized(); 
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
     runApp(
      EasyLocalization(
        path: 'assets/lang',
        supportedLocales: const [
          Locale('en'),
        ],
        fallbackLocale: const Locale('en'),
        useFallbackTranslations: true,
        child: MyApp())
        );
  }, (dynamic error, dynamic stack) {
    
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
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
         fontFamily: GoogleFonts .spaceGrotesk().fontFamily,
      ),
    );
  }
 
}
