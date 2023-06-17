import 'dart:convert';

import 'package:flutter/material.dart';

import '../scripts/process_stocks.dart';

import 'package:intl/intl.dart';

Widget listWallet(carteira_id) {
  return FutureBuilder(
    future: process_stocks(carteira_id),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        print(snapshot.data!);
        Map<String, dynamic> snapshotdata =
            json.decode(json.encode(snapshot.data!));
        if (snapshotdata.entries.isEmpty) {
          return Container();
        }
        List<String> keys = List.from(snapshotdata.keys);
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          itemCount: keys.length,
          itemBuilder: (context, pos) {
            var this_stock = keys[pos];
            var stock_price = get_price(this_stock);
            var stock_info = snapshotdata[this_stock] as Map<String, dynamic>;
            print(stock_info);
            return Card(
              elevation: 2,
              shadowColor: Colors.black,
              borderOnForeground: true,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: ListTile(
                leading: FutureBuilder(
                  future: stock_price,
                  builder: (context, price) {
                    if (price.hasData) {
                      var cotacao = price.data! as Map<String, dynamic>;
                      return cotacao["preco"] >= stock_info["media"]
                          ? Icon(
                              Icons.arrow_circle_up,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.arrow_circle_down,
                              color: Colors.red,
                            );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                contentPadding: EdgeInsets.all(8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: Column(
                        children: [
                          Text(
                            this_stock,
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder(
                            future: stock_price,
                            builder: (context, price) {
                              if (price.hasData) {
                                var cotacao =
                                    price.data! as Map<String, dynamic>;
                                return Text(cotacao["nome"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ));
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: stock_price,
                          builder: (context, price) {
                            if (price.hasData) {
                              var cotacao = price.data! as Map<String, dynamic>;
                              return Text(
                                "${NumberFormat.currency(locale: "pt_br", symbol: "R\$", decimalDigits: 2).format(cotacao["preco"])}",
                                style: TextStyle(fontSize: 16),
                              );
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${NumberFormat.currency(locale: "pt_br", symbol: "R\$", decimalDigits: 2).format(stock_info["media"])}",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: stock_price,
                          builder: (context, price) {
                            if (price.hasData) {
                              var cotacao = price.data! as Map<String, dynamic>;
                              return Text(
                                "${NumberFormat.currency(locale: "pt_br", symbol: "R\$", decimalDigits: 2).format(cotacao["preco"] * stock_info["qtt"])}",
                                style: TextStyle(fontSize: 16),
                              );
                            }
                            return CircularProgressIndicator();
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${NumberFormat.currency(locale: "pt_br", symbol: "R\$", decimalDigits: 2).format(stock_info["media"] * stock_info["qtt"])}",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: FutureBuilder(
                  future: stock_price,
                  builder: (context, price) {
                    if (price.hasData) {
                      var cotacao = price.data! as Map<String, dynamic>;
                      var variacao =
                          ((cotacao["preco"] / stock_info["media"]) - 1) * 100;
                      return Text(
                        "${NumberFormat("0.00", "pt_BR").format(variacao)}%",
                        style: TextStyle(
                          color: variacao > 0 ? Colors.green : Colors.red,
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            );
          },
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
