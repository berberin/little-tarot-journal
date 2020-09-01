import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:little_tarot_journal/models/arweave_helper.dart';
import 'package:little_tarot_journal/models/authenticator.dart';
import 'package:little_tarot_journal/screens/home_screen.dart';
import 'package:steel_crypt/steel_crypt.dart';

void main() {
  ArweaveHelper.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Little Tarot Journal',
      theme: ThemeData(
        fontFamily: "Quicksand",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffffefe),
      body: HomeScreen(),
    );
  }
}
