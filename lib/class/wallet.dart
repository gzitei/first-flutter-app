import 'package:flutter/material.dart';

import 'StockTransaction.dart';

class Wallet {
  final String? id;
  final String uid;
  final String created_at;
  final List<dynamic> transactions;
  final num creation;
  final String nome;

  Wallet(this.uid, this.created_at, this.creation, this.transactions, this.id,
      this.nome);
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'created_at': created_at,
      'creation': creation,
      'transactions': transactions,
      'id': id,
      'nome': nome
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      json['uid'],
      json['created_at'],
      json['creation'],
      json['transactions'],
      json['id'],
      json['nome'],
    );
  }
}
