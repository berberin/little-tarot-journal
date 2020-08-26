import 'dart:typed_data';

class Authenticator {
  static bool logged = false;
  static String address = "";
  static Uint8List keyFile;
  static String privateKey;
  static String publicKey;
}

Future<bool> login(Uint8List key) async {
  return false;
}
