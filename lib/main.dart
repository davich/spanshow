import 'package:flutter/material.dart';
import 'screens/shows_screen.dart';

void main() {
  runApp(const SpanShowApp());
}

class SpanShowApp extends StatelessWidget {
  const SpanShowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpanShow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD32F2F),
        ),
        useMaterial3: true,
      ),
      home: const ShowsScreen(),
    );
  }
}
