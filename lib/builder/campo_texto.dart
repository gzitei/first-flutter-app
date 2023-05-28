// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget campoTexto(texto, variable, prefixIcon, size, hidetext, inputtype) {
  size = (size != null) ? size : 18;
  inputtype = (inputtype != null) ? inputtype : TextInputType.text;
  var border = OutlineInputBorder();
  return TextField(
    keyboardType: inputtype,
    obscureText: hidetext,
    controller: variable,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: border,
      labelText: texto,
      labelStyle: GoogleFonts.robotoSlab(fontSize: size),
      prefixIcon: prefixIcon,
      suffixIcon: GestureDetector(
        child: Icon(Icons.clear),
        onTap: () {
          variable.clear();
        },
      ),
    ),
  );
}
