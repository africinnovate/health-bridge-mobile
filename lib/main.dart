import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/di/injection.dart';
import 'core/navigator/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await Injection.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Injection.authProvider),
        ChangeNotifierProvider.value(value: Injection.patientProvider),
        ChangeNotifierProvider.value(value: Injection.specialistProvider),
        ChangeNotifierProvider.value(value: Injection.hospitalProvider),
        ChangeNotifierProvider.value(value: Injection.appointmentProvider),
        ChangeNotifierProvider.value(value: Injection.bloodRequestProvider),
      ],
      child: MyApp(),
    ),
  );
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Health Bridge',
      debugShowCheckedModeBanner: false,
      // router
      routerConfig: AppRouter.router,
      // theme
      // theme: AppTheme.themeDataLight,
      // darkTheme: AppTheme.themeDataDark,
      // themeMode: ThemeMode.system, // Switch based on system theme

      // Set the status bar style
      builder: (context, child) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness:
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark,
          ),
        );

        return child ?? const SizedBox(); // Return the router's content
      },
    );
  }
}
