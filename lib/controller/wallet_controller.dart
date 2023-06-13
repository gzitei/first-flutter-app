import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_util';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/builder/feedback.dart';
import 'package:capital_especulativo_app/class/wallet.dart';
import 'package:capital_especulativo_app/controller/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../class/StockTransaction.dart';

class WalletController {
  Future<Map<String, dynamic>> get(uid) async {
    var wallet = await FirebaseFirestore.instance
        .collection("carteiras")
        .where('uid', isEqualTo: uid.toString())
        .get();
    var docs = wallet.docs;
    if (await docs.isNotEmpty) {
      return {"ok": true, "wallets": docs};
    } else {
      return {"ok": false};
    }
  }

  Future<void> add(name, uid) async {
    var agora = DateTime.now();
    var created_at = DateFormat.yMd("pt_br").format(agora);
    var creation = agora.millisecondsSinceEpoch;
    var transactions = <StockTransaction>[];
    var id = null;
    var nome = name;
    var wallet = Wallet(uid, created_at, creation, transactions, id, nome);
    try {
      FirebaseFirestore.instance.collection("carteiras").add(wallet.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> set(Wallet w) async {
    try {
      await FirebaseFirestore.instance
          .collection("carteiras")
          .doc(w.id)
          .set(w.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> delete(Wallet w, context) async {
    try {
      await FirebaseFirestore.instance
          .collection("carteiras")
          .doc(w.id)
          .delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
