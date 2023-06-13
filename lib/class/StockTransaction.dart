import 'package:flutter/material.dart';

class StockTransaction {
  final String ticker;
  final String uid;
  final String type;
  final String created_at;
  final num creation;
  final num quantity;
  final num amount;
  final String wallet_id;
  final String? id;

  StockTransaction(this.ticker, this.uid, this.type, this.created_at,
      this.creation, this.quantity, this.amount, this.wallet_id, this.id);
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'ticker': ticker,
      'created_at': created_at,
      'type': type,
      'creation': creation,
      'quantity': quantity,
      'amount': amount,
      'wallet_id': wallet_id,
      'id': id
    };
  }

  factory StockTransaction.fromJson(Map<String, dynamic> json) {
    return StockTransaction(
        json['uid'],
        json['ticker'],
        json['created_at'],
        json['type'],
        json['creation'],
        json['quantity'],
        json['amount'],
        json['wallet_id'],
        json['id']);
  }
}
