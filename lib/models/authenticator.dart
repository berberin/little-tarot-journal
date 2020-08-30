import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:arweave/utils.dart';
import 'package:little_tarot_journal/models/arweave_helper.dart';
import 'package:pointycastle/export.dart';

class Authenticator {
  static bool logged = false;
  // static KeyPair keyPair;
  static RSAPublicKey _publicKey;
  static RSAPrivateKey _privateKey;

  static Future<bool> login(Uint8List key) async {
    Map<String, dynamic> mapJWK = json.decode(String.fromCharCodes(key));
    ArweaveHelper.wallet = Wallet.fromJwk(mapJWK);
    ArweaveHelper.address = ArweaveHelper.wallet.address;
    _publicKey = RSAPublicKey(
      decodeBase64ToBigInt(mapJWK['n']),
      decodeBase64ToBigInt(mapJWK['e']),
    );
    _privateKey = RSAPrivateKey(
      decodeBase64ToBigInt(mapJWK['n']),
      decodeBase64ToBigInt(mapJWK['d']),
      decodeBase64ToBigInt(mapJWK['p']),
      decodeBase64ToBigInt(mapJWK['q']),
    );
    logged = true;
    return logged;
  }

  static Uint8List encrypt(Uint8List data) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(_publicKey)); // true=encrypt

    return _processInBlocks(encryptor, data);
  }

  static Uint8List decrypt(Uint8List data) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(_privateKey)); // false=decrypt

    return _processInBlocks(decryptor, data);
  }

  Uint8List rsaEncrypt(RSAPublicKey myPublic, Uint8List dataToEncrypt) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(true, PublicKeyParameter<RSAPublicKey>(myPublic)); // true=encrypt

    return _processInBlocks(encryptor, dataToEncrypt);
  }

  Uint8List rsaDecrypt(RSAPrivateKey myPrivate, Uint8List cipherText) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(myPrivate)); // false=decrypt

    return _processInBlocks(decryptor, cipherText);
  }

  static Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset) ? output : output.sublist(0, outputOffset);
  }
}
