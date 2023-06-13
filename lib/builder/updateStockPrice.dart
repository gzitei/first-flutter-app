import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> updateStockPrice({ticker = "BBAS3"}) async {
  dynamic converter(String str) {
    num converted;
    try {
      converted = NumberFormat("0.00", "pt_BR").parse(str);
      return converted;
    } catch (e) {
      return str;
    }
  }

  Map<String, String> headers = {
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"
  };
  Map<String, dynamic> resultados = {};
  var url =
      Uri.parse('https://www.fundamentus.com.br/detalhes.php?papel=$ticker');
  await http.get(url, headers: headers).then((response) {
    var cells = parse(response.body).body!.getElementsByTagName("td");
    var nivel;
    var label;
    var data;
    for (var cell in cells) {
      if (cell.className.contains("nivel")) {
        nivel = cell.text.trim();
      } else if (cell.className.contains("label")) {
        label = cell.text.replaceAll("?", "").trim();
      } else if (cell.className.contains("data")) {
        data = cell.text.trim();
        data = converter(data);
      }
      if (label != null && data != null) {
        if (nivel != null) {
          resultados["$nivel-$label"] = data;
        } else {
          resultados[label] = data;
        }
        label = null;
        data = null;
      }
    }
  }).catchError((e) => print("Erro: $e"));
  return resultados;
}
