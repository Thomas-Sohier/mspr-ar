import 'package:flutter/material.dart';

import 'color.dart';
import 'screens/ar_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cerealis AR',
      theme: ThemeData(
        primarySwatch: theme.primaryColor,
        visualDensity: VisualDensity.comfortable,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ARScreen(),
      },
    );
  }
}
