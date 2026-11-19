import 'package:flutter/material.dart';

import '../tema.dart';
import 'package:go_router/go_router.dart';
import '../servicios/servicio_sesion.dart';
import '../excepciones/error_api.dart';
import '../widgets/alerta_sesion.dart';

/// Bienvenida: mensaje sobre la cancha y enlace directo a instalaciones.
class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key, required this.onVerInstalaciones});

  // El AppRouter recibe la acción y decide qué pantalla mostrar.
  final VoidCallback onVerInstalaciones;

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  bool _consultando = false;

  /// El mensaje mostrado procede del endpoint protegido, no de un texto local.
  Future<void> _mostrarBienvenida() async {
    if (_consultando) return;
    setState(() => _consultando = true);
    try {
      final mensaje = await ServicioSesion().bienvenida();
      if (mounted) {
        await mostrarAlertaSesion(context, 'Bienvenida de la API', mensaje);
      }
    } on ErrorApi catch (error) {
      if (!mounted) return;
      await mostrarAlertaSesion(
          context, 'No se ha podido obtener la bienvenida', error.mensaje);
      if (mounted &&
          (error.codigo == 401 || error.codigo == 403 || error.codigo == 404)) {
        try {
          await ServicioSesion().cerrarSesion();
          if (mounted) context.go('/login');
        } on ErrorApi catch (errorGuardado) {
          if (mounted) {
            await mostrarAlertaSesion(context, 'No se ha podido cerrar sesión',
                errorGuardado.mensaje);
          }
        }
      }
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/cancha.png', fit: BoxFit.fill),
        ),
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
                Text('¡Bienvenido!',
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  key: const ValueKey('bienvenida-api'),
                  onPressed: _consultando ? null : _mostrarBienvenida,
                  icon: const Icon(Icons.waving_hand_outlined),
                  label: Text(
                      _consultando ? 'Consultando…' : 'Mensaje de bienvenida'),
                ),
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: widget.onVerInstalaciones,
                  icon: const Icon(Icons.sports_soccer),
                  label: const Text('Ver instalaciones'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
