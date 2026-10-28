import 'package:flutter/material.dart';

import 'app_router.dart';
import 'tema.dart';

void main() => runApp(const CanchaCanariaApp());

/// La aplicación utiliza MaterialApp.router porque la navegación es declarativa.
class CanchaCanariaApp extends StatelessWidget {
  const CanchaCanariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cancha Canaria',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.claro,
      routerConfig: AppRouter.router,
    );
  }
}
