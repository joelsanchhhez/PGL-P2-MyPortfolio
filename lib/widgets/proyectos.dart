import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../tema.dart';

/// Se reutiliza la URL que aparece en el portfolio de la práctica 1.
class Proyectos extends StatelessWidget {
  const Proyectos({super.key});

  static final Uri github = Uri.parse('https://github.com/joelsanchhhez');

  Future<void> _abrirGitHub(BuildContext context) async {
    final abierto = await launchUrl(github, mode: LaunchMode.externalApplication);
    if (!abierto && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha podido abrir el perfil de GitHub.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Mis proyectos web',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        const Text(
          'Me gusta desarrollar páginas web y seguir aprendiendo programación. '
          'En mi GitHub puedes encontrar algunos de mis proyectos.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 26),
        const Text('Mi GitHub', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8),
          child: QrImageView(
            data: github.toString(),
            version: QrVersions.auto,
            size: 160,
            backgroundColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Escanea el código QR para visitar mi perfil de GitHub y ver mis proyectos.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => _abrirGitHub(context),
          child: const Text(
            'github.com/joelsanchhhez',
            style: TextStyle(color: ColoresApp.primario, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
