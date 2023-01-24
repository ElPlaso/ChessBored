import 'package:flutter/material.dart';
import 'package:pocket_chess_app/chess_home/chess_home_page.dart';

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
      title: 'Pocket Chess Lab',
      theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
      home: const ChessHomePage(title: 'PocketChessLab.'),
    );
  }
}
