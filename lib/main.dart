import 'package:flutter/material.dart';
import 'screens/chat_bot_screen.dart';
import 'theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Google Bard Gemini',
        theme: theme,
        home: const ChatBotScreen(),
      );
}
