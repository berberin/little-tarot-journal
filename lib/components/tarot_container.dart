import 'package:flutter/material.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

class TarotImageContainer extends StatelessWidget {
  final String asset;
  final bool reverse;

  TarotImageContainer({this.asset, this.reverse: false});

  @override
  Widget build(BuildContext context) {
    return !reverse
        ? Container(
            //padding: EdgeInsets.all(30),
            width: 400,
            height: 700,
            child: Image.asset(
              "assets/images/" + asset,
              fit: BoxFit.contain,
            ),
          )
        : Container(
            //padding: EdgeInsets.all(30),
            width: 400,
            height: 700,
            transform:
                Matrix4Transform().rotateDegrees(180, origin: Offset(400 / 2, 700 / 2)).matrix4,
            child: Image.asset(
              "assets/images/" + asset,
              fit: BoxFit.contain,
            ),
          );
  }
}
