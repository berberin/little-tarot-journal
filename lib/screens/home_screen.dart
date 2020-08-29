import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:arweave/utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:little_tarot_journal/components/tarot_container.dart';
import 'package:little_tarot_journal/models/authenticator.dart';
import 'package:little_tarot_journal/models/tarots.dart';

import '../constants.dart';

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
  String question;
  String note;
  int maxIndex = tarotCards.length - 1;

  bool logged;
  bool enableEdit;
  DropzoneViewController controller;

  TextEditingController questionController;
  TextEditingController noteController;

  Wallet wallet;
  Arweave client = Arweave();
  var balance;

  var random = Random();

  @override
  void initState() {
    super.initState();
    logged = Authenticator.logged;
    enableEdit = true;
    questionController = TextEditingController();
    noteController = TextEditingController();

    //fixme:
    _setDemoCurrentInfoCard();
  }

  @override
  void dispose() {
    questionController.dispose();
    noteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: !logged ? _dropzone() : _futureBuilderListCard(),
        ),
        (index != null && reverse != null)
            ? Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: whitey,
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 5,
                          top: 10,
                          bottom: 10,
                        ),
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
                                  color: vertEmpire,
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
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3.0,
                                          color: pastelBlue,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        color: whitey,
                                      ),
                                      child: Text(
                                        reverse
                                            ? tarotCards[index].name + " Reversed"
                                            : tarotCards[index].name,
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500,
                                          color: vertEmpire,
                                        ),
                                      ),
                                    ),
                                    TarotImageContainer(
                                      asset: tarotCards[index].image,
                                      reverse: reverse,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: whitey,
                        padding: EdgeInsets.only(
                          left: 5,
                          right: 30,
                          top: 10,
                          bottom: 10,
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              (question == "" || question == null)
                                  ? Container()
                                  : Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Your question",
                                            style: Theme.of(context).textTheme.headline5.copyWith(
                                                  color: vertEmpire,
                                                ),
                                          ),
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(
                                                enableEdit ? question : currentTarotInfo.question,
                                                style: TextStyle(
                                                  color: vertEmpire,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Date",
                                  style: Theme.of(context).textTheme.headline5.copyWith(
                                        color: vertEmpire,
                                      ),
                                ),
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Text(
                                    enableEdit
                                        ? DateFormat.yMMMd().format(DateTime.now())
                                        : currentTarotInfo.datetime,
                                    style: TextStyle(
                                      color: vertEmpire,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.only(
                                  bottom: 40,
                                ),
                                child: TextFormField(
                                  maxLines: 8,
                                  decoration: InputDecoration(
                                    hintText: "Your note about this reading",
                                    labelText: "Note",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                  ),
                                  readOnly: !enableEdit,
//                                  focusNode: FocusNode(),
//                                  enableInteractiveSelection: false,
                                  initialValue: enableEdit ? null : currentTarotInfo.note,
                                  controller: enableEdit ? noteController : null,
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              enableEdit
                                  ? raisedButton(
                                      title: "SAVE YOUR JOURNAL",
                                      color: pastelGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      onPressed: () async {
                                        await _saveYourJournal();
                                      },
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Your journal will be stored securely."),
                              SizedBox(
                                height: 20,
                              ),
                              raisedButton(
                                title: "DRAW A NEW CARD",
                                color: pastelOrange,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                onPressed: () {
                                  setState(() {
                                    index = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : _startDrawCardWidget(),
      ],
    );
  }

  _drawCard() async {
    for (int i = 0; i < 10; i++) {
      setState(() {
        index = random.nextInt(maxIndex);
        reverse = random.nextBool();
      });
      int millis = random.nextInt(200);
      await Future.delayed(Duration(milliseconds: millis));
    }
    currentTarotInfo = TarotInfo(
      index: index,
      reverse: reverse,
      question: question,
      datetime: DateFormat.yMMMd().format(DateTime.now()),
    );
  }

  _setDemoCurrentInfoCard() {
    //fixme:
    enableEdit = false;
    currentTarotInfo = TarotInfo(
      index: 1,
      reverse: false,
      question: "Where is my cat?",
      note:
          "The output of cipher.process is plain bytes, so you can pick any valid interpretation for them. Using UTF8.decode may break because the bytes are not valid UTF-8, but String.fromCharCodes will treat the bytes as Latin-1, which is always valid. Another possibility is to convert the bytes to a Uint16List, storing two bytes in each character (but that gets complicated if there is an odd number of bytes).The output of cipher.process is plain bytes, so you can pick any valid interpretation for them. Using UTF8.decode may break because the bytes are not valid UTF-8, but String.fromCharCodes will treat the bytes as Latin-1, which is always valid. Another possibility is to convert the bytes to a Uint16List, storing two bytes in each character (but that gets complicated if there is an odd number of bytes).",
      datetime: DateFormat.yMMMd().format(DateTime.now()),
    );
    index = currentTarotInfo.index;
    reverse = currentTarotInfo.reverse;
    question = currentTarotInfo.question;
  }

  Widget _dropzone() {
    return Stack(
      children: [
        DropzoneView(
          operation: DragOperation.copy,
          cursor: CursorType.grab,
          onCreated: (ctrl) => controller = ctrl,
          onDrop: (ev) async => print(await controller.getFileData(ev)),
        ),
        InkWell(
          child: Container(
            padding: EdgeInsets.all(30),
            child: DottedBorder(
              dashPattern: [30, 15, 30, 15],
              strokeWidth: 4,
              color: pastelGreen,
              padding: EdgeInsets.all(0),
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        dropUsage,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onTap: () async {
            dynamic ev = await controller.pickFiles(multiple: false);
            Uint8List data = await controller.getFileData(ev[0]);
            logged = await Authenticator.login(data);
            balance = await client.wallets.getBalance(Authenticator.address);
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget _futureBuilderListCard() {
    return Container(
      child: Column(
        children: [
          Text(Authenticator.address),
          Text(winstonToAr(BigInt.parse(balance))),
        ],
      ),
    );
  }

  Widget _startDrawCardWidget() {
    return Expanded(
      flex: 4,
      child: Container(
        padding: EdgeInsets.all(50),
        color: whitey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Relax and center yourself before the reading takes place.\nEmbrace the unknown.\nAddress your questions clearly.",
                style: TextStyle(
                  fontSize: 24,
                  color: vertEmpire,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 90,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Write out your question (optional)",
                    labelText: "Your question",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    focusColor: pastelPurple,
                  ),
                  maxLines: 2,
                  controller: questionController,
                ),
              ),
              SizedBox(
                height: 90,
              ),
              raisedButton(
                title: "DRAW A CARD",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: pastelBlue,
                onPressed: () {
                  enableEdit = true;
                  question = questionController.text;
                  _drawCard();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  RaisedButton raisedButton(
      {String title, double fontSize, FontWeight fontWeight, Function onPressed, Color color}) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: "Quicksand",
            fontSize: fontSize,
            color: vertEmpire,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      color: color,
      onPressed: () => onPressed(),
    );
  }

  _saveYourJournal() async {
    currentTarotInfo.note = noteController.text;
    String journal = currentTarotInfo.toJson();
    Uint8List journalEncryted = Authenticator.encrypt(utf8.encode(journal));
    // send journal to Arweave
  }
}
