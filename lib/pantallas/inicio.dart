import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../tema.dart';
import '../widgets/cancha_fondo.dart';

/// Bienvenida: mensaje sobre la cancha y enlace directo a instalaciones.
class PantallaInicio extends StatelessWidget {
  const PantallaInicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(child: CanchaFondo()),
        Positioned(
          left: 18,
          right: 18,
          top: 16,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColoresApp.primario,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tu próxima cancha, en Canarias.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 14),
                Text('¡Bienvenido, Joel!',
                    style:
                        TextStyle(fontSize: 16, color: ColoresApp.secundario)),
              ],
            ),
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          bottom: 24,
          child: SafeArea(
            top: false,
            child: FilledButton.icon(
              onPressed: () => context.go('/instalaciones'),
              icon: const Icon(Icons.sports_soccer),
              label: const Text('Ver instalaciones'),
            ),
          ),
        ),
      ],
    );
  }
}
