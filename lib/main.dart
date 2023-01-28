import 'package:flutter/material.dart';
import 'package:chess_bored/chess_home/chess_home_page.dart';

void main() {
  runApp(const ChessApp());
}

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  // The root of this application :)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChessBored',
      theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
      home: const ChessHomePage(title: 'ChessBored.'),
    );
  }
}
