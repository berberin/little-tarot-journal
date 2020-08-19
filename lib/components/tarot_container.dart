import 'package:flutter/material.dart';

class TarotImageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Image.asset("assets/images/king-of-swords.jpg"),
    );
  }
}
