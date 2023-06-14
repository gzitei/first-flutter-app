import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_util';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/class/wallet.dart';
import 'package:capital_especulativo_app/controller/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../class/StockTransaction.dart';

class TransactionController {
  Future<Map<String, dynamic>> get(uid) async {
    var wallet = await FirebaseFirestore.instance
        .collection("transacoes")
        .where('uid', isEqualTo: uid.toString())
        .get();
    List<Map<String, dynamic>> list = [];
    wallet.docs.forEach((element) {
      var id = element.id;
      var data = element.data() as Map<String, dynamic>;
      data["id"] = id;
      list.add(data);
    });
    if (await list.isNotEmpty) {
      return {"ok": true, "transactions": list};
    } else {
      return {"ok": false};
    }
  }

  Future<void> add(StockTransaction st) async {
    try {
      FirebaseFirestore.instance.collection("transacoes").add(st.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> set(StockTransaction st) async {
    try {
      print(st.id);
      await FirebaseFirestore.instance
          .collection("transacoes")
          .doc(st.id)
          .set(st.toJson());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> delete(StockTransaction st) async {
    try {
      await FirebaseFirestore.instance
          .collection("transacoes")
          .doc(st.id)
          .delete();
    } catch (e) {
      throw Exception(e);
    }
  }
}
