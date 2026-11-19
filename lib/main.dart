import 'package:flutter/material.dart';

import 'app_router.dart';
import 'tema.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CanchaCanariaApp());
}

class CanchaCanariaApp extends StatelessWidget {
  const CanchaCanariaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Cancha Canaria',
        debugShowCheckedModeBanner: false,
        theme: TemaApp.claro,
        routerConfig: AppRouter.router,
      );
}
