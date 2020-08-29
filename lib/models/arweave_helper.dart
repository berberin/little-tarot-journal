import 'dart:typed_data';

import 'package:arweave/arweave.dart';
import 'package:little_tarot_journal/models/tarots.dart';

class ArweaveHelper{
  static Arweave arweave;
  static String address;
  static Wallet wallet;

  init(){
    arweave = Arweave();
  }

  submitTransaction(Uint8List data) async {

  }

  Future<List<TarotInfo>> fetchTarotInfoBoard() async {

    return null;
  }

}