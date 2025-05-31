import 'package:flutter/material.dart';
import 'package:test_drive/widgets/expenses.dart';
import 'package:flutter/services.dart';

var kColorScheme=ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 46, 56, 194));

var kDarkColorScheme= ColorScheme.fromSeed(brightness: Brightness.dark,seedColor: const Color.fromARGB(255, 5, 99, 125),);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) { 
    runApp(
    MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal:16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer, //primacont..:- background colour
            foregroundColor: kDarkColorScheme.onPrimaryContainer, //on.. :- text colour
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        scaffoldBackgroundColor:  const Color.fromARGB(255, 90, 120, 192),
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal:16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, color: kColorScheme.onSecondaryContainer, fontSize: 16),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const Expenses(),
    ),
  );
});
  
}
