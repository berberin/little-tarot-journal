import 'dart:typed_data';

import 'package:arweave/arweave.dart';
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
    print(wallet.address);
    var arTransaction = await arweave.createTransaction(
      Transaction(
        data: String.fromCharCodes(data),
      ),
      wallet,
    );
    arTransaction.addTag("test-tag-1", "test-value-1");
    arTransaction.addTag("test-tag", "little-tarot");
    await arTransaction.sign(wallet);
    await arweave.transactions.post(arTransaction);
    print("done");
    print("arTransaction id: ");
    print(arTransaction.id);
    print(await arweave.wallets.getLastTransactionId(address));
  }

  static Future<List<TarotInfo>> fetchTarotInfoBoard() async {
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
