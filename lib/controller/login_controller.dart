import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../builder/dialog_ok.dart';
import '../builder/toastbar.dart';

class LoginController {
  criarConta(context, nome, sobrenome, email, senha, cpf, nascimento) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((value) {
      //"Conta criada com sucesso."
      FirebaseFirestore.instance.collection('usuarios').add({
        'uid': value.user!.uid,
        'nome': nome,
        'sobrenome': sobrenome,
        'email': email,
        'cpf': cpf,
        'nascimento': nascimento,
      });
      dialog_ok(context, "Conta criada!", "Usuário criado com sucesso!");
      Navigator.pop(context);
    }).catchError((e) {
      //"Não foi possível criar a conta!"
      switch (e.code) {
        case 'email-already-in-use':
          dialog_ok(context, 'O email já foi cadastrado.',
              "Tente recuperar sua senha ou utilize outro e-mail.");
          break;
        case 'invalid-email':
          dialog_ok(context, 'O formato do email é inválido.',
              "Verifique seu e-mail e tente novamente.");
          break;
        default:
          dialog_ok(context, "Houve um erro!", 'ERRO: ${e.code.toString()}');
      }
    });
  }

  login(context, email, senha) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: senha)
        .then((value) {
      toastbar("Usuário autenticado com sucesso!", 2);
      Navigator.pushNamed(context, 'principal');
    }).catchError((e) {
      switch (e.code) {
        case 'invalid-email':
          dialog_ok(context, "Usuário não encontrado!", "E-mail inválido!");
          break;
        case 'user-not-found':
          dialog_ok(
              context, 'Usuário não encontrado!', "Tente recuperar sua senha.");
          break;
        case 'wrong-password':
          dialog_ok(context, "Usuário não encontrado!",
              "E-mail ou senha incorretos.");
          break;
      }
    });
  }

  esqueceuSenha(context, String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    dialog_ok(context, "E-mail enviado!",
        "Orientações para recuperação de senha enviadas para seu e-mail.");
  }

  logout() {
    FirebaseAuth.instance.signOut();
  }

  //
  // ID do Usuário Logado
  //
  idUsuario() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  //
  // NOME do Usuário Logado
  //
  Future<String> usuarioLogado() async {
    var usuario = '';
    await FirebaseFirestore.instance
        .collection('usuarios')
        .where('uid', isEqualTo: idUsuario())
        .get()
        .then(
      (resultado) {
        usuario = resultado.docs[0].data()['nome'] ?? '';
      },
    );
    return usuario;
  }
}
