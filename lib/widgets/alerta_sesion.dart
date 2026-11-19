import 'package:flutter/material.dart';

Future<void> mostrarAlertaSesion(
        BuildContext context, String titulo, String mensaje) =>
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(child: Text(mensaje)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Aceptar'))
        ],
      ),
    );
