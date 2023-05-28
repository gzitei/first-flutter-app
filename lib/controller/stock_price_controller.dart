import 'package:capital_especulativo_app/class/stock_prices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class StockPriceController {
  void adicionar(StockPrice s) {
    FirebaseFirestore.instance
        .collection("stock_prices")
        .add(s.toJson())
        .then((value) => print('Cotação adicionada com sucesso!'))
        .catchError((e) => print("Erro: ${e.code.toString()}"));
  }
}
