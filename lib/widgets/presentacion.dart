import 'package:flutter/material.dart';

import '../tema.dart';

/// Cabecera personal mostrada en las dos pestañas del portfolio.
class Presentacion extends StatelessWidget {
  const Presentacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: ColoresApp.secundario,
      child: const Row(
        children: [
          CircleAvatar(
            radius: 39,
            backgroundColor: ColoresApp.primario,
            child: Icon(Icons.person, color: Colors.white, size: 46),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Hola! Soy Joel',
                  style: TextStyle(
                    fontSize: 19,
                    color: ColoresApp.texto,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  "Trabajo en McDonald's, desarrollo páginas web y soy árbitro "
                  'federado de fútbol sala y árbitro aficionado de fútbol 7.',
                  style: TextStyle(color: ColoresApp.texto, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
