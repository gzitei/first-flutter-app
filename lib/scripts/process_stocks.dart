import 'dart:convert';
import 'package:capital_especulativo_app/class/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/scripts/stock_prices.dart';

import '../controller/transaction_controller.dart';

dynamic process_stocks(wallet_id) async {
  print(wallet_id);
  var result = {};
  var res = {};
  List<Map<String, dynamic>> stocks =
      await TransactionController().getByWallet(wallet_id);
  dynamic quantidade, valor, media;
  print(stocks);
  for (var stock in stocks) {
    valor = 0;
    media = 0;
    quantidade = 0;
    print(stock);
    var ticker = stock["ticker"];
    if (!result.containsKey(ticker)) {
      result[ticker] = {"valor": valor, "qtt": quantidade, "media": media};
      print(result[ticker]);
    }
    quantidade = result[ticker]["qtt"];
    valor = result[ticker]["valor"];
    media = result[ticker]["media"];
    if (stock["type"] == "COMPRA") {
      print("compra");
      quantidade = quantidade + stock["quantity"];
      valor = valor + stock["amount"];
    } else {
      print("venda");
      quantidade = quantidade - stock["quantity"];
      valor = valor - stock["amount"];
    }
    print("calculado!");
    result[ticker] = {
      "media": valor / quantidade,
      "qtt": quantidade,
      "valor": valor
    };
    print(result[ticker]);
    print(result);
  }
  for (var key in result.keys) {
    print(key);
    if (result[key]["qtt"] > 0) {
      res[key] = result[key];
    }
  }
  print(res);
  return res;
}

dynamic get_price(ticker) async {
  var price = await getStockPrices(ticker);
  print(price);
  return {
    "nome": price["longName"],
    "preco": price["regularMarketPrice"],
    "setor": price["industryDisp"],
    "subsetor": price["sector"]
  };
}

void main() {
  process_stocks("5v20eZdJZQVMk7ymPTdsjqFRUim2");
}
