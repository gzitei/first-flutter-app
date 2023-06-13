import 'dart:html';

import 'package:capital_especulativo_app/controller/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>> updateStatusInvest({ticker = "BBAS3"}) async {
  dynamic converter(String str) {
    num converted;
    try {
      converted = NumberFormat("0.00", "pt_BR").parse(str);
      return converted;
    } catch (e) {
      var re = RegExp(r"^-.*?%$");
      if (re.allMatches(str).isNotEmpty) {
        return null;
      } else {
        return str;
      }
    }
  }

  Map<String, String> headers = {
    "User-Agent":
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"
  };
  Map<String, dynamic> resultados = {};
  String baseUrl = "https://statusinvest.com.br/acoes/";
  var url = Uri.parse('$baseUrl$ticker');
  await http.get(url, headers: headers).then((response) {
    var document = parse(response.body).body!;
    var h1 = document.getElementsByTagName("h1")[0];
    var h4 = document.getElementsByTagName("h4")[0];
    resultados["ticker"] = ticker;
    resultados["updated-at"] = DateFormat.yMd("pt_br").format(DateTime.now());
    resultados["nome"] = h1.getElementsByTagName("small")[0].text.trim();
    resultados["cnpj"] = h4.getElementsByTagName("small")[0].text.trim();
    var valores = document
        .getElementsByClassName("pb-3 pb-md-5")[0]
        .querySelectorAll(".value");
    valores.forEach(
      (element) {
        var title, value, icon;
        var el = element.parent!.parent!;
        var classTitle = el.getElementsByTagName("H3");
        if (classTitle.isNotEmpty) {
          title = classTitle[0].text.trim();
        }
        var classValue = el.getElementsByClassName("value");
        if (classValue.isNotEmpty) {
          value = classValue[0].text.trim();
        }
        var classIcon = el.getElementsByClassName("icon");
        if (classIcon.isNotEmpty) {
          icon = classIcon[0].text.trim();
        }
        if (title != null && value != null) {
          if (icon == "%") {
            resultados[title] = converter("$value $icon");
          } else {
            resultados[title] = converter(value);
          }
        }
      },
    );
    var indicadores = document
        .getElementsByClassName("pb-5 pt-5")[0]
        .querySelectorAll(".value");
    indicadores.forEach(
      (element) {
        String title = "";
        var value;
        var el = element.parent!.parent!;
        var classTitle = el.getElementsByTagName("H3");
        if (classTitle.isNotEmpty) {
          title = classTitle[0].text.trim();
        }
        var classValue = el.getElementsByClassName("value");
        if (classValue.isNotEmpty) {
          value = classValue[0].text.trim();
        }
        if (title.isNotEmpty && value != null) {
          resultados[title] = converter(value);
        }
      },
    );
    var dividendosHeaders = [];
    var dividendosList = document.getElementsByClassName("list-content")[0];
    dividendosList.getElementsByTagName("th").forEach((e) {
      dividendosHeaders
          .add(e.text.toString().replaceAll("\\n", "").trim().toLowerCase());
    });
    var dividendosRows = dividendosList.getElementsByTagName("tr");
    var dividendosFinal = [];
    for (var dividendoRow in dividendosRows) {
      Map<String, dynamic> dividendo = {};
      var cells = dividendoRow.getElementsByTagName("td");
      for (var i = 0; i < cells.length; i++) {
        var header = dividendosHeaders[i];
        var value = converter(cells[i].text.trim());
        dividendo[header] = value;
      }
      if (dividendo.entries.isNotEmpty) {
        dividendosFinal.add(dividendo);
      }
    }
    resultados["proventos"] = dividendosFinal;
    var macroIndicadores = document
        .getElementsByClassName(
            "top-info info-3 sm d-flex justify-between mb-3")[0]
        .getElementsByClassName("info");
    for (var indicador in macroIndicadores) {
      var value;
      String title = indicador.getElementsByTagName("H3")[0].text.trim();
      value =
          converter(indicador.getElementsByTagName("strong")[0].text.trim());
      if (title.isNotEmpty) {
        if (title.startsWith("Nº total de papéis")) {
          title = "Nº total de papéis";
        }
        resultados[title] = value;
      }
    }
    var dadosSetor = document
        .getElementsByClassName(
            "top-info top-info-1 top-info-sm-2 top-info-md-n sm d-flex justify-between ")[0]
        .getElementsByClassName("sub-value");
    for (var dado in dadosSetor) {
      String title = dado.text.trim();
      var value = dado.parent!.getElementsByClassName("value")[0].text.trim();
      if (title.isNotEmpty) {
        resultados[title] = value;
      }
    }
  }).catchError((e) => print("Erro: $e"));
  return resultados;
}
