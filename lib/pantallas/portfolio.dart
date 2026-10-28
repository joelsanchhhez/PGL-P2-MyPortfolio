import 'package:flutter/material.dart';

import '../tema.dart';
import '../widgets/actividades.dart';
import '../widgets/presentacion.dart';
import '../widgets/proyectos.dart';

/// Dos pestañas dentro del portfolio, tal y como aparece en el diseño.
class PantallaPortfolio extends StatelessWidget {
  const PantallaPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: ColoresApp.fondo,
            child: TabBar(
              labelColor: ColoresApp.primario,
              unselectedLabelColor: ColoresApp.texto,
              indicatorColor: ColoresApp.primario,
              tabs: [Tab(text: 'Sobre mí'), Tab(text: 'Mis proyectos')],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _ContenidoSobreMi(),
                _ContenidoProyectos(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContenidoSobreMi extends StatelessWidget {
  const _ContenidoSobreMi();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Presentacion(),
        Padding(
          padding: EdgeInsets.fromLTRB(18, 20, 18, 4),
          child: Text(
            'Mis actividades',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Actividades(),
        ),
      ],
    );
  }
}

class _ContenidoProyectos extends StatelessWidget {
  const _ContenidoProyectos();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Presentacion(),
        Padding(
          padding: EdgeInsets.fromLTRB(22, 22, 22, 28),
          child: Proyectos(),
        ),
      ],
    );
  }
}
