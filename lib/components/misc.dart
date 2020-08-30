import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:little_tarot_journal/constants.dart';

showLoadingDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    content: Container(
      child: Center(
        child: SpinKitWave(
          color: pastelGreen,
          size: 35,
        ),
      ),
    ),
    // content: CircularProgressIndicator(),
  );
  showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) => alert);
}
