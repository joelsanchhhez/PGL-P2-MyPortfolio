import 'package:flutter/material.dart';

/// La implementación del CRUD pertenece a una tarea posterior.
class PantallaInstalaciones extends StatelessWidget {
  const PantallaInstalaciones({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_soccer, size: 54),
            SizedBox(height: 14),
            Text('Instalaciones', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('La gestión de instalaciones se añadirá en la siguiente tarea.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
