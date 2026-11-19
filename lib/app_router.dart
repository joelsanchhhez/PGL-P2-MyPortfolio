import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pantallas/ajustes.dart';
import 'pantallas/inicio.dart';
import 'pantallas/instalaciones.dart';
import 'pantallas/portfolio.dart';
import 'pantallas/login.dart';
import 'pantallas/registro.dart';
import 'excepciones/error_api.dart';
import 'servicios/servicio_sesion.dart';
import 'widgets/alerta_sesion.dart';
import 'widgets/menu_lateral.dart';

/// Login y registro quedan fuera del ShellRoute. El guard impide entrar por URL o Atrás.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final acceso =
          state.uri.path == '/login' || state.uri.path == '/registro';
      if (!ServicioSesion().autenticada && !acceso) return '/login';
      return null;
    },
    routes: [
      GoRoute(
          path: '/login', builder: (context, state) => const PantallaLogin()),
      GoRoute(
          path: '/registro',
          builder: (context, state) => const PantallaRegistro()),
      ShellRoute(
        builder: (context, state, child) =>
            _EstructuraPrincipal(rutaActual: state.uri.path, child: child),
        routes: [
          GoRoute(
              path: '/',
              builder: (context, state) => PantallaInicio(
                  onVerInstalaciones: () => context.go('/instalaciones'))),
          GoRoute(
              path: '/portfolio',
              builder: (context, state) => const PantallaPortfolio()),
          GoRoute(
              path: '/instalaciones',
              builder: (context, state) => const PantallaInstalaciones()),
          GoRoute(
              path: '/ajustes',
              builder: (context, state) => const PantallaAjustes()),
        ],
      ),
    ],
  );
}

class _EstructuraPrincipal extends StatefulWidget {
  const _EstructuraPrincipal({required this.rutaActual, required this.child});
  final String rutaActual;
  final Widget child;
  @override
  State<_EstructuraPrincipal> createState() => _EstructuraPrincipalState();
}

class _EstructuraPrincipalState extends State<_EstructuraPrincipal> {
  bool _cerrando = false;

  Future<void> _cerrarSesion() async {
    if (_cerrando) return;
    setState(() => _cerrando = true);
    try {
      await ServicioSesion().cerrarSesion();
      if (mounted) context.go('/login');
    } on ErrorApi catch (error) {
      if (mounted) {
        await mostrarAlertaSesion(
            context, 'No se ha podido cerrar sesión', error.mensaje);
      }
    } finally {
      if (mounted) setState(() => _cerrando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String titulo;
    switch (widget.rutaActual) {
      case '/portfolio':
        titulo = 'Portfolio de Joel';
        break;
      case '/instalaciones':
        titulo = 'Instalaciones';
        break;
      case '/ajustes':
        titulo = 'Ajustes';
        break;
      default:
        titulo = 'Cancha Canaria';
    }
    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      drawer: MenuLateral(
          rutaActual: widget.rutaActual,
          onSeleccionar: (ruta) => context.go(ruta),
          onCerrarSesion: _cerrando ? null : _cerrarSesion),
      body: widget.child,
    );
  }
}
