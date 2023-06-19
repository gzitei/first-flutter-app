// ignore_for_file: prefer_const_constructors
import 'package:capital_especulativo_app/class/StockTransaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../builder/dialog_ok.dart';
import '../builder/status_invest.dart';
import '../controller/login_controller.dart';
import '../builder/campo_texto.dart';

import 'dart:convert';

// var marx = AssetImage("lib/images/marx.png");

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  var colorRed = Color.fromRGBO(166, 87, 75, 1);
  var colorBlue = Color.fromRGBO(44, 55, 80, 1);
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var screen = (contexto) => MediaQuery.of(contexto).size;
  var hidePassword = true;

  @override
  Widget build(BuildContext context) {
    var hiddenPasswordIcon =
        hidePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      height: screen(context).height * .25,
                      width: screen(context).height * .25,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorRed,
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Icon(
                          Icons.savings,
                          size: (screen(context).height * .25) - 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "BonanzaTracker",
                      style: GoogleFonts.orelegaOne(
                          color: colorBlue, fontSize: 40, letterSpacing: 1),
                    ),
                    Text(
                      "investimentos",
                      style: GoogleFonts.orelegaOne(
                          color: colorBlue, fontSize: 25, letterSpacing: 3),
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                color: colorRed,
              ),
              height: 15,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                width: screen(context).width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  color: colorBlue,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: 400,
                      child: campoTexto(
                        "E-mail",
                        txtEmail,
                        Icon(Icons.email_rounded),
                        18,
                        false,
                        TextInputType.emailAddress,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 40,
                      width: 400,
                      child: TextButton(
                        onPressed: () {
                          var email = txtEmail.text;
                          if (email.isEmpty) {
                            dialog_ok(
                              context,
                              "Informe seu e-mail",
                              "Preencha o campo e-mail para recuperar sua senha.",
                            );
                          } else {
                            LoginController().esqueceuSenha(context, email);
                          }
                        },
                        child: Text(
                          "Esqueceu sua senha?",
                          style: GoogleFonts.robotoSlab(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        obscureText: hidePassword,
                        controller: txtSenha,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Senha",
                          labelStyle: GoogleFonts.robotoSlab(fontSize: 18),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(
                                () {
                                  hidePassword = !hidePassword;
                                },
                              );
                            },
                            child: hiddenPasswordIcon,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      alignment: Alignment.bottomCenter,
                      width: 400,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.login),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorRed,
                                minimumSize: Size(155, 60),
                              ),
                              onPressed: () {
                                var email = txtEmail.text;
                                var senha = txtSenha.text;
                                if (email.isNotEmpty && senha.isNotEmpty) {
                                  LoginController()
                                      .login(context, email, senha);
                                } else {
                                  dialog_ok(
                                    context,
                                    "Faltam dados",
                                    "Preencha e-mail e senha, por favor.",
                                  );
                                }
                              },
                              label: Text(
                                "Entrar",
                                style: GoogleFonts.robotoSlab(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.person_add),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorRed,
                                minimumSize: Size(155, 60),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, "cadastro");
                              },
                              label: Text(
                                "Cadastro",
                                style: GoogleFonts.robotoSlab(fontSize: 18),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
