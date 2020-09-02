import 'dart:convert';
import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:arweave/utils.dart';
import 'package:little_tarot_journal/models/arweave_helper.dart';
import 'package:pointycastle/export.dart';
import 'package:steel_crypt/steel_crypt.dart';

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

  static Uint8List rsaEncrypt(Uint8List data) {
    final encryptor = OAEPEncoding(RSAEngine())
      ..init(
          true, PublicKeyParameter<RSAPublicKey>(_publicKey)); // true=encrypt

    return _processInBlocks(encryptor, data);
  }

  static Uint8List rsaDecrypt(Uint8List data) {
    final decryptor = OAEPEncoding(RSAEngine())
      ..init(false,
          PrivateKeyParameter<RSAPrivateKey>(_privateKey)); // false=decrypt

    return _processInBlocks(decryptor, data);
  }

  static String aesEncrypt(String key, String iv, String plaintext) {
    var aesEncrypter = AesCrypt(key: key, padding: PaddingAES.iso78164);
    var crypted = aesEncrypter.cbc.encrypt(inp: plaintext, iv: iv);
    return crypted;
  }

  static String aesDecrypt(String key, String iv, String cipherText) {
    var aesEncrypter = AesCrypt(key: key, padding: PaddingAES.iso78164);
    var plaintext = aesEncrypter.cbc.decrypt(enc: cipherText, iv: iv);
    return plaintext;
  }

  static Uint8List _processInBlocks(
      AsymmetricBlockCipher engine, Uint8List input) {
    final numBlocks = input.length ~/ engine.inputBlockSize +
        ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

    final output = Uint8List(numBlocks * engine.outputBlockSize);

    var inputOffset = 0;
    var outputOffset = 0;
    while (inputOffset < input.length) {
      final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
          ? engine.inputBlockSize
          : input.length - inputOffset;

      outputOffset += engine.processBlock(
          input, inputOffset, chunkSize, output, outputOffset);

      inputOffset += chunkSize;
    }

    return (output.length == outputOffset)
        ? output
        : output.sublist(0, outputOffset);
  }
}
