import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tema.dart';

/// Menú lateral compartido. El elemento seleccionado refleja la URL actual.
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key, required this.rutaActual});

  final String rutaActual;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColoresApp.fondo,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const _CabeceraMenu(),
          _entrada(context, Icons.home, 'Inicio', '/'),
          _entrada(context, Icons.person, 'Portfolio de Joel', '/portfolio'),
          _entrada(
              context, Icons.sports_soccer, 'Instalaciones', '/instalaciones'),
          _entrada(context, Icons.settings, 'Ajustes', '/ajustes'),
        ],
      ),
    );
  }

  Widget _entrada(
      BuildContext context, IconData icono, String titulo, String ruta) {
    final activo = rutaActual == ruta;
    return ListTile(
      leading:
          Icon(icono, color: activo ? ColoresApp.primario : ColoresApp.texto),
      title: Text(
        titulo,
        style: TextStyle(
          color: ColoresApp.texto,
          fontWeight: activo ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: activo,
      selectedTileColor: const Color(0x5C9AD9F5),
      onTap: () {
        // Guardar la referencia antes de cerrar el Drawer evita usar
        // un BuildContext que haya dejado de estar montado.
        final router = GoRouter.of(context);
        Navigator.of(context).pop();
        if (!activo) router.go(ruta);
      },
    );
  }
}

class _CabeceraMenu extends StatelessWidget {
  const _CabeceraMenu();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 164),
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 18),
      decoration: const BoxDecoration(color: ColoresApp.primario),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.sports_soccer, color: Colors.white, size: 32),
          SizedBox(height: 10),
          Text(
            'Cancha Canaria',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text('Deporte en las islas',
              style: TextStyle(color: ColoresApp.secundario)),
        ],
      ),
    );
  }
}
