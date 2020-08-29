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
    await arTransaction.sign(wallet);
    await arweave.transactions.post(arTransaction);
    print("done");
    print("arTransaction id: ");
    print(arTransaction.id);
    print(await arweave.wallets.getLastTransactionId(address));
  }

  static Future<List<TarotInfo>> fetchTarotInfoBoard() async {
    return null;
  }
}
