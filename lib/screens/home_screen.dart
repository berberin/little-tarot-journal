import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:little_tarot_journal/components/dropzone.dart';
import 'package:little_tarot_journal/components/tarot_container.dart';
import 'package:little_tarot_journal/constants.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasCard = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Dropzone(),
        ),
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  color: pastelRed,
                ),
              ),
              Expanded(
                flex: 1,
                child: hasCard
                    ? Container(
                        color: pastelOrange,
                        child: TarotImageContainer(),
                      )
                    : Container(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: pastelBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<int> _selectedFile;
  Uint8List _bytesData;

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
  }
}
