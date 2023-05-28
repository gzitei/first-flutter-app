import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/login_controller.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({super.key});

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  @override
  Widget build(BuildContext context) {
    var colorRed = Color.fromRGBO(166, 87, 75, 1);
    var colorBlue = Color.fromRGBO(44, 55, 80, 1);
    return Scaffold(
      body: Center(
        child: SelectableText(
          LoginController().idUsuario(),
          style: GoogleFonts.orelegaOne(
              color: colorBlue, fontSize: 35, letterSpacing: 2),
        ),
      ),
    );
  }
}
