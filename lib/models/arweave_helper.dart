import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:arweave/utils.dart';
import 'package:little_tarot_journal/models/authenticator.dart';
import 'package:little_tarot_journal/models/tarots.dart';

class ArweaveHelper {
  static Arweave arweave;
  static String address;
  static Wallet wallet;

  static init() {
    arweave = Arweave();
  }

  static submitData(Uint8List data) async {
    Transaction transaction = Transaction(
      data: String.fromCharCodes(data),
    );
    var arTransaction = await arweave.createTransaction(
      Transaction(
        data: String.fromCharCodes(data),
      ),
      wallet,
    );
    arTransaction.addTag("app", "little_tarot_journal");
    await arTransaction.sign(wallet);
    await arweave.transactions.post(arTransaction);
  }

  static Future<List<TarotInfo>> fetchTarotInfoBoard() async {
    Map<String, dynamic> query = {
      "op": "equals",
      "expr1": "app",
      "expr2": "little_tarot_journal",
    };
    List<String> result = await arweave.arql(query);
    print(result);
    List<TarotInfo> tarots = List<TarotInfo>();
    String data = await arweave.transactions.getData(result[2]);
    for (var id in result) {
      Uint8List data = decodeBase64ToBytes(await arweave.transactions.getData(id));
      print(String.fromCharCodes(data));
      var trans = await arweave.transactions.get(id);

      Uint8List dataDecrypted = Authenticator.decrypt(data);
      print(String.fromCharCodes(dataDecrypted));
    }
    print(data);
    //fixme:
    return [
      TarotInfo(
        index: 0,
        question: "Who is the fool 1?",
        note: "The Fool.",
        reverse: false,
        datetime: "Aug 30, 2020",
      ),
      TarotInfo(
        index: 0,
        question: "Who is the fool 2?",
        note: "The Fool 2.",
        reverse: false,
        datetime: "Aug 30, 2020",
      ),
      TarotInfo(
        index: 2,
        question: "Who is the fool 4?",
        note: "The Fool 3.",
        reverse: true,
        datetime: "Aug 29, 2020",
      ),
      TarotInfo(
        index: 10,
        question: "Who is the fool 3?",
        note: "The Fool 7.",
        datetime: "Aug 33, 2020",
      ),
      TarotInfo(
        index: 60,
        question: "Who is the fool?",
        note: "The Fool 6.",
        reverse: true,
        datetime: "Aug 32, 2020",
      ),
    ];
  }
}
