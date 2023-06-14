import 'dart:convert';
import 'package:capital_especulativo_app/class/wallet.dart';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/scripts/stock_prices.dart';

dynamic process_stocks(List<Map<String, dynamic>> stocks, wallet_id) async {
  var result;
  stocks =
      stocks.where((element) => element["wallet_id"] == wallet_id).toList();
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
    result = wallets;
  } catch (e) {
    result = {};
  }
  return result;
}
