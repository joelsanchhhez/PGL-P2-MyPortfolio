import 'package:flutter/material.dart';

import 'pantallas/ajustes.dart';
import 'pantallas/inicio.dart';
import 'pantallas/instalaciones.dart';
import 'pantallas/portfolio.dart';
import 'widgets/menu_lateral.dart';

/// Estructura común siguiendo el ejemplo de navegación de los apuntes.
class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  // Esta clave permite cambiar la pantalla del cuerpo sin sustituir el menú.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  String _rutaActual = '/';

  void _navegar(String ruta) {
    if (ruta == _rutaActual) return;
    setState(() {
      _rutaActual = ruta;
    });
    // Sustituimos la pantalla: los destinos principales no se apilan.
    _navigatorKey.currentState!.pushReplacementNamed(ruta);
  }

  MaterialPageRoute _cargarPantalla(RouteSettings settings) {
    Widget pantalla;
    switch (settings.name) {
      case '/portfolio':
        pantalla = const PantallaPortfolio();
        break;
      case '/instalaciones':
        pantalla = const PantallaInstalaciones();
        break;
      case '/ajustes':
        pantalla = const PantallaAjustes();
        break;
      default:
        pantalla = PantallaInicio(
          onVerInstalaciones: () => _navegar('/instalaciones'),
        );
    }
    return MaterialPageRoute(
      builder: (context) => pantalla,
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    String titulo;
    switch (_rutaActual) {
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
        rutaActual: _rutaActual,
        onSeleccionar: _navegar,
      ),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: '/',
        onGenerateRoute: _cargarPantalla,
      ),
    );
  }
}
