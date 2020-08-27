import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:jose/jose.dart' show JsonWebKey;

class Authenticator {
  static bool logged = false;
  static String address;
  static JsonWebKey jwk;
  static Wallet wallet;

  static Future<bool> login(Uint8List key) async {
    Map<String, dynamic> mapJWK = json.decode(String.fromCharCodes(key));
    wallet = Wallet.fromJwk(mapJWK);
    address = wallet.address;
    jwk = JsonWebKey.fromJson(mapJWK);
    logged = true;
    return logged;
  }
}
