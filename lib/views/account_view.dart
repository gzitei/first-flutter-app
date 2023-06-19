import 'dart:html';
import 'dart:js_interop';

import 'package:capital_especulativo_app/builder/campo_texto.dart';
import 'package:capital_especulativo_app/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

const colorRed = Color.fromRGBO(166, 87, 75, 1);
const colorBlue = Color.fromRGBO(44, 55, 80, 1);

late var user, uid;

final TextEditingController nome = TextEditingController();
final TextEditingController sobrenome = TextEditingController();

dynamic getUser() async {
  var usuario = await LoginController().usuarioLogado();
  return usuario;
}

class _AccountViewState extends State<AccountView> {
  @override
  void initState() {
    var user = getUser();
    var uid = LoginController().idUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBlue,
        title: Text(
          "Minha conta",
          style: GoogleFonts.orelegaOne(fontSize: 28, letterSpacing: 2),
        ),
        toolbarHeight: 120,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
            width: 400,
            padding: EdgeInsets.all(20),
            child: FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  user = snapshot.data! as Map<String, dynamic>;
                  nome.text = user["nome"];
                  sobrenome.text = user["sobrenome"];
                  uid = user["uid"];
                  return Column(
                    children: [
                      campoTexto("Nome", nome, Icon(Icons.person), 16, false,
                          TextInputType.name),
                      SizedBox(
                        height: 10,
                      ),
                      campoTexto("Sobrenome", sobrenome, Icon(Icons.person), 16,
                          false, TextInputType.name),
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
                                print(uid);
                                if (nome.text.isDefinedAndNotNull &&
                                    sobrenome.text.isDefinedAndNotNull) {
                                  user["nome"] = nome.text;
                                  user["sobrenome"] = sobrenome.text;
                                  try {
                                    LoginController().editarUsuario(uid, user);
                                    showPositiveFeedback("Usuário atualizado!");
                                    setState(() {});
                                  } catch (e) {
                                    showNegativeFeedback("Erro ao atualizar!");
                                  }
                                } else {
                                  showNegativeFeedback(
                                      "Nome e Sobrenome são obrigatórios.");
                                }
                              },
                              label: Text(
                                "Atualizar Usuário",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoSlab(fontSize: 18),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(Icons.lock),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: colorRed,
                                  fixedSize: Size.fromHeight(60)),
                              onPressed: () {
                                try {
                                  LoginController()
                                      .esqueceuSenha(context, user["email"]);
                                } catch (e) {
                                  showNegativeFeedback("Erro ao atualizar!");
                                }
                              },
                              label: Text(
                                "Atualizar Senha",
                                style: GoogleFonts.robotoSlab(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
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
