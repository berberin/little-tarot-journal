import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:little_tarot_journal/components/dropzone.dart';
import 'package:little_tarot_journal/components/tarot_container.dart';
import 'package:little_tarot_journal/models/tarots.dart';

class HomeScreen extends StatefulWidget {
  static String id = "HomeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Color whitey = Color(0xfffffefe);

class _HomeScreenState extends State<HomeScreen> {
  TarotInfo currentTarotInfo = TarotInfo();
  int index;
  bool reverse;
  int maxIndex = tarotCards.length - 1;
  var random = Random();

  @override
  void initState() {
    super.initState();
    index = 17;
    reverse = true;
  }

  @override
  Widget build(BuildContext context) {
    return (index != null && reverse != null)
        ? Column(
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
                        color: whitey,
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Html(
                                data: tarotCards[index].desc,
                                defaultTextStyle: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: currentTarotInfo != null
                          ? Container(
                              color: whitey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    reverse
                                        ? tarotCards[index].name + " Reversed"
                                        : tarotCards[index].name,
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                  TarotImageContainer(
                                    asset: tarotCards[index].image,
                                    reverse: reverse,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: whitey,
                        child: RaisedButton(
                          child: Text("DRAW A CARD"),
                          onPressed: () async {
                            await _drawCard();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  List<int> _selectedFile;
  Uint8List _bytesData;

  _drawCard() async {
    for (int i = 0; i < 10; i++) {
      setState(() {
        index = random.nextInt(maxIndex);
        reverse = random.nextBool();
      });
      int millis = random.nextInt(300);
      await Future.delayed(Duration(milliseconds: millis));
    }
  }

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
  }
}
