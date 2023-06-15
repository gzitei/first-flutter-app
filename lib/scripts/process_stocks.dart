import 'dart:convert';
import 'package:capital_especulativo_app/class/wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/scripts/stock_prices.dart';

import '../controller/transaction_controller.dart';

dynamic process_stocks(wallet_id) async {
  var result;
  List<Map<String, dynamic>> stocks =
      await TransactionController().getByWallet(wallet_id);
  print(stocks);
  try {
    var wallets = {};
    var wallet;
    num quantidade, valor, media;
    for (var stock in stocks) {
      try {
        var ticker = stock["ticker"];
        var price = await getStockPrices(ticker);
        var wallet_id = stock["wallet_id"];
        if (!wallets.containsKey(wallet_id)) {
          wallets[wallet_id] = {};
        }
        wallet = wallets[wallet_id];
        if (!wallet.containsKey(ticker)) {
          wallets[wallet_id][ticker] = {
            "valor": 0,
            "qtt": 0,
            "media": 0,
            "nome": price["longName"],
            "preco": price["regularMarketPrice"],
            "setor": price["industryDisp"],
            "subsetor": price["sector"]
          };
        }
        quantidade = wallets[wallet_id][ticker]["qtt"];
        valor = wallets[wallet_id][ticker]["valor"];
        media = wallets[wallet_id][ticker]["media"];
        if (stock["type"] == "COMPRA") {
          quantidade = quantidade + stock["quantity"];
          valor = valor + stock["amount"];
        } else {
          quantidade = quantidade - stock["quantity"];
          valor = valor - stock["amount"];
        }
        wallets[wallet_id][ticker]["qtt"] = quantidade;
        wallets[wallet_id][ticker]["valor"] = valor;
        wallets[wallet_id][ticker]["media"] = valor / quantidade;
      } catch (e) {
        print(e);
      }
    }
    result = {wallet_id: {}};
    for (var key in wallets[wallet_id].keys) {
      if (wallets[wallet_id][key]["qtt"] > 0) {
        result[wallet_id][key] = wallets[wallet_id][key];
      }
    }
  } catch (e) {
    result = {};
  }
  return result;
}
