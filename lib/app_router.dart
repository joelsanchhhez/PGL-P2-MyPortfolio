import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pantallas/ajustes.dart';
import 'pantallas/inicio.dart';
import 'pantallas/instalaciones.dart';
import 'pantallas/portfolio.dart';
import 'widgets/menu_lateral.dart';

/// ShellRoute comparte AppBar y Drawer sin copiarlos entre pantallas.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => _EstructuraPrincipal(
          rutaActual: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const PantallaInicio(),
          ),
          GoRoute(
            path: '/portfolio',
            builder: (context, state) => const PantallaPortfolio(),
          ),
          // Rutas reservadas para completar las próximas prácticas.
          GoRoute(
            path: '/instalaciones',
            builder: (context, state) => const PantallaInstalaciones(),
          ),
          GoRoute(
            path: '/ajustes',
            builder: (context, state) => const PantallaAjustes(),
          ),
        ],
      ),
    ],
  );
}

class _EstructuraPrincipal extends StatelessWidget {
  const _EstructuraPrincipal({
    required this.rutaActual,
    required this.child,
  });

  final String rutaActual;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final titulo = switch (rutaActual) {
      '/portfolio' => 'Portfolio de Joel',
      '/instalaciones' => 'Instalaciones',
      '/ajustes' => 'Ajustes',
      _ => 'Cancha Canaria',
    };

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      drawer: MenuLateral(rutaActual: rutaActual),
      body: child,
    );
  }
}
