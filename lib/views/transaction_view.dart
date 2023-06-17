import 'dart:html';
import 'dart:js_interop';
import 'package:capital_especulativo_app/class/StockTransaction.dart';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/controller/transaction_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../builder/campo_texto.dart';
import '../builder/date_picker.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

var data, i, _edit;
var current_date = DateTime.now();
const colorRed = Color.fromRGBO(166, 87, 75, 1);
const colorBlue = Color.fromRGBO(44, 55, 80, 1);
dynamic getTransactions() async {
  var uid = await FirebaseAuth.instance.currentUser!.uid;
  var transactions = await TransactionController().get(uid);
  return transactions;
}

class _TransactionViewState extends State<TransactionView> {
  @override
  void initState() {
    data = getTransactions();
    i = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlue,
        title: Text(
          "Minhas transações",
          style: GoogleFonts.orelegaOne(fontSize: 28, letterSpacing: 2),
        ),
        toolbarHeight: 120,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> dados = snapshot.data! as Map<String, dynamic>;
            if (dados["ok"]) {
              var lista = dados["transactions"] as List<Map<String, dynamic>>;
              lista.sort((a, b) => b["creation"] - a["creation"]);
              return Center(
                child: Container(
                  width: 600,
                  padding: EdgeInsets.all(10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: lista.length,
                    itemBuilder: (context, index) {
                      var transaction = lista[index] as Map<String, dynamic>;
                      return Column(
                        children: [
                          Card(
                            elevation: 2,
                            shadowColor: Colors.black,
                            borderOnForeground: true,
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: ListTile(
                              leading: Icon(Icons.domain),
                              trailing: i == index
                                  ? Icon(Icons.keyboard_arrow_up)
                                  : Icon(Icons.keyboard_arrow_down),
                              contentPadding: EdgeInsets.all(8),
                              onTap: () {
                                setState(() {
                                  i != index ? i = index : i = -1;
                                });
                              },
                              tileColor: i == index
                                  ? Colors.amber.shade200
                                  : Colors.white,
                              titleTextStyle:
                                  GoogleFonts.robotoSlab(fontSize: 18),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(transaction["ticker"]),
                                  Text(
                                      "${NumberFormat.currency(locale: "pt_BR", symbol: "R\$", decimalDigits: 2).format(transaction["amount"])}"),
                                  Text(transaction["type"])
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.savings,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            transaction["wallet_name"],
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.filter_none,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            transaction["quantity"].toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            transaction["created_at"]
                                                .toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          i == index
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              fixedSize: Size.fromHeight(60)),
                                          onPressed: () {
                                            _edit = lista[index];
                                            TextEditingController ticker =
                                                TextEditingController();
                                            TextEditingController qtt =
                                                TextEditingController();
                                            TextEditingController amount =
                                                TextEditingController();
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  ticker.text = _edit["ticker"];
                                                  qtt.text = _edit["quantity"]
                                                      .toString();
                                                  amount.text = NumberFormat(
                                                          "0.00", "pt_br")
                                                      .format(_edit["amount"]);
                                                  return AlertDialog(
                                                    title: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            GestureDetector(
                                                              child: Icon(
                                                                  Icons.close),
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text("Edição")
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        )
                                                      ],
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    content: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              child: campoTexto(
                                                                "Ticker",
                                                                ticker,
                                                                Icon(Icons
                                                                    .domain),
                                                                16,
                                                                false,
                                                                TextInputType
                                                                    .text,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            SizedBox(
                                                              child: campoTexto(
                                                                "Ações",
                                                                qtt,
                                                                Icon(Icons
                                                                    .filter_none),
                                                                16,
                                                                false,
                                                                TextInputType
                                                                    .number,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            SizedBox(
                                                              child: campoTexto(
                                                                "Valor total",
                                                                amount,
                                                                Icon(Icons
                                                                    .attach_money),
                                                                16,
                                                                false,
                                                                TextInputType
                                                                    .numberWithOptions(
                                                                        decimal:
                                                                            true),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      ElevatedButton
                                                                          .icon(
                                                                    icon: Icon(Icons
                                                                        .price_check),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            colorRed,
                                                                        fixedSize:
                                                                            Size.fromHeight(60)),
                                                                    onPressed:
                                                                        () {
                                                                      if (ticker
                                                                          .text
                                                                          .isEmpty) {
                                                                        showNegativeFeedback(
                                                                            "Ticker é obrigatório!");
                                                                        return;
                                                                      }
                                                                      if (qtt
                                                                          .text
                                                                          .isEmpty) {
                                                                        showNegativeFeedback(
                                                                            "Quantidade é obrigatória!");
                                                                        return;
                                                                      }
                                                                      if (amount
                                                                          .text
                                                                          .isEmpty) {
                                                                        showNegativeFeedback(
                                                                            "Valor total é obrigatório!");
                                                                        return;
                                                                      }
                                                                      _edit["ticker"] =
                                                                          ticker
                                                                              .text;
                                                                      _edit[
                                                                          "amount"] = NumberFormat(
                                                                              "0.00",
                                                                              "pt_br")
                                                                          .parse(
                                                                              amount.text);
                                                                      _edit[
                                                                          "quantity"] = NumberFormat(
                                                                              "0",
                                                                              "pt_br")
                                                                          .parse(
                                                                              qtt.text);
                                                                      var st = StockTransaction
                                                                          .fromJson(
                                                                              _edit);
                                                                      try {
                                                                        TransactionController()
                                                                            .set(st);
                                                                        showPositiveFeedback(
                                                                            "Salvo com sucesso!");
                                                                      } catch (e) {
                                                                        showNegativeFeedback(
                                                                            "Erro ao modificar.");
                                                                      }
                                                                      setState(
                                                                          () {
                                                                        lista[index] =
                                                                            _edit;
                                                                        i = -1;
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      });
                                                                    },
                                                                    label: Text(
                                                                      "Salvar",
                                                                      style: GoogleFonts.robotoSlab(
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                          label: Text(
                                            "Editar",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              fixedSize: Size.fromHeight(60)),
                                          onPressed: () {
                                            var _delete =
                                                StockTransaction.fromJson(
                                                    lista[index]);
                                            try {
                                              TransactionController()
                                                  .delete(_delete);
                                              showPositiveFeedback(
                                                  "Transação deletada!");
                                              setState(
                                                () {
                                                  lista.removeAt(index);
                                                  data = getTransactions();
                                                  i = -1;
                                                },
                                              );
                                            } catch (e) {
                                              print(e);
                                              showNegativeFeedback(
                                                  "Erro ao deletar.");
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                          label: Text(
                                            "Excluir",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      );
                    },
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Faça seu primeiro aporte!",
                  style: GoogleFonts.robotoSlab(
                    fontSize: 18,
                  ),
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  dynamic showPositiveFeedback(String? msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        closeIconColor: Colors.white,
        width: MediaQuery.of(context).size.width - 50,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
        content: Center(
            child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 25,
                child: Center(
                  child: Icon(
                    Icons.check,
                    size: 20,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                msg.isUndefinedOrNull ? "Sucesso!" : msg!,
                style: GoogleFonts.robotoSlab(fontSize: 14),
              ),
            ],
          ),
        )),
      ),
    );
  }

  dynamic showNegativeFeedback(String? msg) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        closeIconColor: Colors.white,
        width: MediaQuery.of(context).size.width - 50,
        showCloseIcon: true,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 3),
        content: Center(
            child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 25,
                width: 25,
                child: Center(
                  child: Icon(
                    Icons.close,
                    size: 20,
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                msg.isUndefinedOrNull ? "Tente novamente!" : msg!,
                style: GoogleFonts.robotoSlab(fontSize: 14),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
