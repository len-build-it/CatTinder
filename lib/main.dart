import 'package:flutter/material.dart';

void main() {
  runApp(const CatTinderApp());
}

class CatTinderApp extends StatelessWidget {
  const CatTinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatTinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF6F61), // Warm Coral
          primary: const Color(0xFFFF6F61),
          secondary: const Color(0xFFFF8E72),
          surface: const Color(0xFFFFFBF9),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8F6),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const Scaffold(
        body: Center(
          child: Text('CatTinder 🐾'),
        ),
      ),
    );
  }
}
