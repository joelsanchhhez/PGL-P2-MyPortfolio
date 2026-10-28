import 'package:flutter/material.dart';

import 'app_router.dart';
import 'tema.dart';

void main() => runApp(const CanchaCanariaApp());

/// MaterialApp aplica el tema y AppRouter contiene la estructura común.
class CanchaCanariaApp extends StatelessWidget {
  const CanchaCanariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cancha Canaria',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      home: const AppRouter(),
    );
  }
}
