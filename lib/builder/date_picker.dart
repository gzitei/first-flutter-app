import 'package:capital_especulativo_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget seletorData(
    texto, variable, prefixIcon, size, contexto, onDateChange, current_date) {
  String _date;
  bool hasFocus = false;
  size = (size != null) ? size : 18;
  current_date = (current_date != null) ? current_date : DateTime.now();
  return TextField(
    keyboardType: TextInputType.none,
    enableInteractiveSelection: hasFocus,
    onTap: () {
      hasFocus = !hasFocus;
      showDatePicker(
        locale: Locale('pt', 'BR'),
        context: contexto,
        initialDate: current_date,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      ).then((value) {
        if (value != null) {
          onDateChange(value);
        }
        hasFocus = !hasFocus;
        FocusScope.of(contexto).requestFocus(new FocusNode());
      });
    },
    controller: variable,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(),
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
