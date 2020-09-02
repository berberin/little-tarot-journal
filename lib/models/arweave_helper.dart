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

  static submitData(String data) async {
    Map<String, String> jsonMap = Map<String, String>();
    String aesKey = CryptKey().genDart();
    String iv = CryptKey().genDart();
    String aesKeyEncrypted =
        encodeBytesToBase64(Authenticator.rsaEncrypt((utf8.encode(aesKey))));
    jsonMap['k'] = aesKeyEncrypted;
    jsonMap['i'] = iv;

    String dataEncrypted = Authenticator.aesEncrypt(aesKey, iv, data);
    jsonMap['d'] = encodeStringToBase64(dataEncrypted);

    var load = jsonEncode(jsonMap);

    var arTransaction = await arweave.createTransaction(
      Transaction(
        data: load,
      ),
      wallet,
    );
    arTransaction.addTag("app", "little_tarot_journal_v3");
    await arTransaction.sign(wallet);
    await arweave.transactions.post(arTransaction);
  }

  static Future<List<TarotInfo>> fetchTarotInfoBoard() async {
    Map<String, dynamic> query = {
      "op": "and",
      "expr1": {
        "op": "equals",
        "expr1": "app",
        "expr2": "little_tarot_journal_v3",
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

    for (int id = result.length - 1; id >= 0; id--) {
      String data =
          decodeBase64ToString(await arweave.transactions.getData(result[id]));
      try {
        Map<String, dynamic> jsonMap = jsonDecode(data);
        Uint8List aesKeyEncrypted = decodeBase64ToBytes(jsonMap['k']);
        String dataEncrypted = decodeBase64ToString(jsonMap['d']);

        String iv = jsonMap['i'];

        Uint8List aesKey = Authenticator.rsaDecrypt(aesKeyEncrypted);
        String dataDecrypted = Authenticator.aesDecrypt(
            String.fromCharCodes(aesKey), iv, dataEncrypted);

        TarotInfo temp = TarotInfo.fromJson(json.decode(dataDecrypted));
        tarots.add(temp);
      } catch (e) {
        continue;
      }
    }
    print("returned");
    return tarots;
  }
}
