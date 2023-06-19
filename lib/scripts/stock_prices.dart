import 'dart:convert';

import 'package:http/http.dart' as http;

dynamic getStockPrices(String stock) async {
  var url = Uri.parse(
      "https://us-central1-capital-17afa.cloudfunctions.net/getPrices/$stock");
  Map<String, String> headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Headers":
        "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS"
  };
  var response = await http.get(url, headers: headers);
  if (response.statusCode.toString().startsWith("2")) {
    var content = json.decode(await response.body);
    var result = await content["quoteSummary"]["result"][0];
    var stock_result = {
      "ticker": stock,
      "industry": result["assetProfile"]["industry"],
      "industryDisp": result["assetProfile"]["industryDisp"],
      "sector": result["assetProfile"]["sector"],
      "regularMarketChangePercent": result["price"]
          ["regularMarketChangePercent"]["fmt"],
      "regularMarketTime": result["price"]["regularMarketTime"],
      "regularMarketPrice": result["price"]["regularMarketPrice"]["raw"],
      "regularMarketPreviousClose": result["price"]
          ["regularMarketPreviousClose"]["raw"],
      "regularMarketOpen": result["price"]["regularMarketOpen"]["raw"],
      "longName": result["price"]["longName"]
    };
    return stock_result;
  } else {
    throw Exception("Erro: ${response.statusCode} - ${response.body}");
  }
}

void main() {
  var stocks = ["ITSA3", "MOVI3", "VULC3", "BBAS3", "ALSO3"];
  stocks.forEach((stock) {
    var price = getStockPrices(stock);
  });
}
