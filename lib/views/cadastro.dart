// ignore_for_file: prefer_const_constructors

import 'package:capital_especulativo_app/builder/dialog_ok.dart';
import 'package:capital_especulativo_app/controller/login_controller.dart';
import 'package:capital_especulativo_app/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../builder/campo_texto.dart';
import 'package:intl/intl.dart';
import '../builder/date_picker.dart';

class CadastroView extends StatefulWidget {
  const CadastroView({super.key});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  var colorRed = Color.fromRGBO(166, 87, 75, 1);
  var colorBlue = Color.fromRGBO(44, 55, 80, 1);
  var name = TextEditingController();
  var surname = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var passwordCheck = TextEditingController();
  var cpf = TextEditingController();
  var birth = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var current_date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlue,
        title: Text(
          "Cadastro",
          style: GoogleFonts.orelegaOne(fontSize: 30, letterSpacing: 2),
        ),
        toolbarHeight: 120,
        centerTitle: true,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  bottom: BorderSide(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                color: colorRed,
              ),
              height: 18,
            ),
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: campoTexto(
                            "Nome",
                            name,
                            Icon(Icons.person),
                            16,
                            false,
                            TextInputType.name,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: campoTexto(
                              "Sobrenome",
                              surname,
                              Icon(Icons.person),
                              16,
                              false,
                              TextInputType.name),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    campoTexto("E-mail", email, Icon(Icons.email), 16, false,
                        TextInputType.emailAddress),
                    SizedBox(
                      height: 10,
                    ),
                    campoTexto("Senha", password, Icon(Icons.lock), 16, true,
                        TextInputType.visiblePassword),
                    SizedBox(
                      height: 10,
                    ),
                    campoTexto(
                        "Confirme sua senha",
                        passwordCheck,
                        Icon(Icons.lock),
                        16,
                        true,
                        TextInputType.visiblePassword),
                    SizedBox(
                      height: 10,
                    ),
                    campoTexto(
                        "CPF",
                        cpf,
                        Icon(Icons.contacts),
                        16,
                        false,
                        TextInputType.numberWithOptions(
                            decimal: true, signed: true)),
                    SizedBox(
                      height: 10,
                    ),
                    seletorData(
                      "Data de nascimento",
                      birth,
                      Icon(Icons.calendar_month),
                      16,
                      context,
                      (value) {
                        if (value != null) {
                          setState(
                            () {
                              current_date = value;
                              birth.text =
                                  DateFormat.yMd("pt_br").format(value);
                            },
                          );
                        }
                      },
                      current_date,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.how_to_reg),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: colorRed,
                                fixedSize: Size.fromHeight(60)),
                            onPressed: () {
                              if (name.text.isEmpty) {
                                dialog_ok(context, "Campo Obrigatório",
                                    "Nome é um campo obrigatório!");
                                return;
                              }
                              if (surname.text.isEmpty) {
                                dialog_ok(context, "Campo Obrigatório",
                                    "Sobrenome é um campo obrigatório!");
                                return;
                              }
                              if (email.text.isEmpty) {
                                dialog_ok(context, "Campo Obrigatório",
                                    "E-mail é um campo obrigatório!");
                                return;
                              }
                              if (password.text.isEmpty) {
                                dialog_ok(context, "Campo Obrigatório",
                                    "Senha é um campo obrigatório!");
                                return;
                              }
                              if (passwordCheck.text.isEmpty) {
                                dialog_ok(context, "Campo Obrigatório",
                                    "A confirmação da senha é um campo obrigatório!");
                                return;
                              }
                              if (cpf.text.isEmpty) {
                                dialog_ok(context, "Campo Obrigatório",
                                    "CPF é um campo obrigatório!");
                                return;
                              }
                              if (birth.text.isEmpty) {
                                dialog_ok(context, "Campo Obrigatório",
                                    "Data de nascimento é um campo obrigatório!");
                                return;
                              }
                              if (passwordCheck.text != password.text) {
                                dialog_ok(context, "Confirmação de Senha",
                                    "Não foi possível confirmar sua senha!");
                                return;
                              }
                              LoginController().criarConta(
                                context,
                                name.text,
                                surname.text,
                                email.text,
                                password.text,
                                cpf.text,
                                birth.text,
                              );
                            },
                            label: Text(
                              "Cadastrar",
                              style: GoogleFonts.robotoSlab(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
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
