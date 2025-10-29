import 'package:flutter/material.dart';
import 'appConfig.dart';
import 'package:google_fonts/google_fonts.dart';

class BosquePetrificadoTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppConfig.colorPrincipal,
      scaffoldBackgroundColor: AppConfig.colorSecundario,


      // AppBar global
      appBarTheme: AppBarTheme(
        backgroundColor: AppConfig.colorPrincipal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Botones principales
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.colorPrincipal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: AppConfig.colorPrincipalFondoOscuro.withOpacity(0.5),
          elevation: 4,
        ),
      ),

      // Botones de texto o secundarios
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConfig.colorPrincipalFondoOscuro,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Campos de texto (TextField, etc.)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConfig.colorSecundario,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppConfig.colorPrincipal, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppConfig.colorPrincipal.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(12),
        ),
        labelStyle: TextStyle(color: AppConfig.colorPrincipalFondoOscuro),
        hintStyle: const TextStyle(color: Colors.black45),
      ),

      // Tarjetas, diálogos, etc.
      cardTheme: CardThemeData(
        color: AppConfig.colorSecundario,
        elevation: 3,
        margin: const EdgeInsets.all(10),
        shadowColor: AppConfig.colorPrincipal.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Textos
      textTheme:  GoogleFonts.merriweatherSansTextTheme() // fuenteTextTheme()
          .apply(
        bodyColor: AppConfig.colorPrincipalFondoOscuro,
        displayColor: AppConfig.colorPrincipalFondoOscuro,
      )
          .copyWith(
        titleLarge: GoogleFonts.merriweatherSans( //fuente
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppConfig.colorPrincipalFondoOscuro,
        ),
        bodyMedium: GoogleFonts.merriweatherSans( //fuente
          fontSize: 16,
          color: AppConfig.colorPrincipalFondoOscuro,
        ),
        labelLarge: GoogleFonts.merriweatherSans( //fuente
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Esquema de color general
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppConfig.colorPrincipal,
        onPrimary: Colors.white,
        secondary: AppConfig.colorPrincipalFondoOscuro,
        onSecondary: Colors.white,
        background: AppConfig.colorSecundario,
        onBackground: AppConfig.colorPrincipalFondoOscuro,
        surface: AppConfig.colorSecundario,
        onSurface: AppConfig.colorPrincipalFondoOscuro,
        error: Colors.red.shade700,
        onError: Colors.white,
      ),
    );
  }
}
