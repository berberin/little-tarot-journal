import 'package:flutter/material.dart';
import 'package:little_tarot_journal/models/tarots.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

class TarotOnBoard extends StatelessWidget {
  final Function onTap;
  final TarotInfo tarotInfo;

  const TarotOnBoard({Key key, this.onTap, this.tarotInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            Container(
              //padding: EdgeInsets.all(30),
              width: 130,
              height: 260,
              transform: tarotInfo.reverse
                  ? Matrix4Transform().rotateDegrees(180, origin: Offset(130 / 2, 260 / 2)).matrix4
                  : null,
              child: Image.asset(
                "assets/images/" + getAssetName(tarotInfo.index),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              tarotInfo.datetime,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
