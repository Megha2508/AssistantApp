import 'package:flutter/material.dart';

import 'Welcome_screen.dart';
import 'features.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        'notification': (context) => NotificationScreen(),
        'rule': (context) => RulesScreen(),
        'settings': (context) => Settings(),
        'newrule': (context) => NewRule()
      },
    );
  }
}
