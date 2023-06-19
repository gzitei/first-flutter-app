// ignore_for_file: prefer_const_constructors

import 'dart:js';
import 'dart:js_interop';
import 'package:intl/intl.dart';
import 'package:capital_especulativo_app/class/wallet.dart';
import 'package:capital_especulativo_app/views/principal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../builder/campo_texto.dart';
import '../controller/wallet_controller.dart';

const colorRed = Color.fromRGBO(166, 87, 75, 1);
const colorBlue = Color.fromRGBO(44, 55, 80, 1);
var index = -1;
Widget show_wallets(BuildContext context) {
  List<Widget> carteiras_lista = [
    Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add),
        style: ElevatedButton.styleFrom(
            backgroundColor: colorRed, fixedSize: Size.fromHeight(40)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                var wallet_name = TextEditingController();
                return AlertDialog(
                  insetPadding: EdgeInsets.all(10),
                  title: Text("Nome da Carteira"),
                  content: Container(
                    width: 300,
                    padding: EdgeInsets.all(10),
                    child: campoTexto(
                      "Nome da Carteira",
                      wallet_name,
                      Icon(Icons.account_balance_wallet),
                      16,
                      false,
                      TextInputType.name,
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () => {Navigator.pop(context)},
                    ),
                    TextButton(
                      child: const Text(
                        "Criar",
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        if (wallet_name.text.isNotEmpty) {
                          Navigator.pop(context);
                          var agora = DateTime.now();
                          var created_at =
                              DateFormat.yMd("pt_BR").format(agora);
                          var creation = agora.millisecondsSinceEpoch;
                          var transactions = [];
                          var id = null;
                          var nome = wallet_name.text;
                          Wallet(uid, created_at, creation, transactions, id,
                              nome);
                          try {
                            WalletController().add(nome, uid);
                            showPositiveFeedback("Carteira criada!", context);
                          } catch (e) {
                            showNegativeFeedback(
                                "Erro ao criar carteira!", context);
                          }
                        }
                      },
                    )
                  ],
                );
              });
        },
        label: Text(
          "Nova Carteira",
          style: GoogleFonts.robotoSlab(fontSize: 18),
        ),
      ),
    )
  ];
  return FutureBuilder(
    future: getWallet(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        var data = snapshot.data! as Map<String, dynamic>;
        if (data["ok"]) {
          var wallets = data["wallets"].map((e) => Wallet.fromJson(e.data()));
          wallets.forEach(
            (wallet) {
              carteiras_lista.add(
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: colorBlue,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Center(
                      child: ListTile(
                        onTap: () {
                          // setState(() {
                          //   var atual = visibility[index];
                          //   for (var i = 0; i < visibility.length; i++) {
                          //     visibility[i] = false;
                          //   }
                          //   if (!atual) {
                          //     visibility[index] = true;
                          //   }
                          // });
                        },
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                wallet.nome,
                                style: TextStyle(color: Colors.white),
                              ),
                              // Text(
                              //   "45%",
                              //   style: TextStyle(
                              //       color: Colors.white),
                              // ),
                            ]),
                        leading: Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.white,
                        ),
                        trailing: GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Deseja deletar?"),
                                  content: Text(
                                      "Não será possível desfazer sua ação."),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      onPressed: () => {Navigator.pop(context)},
                                    ),
                                    TextButton(
                                      child: const Text(
                                        "Confirmar",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // setState(() {
                                        //   var _deleteWallet =
                                        //       _wallets[index];
                                        //   visibility.removeAt(index);
                                        //   try {
                                        //     WalletController().delete(
                                        //         _deleteWallet, context);
                                        //     showPositiveFeedback(
                                        //       "Carteira deletada!",
                                        //     );
                                        //   } catch (e) {
                                        //     showNegativeFeedback(
                                        //         "Erro ao deletar carteira.");
                                        //   }
                                        //   _future_carteira =
                                        //       WalletController().get(uid);
                                        // });
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: carteiras_lista,
          ),
        );
      } else {
        return Container();
      }
      return CircularProgressIndicator();
    },
  );
}

dynamic showPositiveFeedback(String? msg, context) {
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

dynamic showNegativeFeedback(String? msg, context) {
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
