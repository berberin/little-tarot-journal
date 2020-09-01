import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:arweave/utils.dart';
import 'package:little_tarot_journal/models/authenticator.dart';
import 'package:little_tarot_journal/models/tarots.dart';
import 'package:steel_crypt/steel_crypt.dart';

class ArweaveHelper {
  static Arweave arweave;
  static String address;
  static Wallet wallet;

  static init() {
    arweave = Arweave();
  }

  static submitData(Uint8List data) async {
    Map<String, String> jsonMap = Map<String, String>();
    String aesKey = CryptKey().genDart();
    String aesKeyEncrypted =
        String.fromCharCodes(Authenticator.rsaEncrypt(utf8.encode(aesKey)));
    jsonMap['k'] = aesKeyEncrypted;

    String dataEncrypted = String.fromCharCodes(
        Authenticator.aesEncrypt(utf8.encode(aesKey), data));
    jsonMap['d'] = dataEncrypted;

    var arTransaction = await arweave.createTransaction(
      Transaction(
        data: json.encode(jsonMap),
      ),
      wallet,
    );
    arTransaction.addTag("app", "little_tarot_journal_v2");
    await arTransaction.sign(wallet);
    await arweave.transactions.post(arTransaction);
  }

  static Future<List<TarotInfo>> fetchTarotInfoBoard() async {
    Map<String, dynamic> query = {
      "op": "and",
      "expr1": {
        "op": "equals",
        "expr1": "app",
        "expr2": "little_tarot_journal_v2",
      },
      "expr2": {
        "op": "equals",
        "expr1": "from",
        "expr2": address,
      }
    };
    List<String> result = await arweave.arql(query);
    print(result);

    List<TarotInfo> tarots = List<TarotInfo>();

    for (var id in result) {
      String data =
          decodeBase64ToString(await arweave.transactions.getData(id));
      try {
        Map<String, String> jsonMap = json.decode(data);
        String aesKeyEncrypted = jsonMap['k'];
        String dataEncrypted = jsonMap['d'];

        Uint8List aesKey =
            Authenticator.rsaDecrypt(utf8.encode(aesKeyEncrypted));
        String dataDecrypted = utf8.decode(
            Authenticator.aesDecrypt(aesKey, utf8.encode(dataEncrypted)));
        TarotInfo temp = TarotInfo.fromJson(json.decode(dataDecrypted));
        tarots.add(temp);
      } catch (e) {
        print(e);
        continue;
      }
    }
    print("returned");
    return tarots;
  }
}
