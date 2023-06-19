import 'dart:convert';
import 'package:capital_especulativo_app/class/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/scripts/stock_prices.dart';

import '../controller/transaction_controller.dart';

dynamic process_stocks(wallet_id) async {
  var result = {};
  var res = {};
  List<Map<String, dynamic>> stocks =
      await TransactionController().getByWallet(wallet_id);
  print(stocks);
  dynamic quantidade, valor, media;
  for (var stock in stocks) {
    valor = 0;
    media = 0;
    quantidade = 0;
    var ticker = stock["ticker"];
    if (!result.containsKey(ticker)) {
      result[ticker] = {"valor": valor, "qtt": quantidade, "media": media};
    }
    quantidade = result[ticker]["qtt"];
    valor = result[ticker]["valor"];
    media = result[ticker]["media"];
    if (stock["type"] == "COMPRA") {
      quantidade = quantidade + stock["quantity"];
      valor = valor + stock["amount"];
    } else {
      quantidade = quantidade - stock["quantity"];
      valor = valor - stock["amount"];
    }
    result[ticker] = {
      "media": valor / quantidade,
      "qtt": quantidade,
      "valor": valor
    };
  }
  for (var key in result.keys) {
    if (result[key]["qtt"] > 0) {
      res[key] = result[key];
    }
  }
  return res;
}

dynamic get_price(ticker) async {
  var price;
  try {
    price = await getStockPrices(ticker);
  } catch (e) {
    price = {
      "longName": "-",
      "regularMarketPrice": 0,
      "industryDisp": "-",
      "sector": "-"
    };
  }
  return {
    "nome": price["longName"],
    "preco": price["regularMarketPrice"],
    "setor": price["industryDisp"],
    "subsetor": price["sector"]
  };
}
