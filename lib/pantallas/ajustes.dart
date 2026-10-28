import 'package:flutter/material.dart';

/// La persistencia de preferencias se desarrollará en otra tarea.
class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, size: 54),
            SizedBox(height: 14),
            Text('Ajustes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Las preferencias se implementarán en una tarea posterior.',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
