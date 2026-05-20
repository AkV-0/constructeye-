import 'screens/HomeScreen.dart';
import 'screens/LoginScreen.dart';
import 'providers/SiteProvider.dart';

import 'providers/RoleProvider.dart';
import 'providers/PhotoProvider.dart';
import 'providers/ReportProvider.dart';
import 'providers/ThemeProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ConstructEyeApp());
}

class ConstructEyeApp extends StatelessWidget {
  const ConstructEyeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SiteProvider()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'ConstructEye',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF4F5F5),
              cardColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF37353E)),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF37353E),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF715A5A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF121212),
              cardColor: const Color(0xFF1E1E1E),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF37353E),
                brightness: Brightness.dark,
                surface: const Color(0xFF1E1E1E),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF1F1E24),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF715A5A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            home: FirebaseAuth.instance.currentUser == null
                ? LoginScreen()
                : HomeScreen(),
          );
        },
      ),
    );
  }
}
