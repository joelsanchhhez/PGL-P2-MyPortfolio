import 'package:flutter/material.dart';

import '../tema.dart';

/// Los datos se mantienen en widgets reutilizables, como en la práctica 1.
class Actividades extends StatelessWidget {
  const Actividades({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TarjetaActividad(
          icono: Icons.fastfood,
          titulo: 'Mi trabajo',
          descripcion: "Trabajo en McDonald's.",
        ),
        TarjetaActividad(
          icono: Icons.computer,
          titulo: 'Desarrollo web',
          descripcion: 'Me gusta crear y desarrollar páginas web.',
        ),
        TarjetaActividad(
          icono: Icons.sports_soccer,
          titulo: 'Fútbol sala',
          descripcion: 'Soy árbitro federado de fútbol sala.',
        ),
        TarjetaActividad(
          icono: Icons.sports,
          titulo: 'Fútbol 7',
          descripcion: 'También soy árbitro aficionado de fútbol 7.',
        ),
      ],
    );
  }
}

class TarjetaActividad extends StatelessWidget {
  const TarjetaActividad({
    super.key,
    required this.icono,
    required this.titulo,
    required this.descripcion,
  });

  final IconData icono;
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFFF5F5FA),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: Icon(icono, color: ColoresApp.primario, size: 28),
          title:
              Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(descripcion),
        ),
      ),
    );
  }
}
