import 'package:flutter/material.dart';
import 'screens/home_shell.dart';
import 'state/cat_tinder_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CatTinderApp());
}

class CatTinderApp extends StatefulWidget {
  final CatTinderState? state;

  const CatTinderApp({super.key, this.state});

  @override
  State<CatTinderApp> createState() => _CatTinderAppState();
}

class _CatTinderAppState extends State<CatTinderApp> {
  late final CatTinderState _state;

  @override
  void initState() {
    super.initState();
    _state = widget.state ?? CatTinderState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatTinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: null,
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
      home: HomeShell(state: _state),
    );
  }
}
