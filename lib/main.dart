// ignore_for_file: prefer_const_constructors

import 'package:capital_especulativo_app/firebase_options.dart';
import 'package:capital_especulativo_app/views/account_view.dart';
import 'package:capital_especulativo_app/views/principal.dart';
import 'package:capital_especulativo_app/views/transaction_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'views/login.dart';
import 'package:device_preview/device_preview.dart';
import 'views/cadastro.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale("pt", "BR"),
      supportedLocales: [Locale("pt", "BR")],
      debugShowCheckedModeBanner: false,
      title: 'BonanzaTracker - Investimentos',
      theme: ThemeData(),
      home: const LoginView(),
      routes: {
        "cadastro": (context) => CadastroView(),
        "login": (context) => LoginView(),
        "principal": (context) => PrincipalView(),
        "transacoes": (context) => TransactionView(),
        "conta": (context) => AccountView(),
      },
    );
  }
}
