import 'package:flutter/material.dart';
import 'pages/locker_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Locker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LockerDashboard(),
    );
  }
}
