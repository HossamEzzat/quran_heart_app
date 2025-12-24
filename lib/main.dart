import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/quran_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => QuranProvider())],
      child: MaterialApp(
        title: 'قلب القرآن', // The Quran Heart in Arabic
        debugShowCheckedModeBanner: false,
        // Localization Setup
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', ''), // Arabic Only
        ],
        locale: const Locale('ar', ''),

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD4AF37), // Gold
            brightness: Brightness.dark,
            background: const Color(0xFF0F1E2C), // Night Blue
          ),
          useMaterial3: true,
          fontFamily: GoogleFonts.cairo().fontFamily, // Islamic friendly font
          scaffoldBackgroundColor: const Color(0xFF0F1E2C),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F1E2C),
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
