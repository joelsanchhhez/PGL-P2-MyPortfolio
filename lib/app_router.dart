import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pantallas/ajustes.dart';
import 'pantallas/inicio.dart';
import 'pantallas/instalaciones.dart';
import 'pantallas/portfolio.dart';
import 'pantallas/sesion.dart';
import 'servicios/api_sesion.dart';
import 'sesion/controlador_sesion.dart';
import 'widgets/alerta_sesion.dart';
import 'widgets/menu_lateral.dart';

/// Login y registro quedan fuera del ShellRoute. El guard impide entrar por URL o Atrás.
abstract final class AppRouter {
  static GoRouter crear(ControladorSesion sesion) => GoRouter(
        initialLocation: '/login',
        refreshListenable: sesion,
        redirect: (context, state) {
          final acceso =
              state.uri.path == '/login' || state.uri.path == '/registro';
          if (sesion.comprobando) {
            return state.uri.path == '/login' ? null : '/login';
          }
          if (!sesion.autenticada) return acceso ? null : '/login';
          return acceso ? '/' : null;
        },
        routes: [
          GoRoute(
              path: '/login',
              builder: (context, state) =>
                  PantallaSesion(key: const ValueKey('login'), sesion: sesion)),
          GoRoute(
              path: '/registro',
              builder: (context, state) => PantallaSesion(
                  key: const ValueKey('registro'),
                  sesion: sesion,
                  registro: true)),
          ShellRoute(
            builder: (context, state, child) => _EstructuraPrincipal(
                rutaActual: state.uri.path, sesion: sesion, child: child),
            routes: [
              GoRoute(
                  path: '/',
                  builder: (context, state) => PantallaInicio(
                      sesion: sesion,
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
  const _EstructuraPrincipal(
      {required this.rutaActual, required this.sesion, required this.child});
  final String rutaActual;
  final ControladorSesion sesion;
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
      await widget.sesion.cerrarSesion();
    } on ErrorSesion catch (error) {
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
    final titulo = switch (widget.rutaActual) {
      '/portfolio' => 'Portfolio de Joel',
      '/instalaciones' => 'Instalaciones',
      '/ajustes' => 'Ajustes',
      _ => 'Cancha Canaria',
    };
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
