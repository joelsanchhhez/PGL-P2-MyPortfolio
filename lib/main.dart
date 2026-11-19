import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'servicios/almacen_token.dart';
import 'servicios/api_sesion.dart';
import 'sesion/controlador_sesion.dart';
import 'tema.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CanchaCanariaApp());
}

/// El controlador y el router viven tanto como la aplicación, sin recrearse en build.
class CanchaCanariaApp extends StatefulWidget {
  const CanchaCanariaApp({super.key, this.sesion});
  final ControladorSesion? sesion;
  @override
  State<CanchaCanariaApp> createState() => _CanchaCanariaAppState();
}

class _CanchaCanariaAppState extends State<CanchaCanariaApp> {
  late final ControladorSesion _sesion;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _sesion = widget.sesion ??
        ControladorSesion(api: ApiSesion(), almacen: AlmacenTokenSeguro());
    _router = AppRouter.crear(_sesion);
    _sesion.restaurar();
  }

  @override
  void dispose() {
    _router.dispose();
    if (widget.sesion == null) {
      _sesion.api.cerrar();
      _sesion.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Cancha Canaria',
        debugShowCheckedModeBanner: false,
        theme: TemaApp.claro,
        routerConfig: _router,
      );
}
