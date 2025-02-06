import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Phone Dialer",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BottomNav(),
    );
  }
}
