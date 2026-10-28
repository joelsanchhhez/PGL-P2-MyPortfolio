import 'package:flutter/material.dart';

/// Paleta definida en la práctica 1 (página 8).
class ColoresApp {
  static const primario = Color(0xFF14345D);
  static const secundario = Color(0xFF9AD9F5);
  static const fondo = Color(0xFFF4F7FA);
  static const texto = Color(0xFF172B42);
  static const error = Color(0xFFB3261E);
}

/// Un único tema evita repetir colores en las pantallas.
class TemaApp {
  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: ColoresApp.primario,
      primary: ColoresApp.primario,
      secondary: ColoresApp.secundario,
      surface: ColoresApp.fondo,
      error: ColoresApp.error,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: ColoresApp.fondo,
      appBarTheme: const AppBarTheme(
        backgroundColor: ColoresApp.primario,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: ColoresApp.texto,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: ColoresApp.texto,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: ColoresApp.texto),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: ColoresApp.primario,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          shape: const StadiumBorder(),
        ),
      ),
    );
  }
}
