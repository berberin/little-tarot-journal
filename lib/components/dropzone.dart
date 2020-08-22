import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:little_tarot_journal/constants.dart';

class Dropzone extends StatefulWidget {
  @override
  _DropzoneState createState() => _DropzoneState();
}

class _DropzoneState extends State<Dropzone> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: DottedBorder(
        dashPattern: [30, 15, 30, 15],
        strokeWidth: 4,
        color: pastelGreen,
        padding: EdgeInsets.all(0),
        child: Container(
          child: Center(
            child: Column(),
          ),
        ),
      ),
    );
  }
}
