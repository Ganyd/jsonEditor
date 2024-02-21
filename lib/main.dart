import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:untitled5/widgets/jsonString.dart';

import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON editor',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'JSON Editor'),
    );
  }
}



