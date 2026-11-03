import 'package:flutter/material.dart';

import '../modelos/instalacion.dart';
import '../tema.dart';
import '../widgets/formulario_instalacion.dart';
import '../widgets/tarjeta_instalacion.dart';

/// Pantalla CRUD de la tarea 3. Se integra en el Drawer existente (go_router).
/// setState basta para una lista local; se reinicia cuando se cierra la app.
class PantallaInstalaciones extends StatefulWidget {
  const PantallaInstalaciones({super.key});

  @override
  State<PantallaInstalaciones> createState() => _PantallaInstalacionesState();
}

class _PantallaInstalacionesState extends State<PantallaInstalaciones> {
  // Dos ejemplos inspirados en el diseño de la práctica 1 (no datos reales).
  // static conserva los elementos al entrar y salir desde el Drawer.
  // Los datos desaparecen al cerrar la aplicación, como indica el diseño.
  static final List<Instalacion> _instalaciones = [
    const Instalacion(
      id: 1,
      nombre: 'Cancha del barrio',
      descripcion: 'Pista deportiva de uso vecinal.',
      categoria: CategoriaInstalacion.cancha,
      isla: 'Gran Canaria',
      municipio: 'Las Palmas de Gran Canaria',
    ),
    const Instalacion(
      id: 2,
      nombre: 'Pabellón del norte',
      descripcion: 'Pabellón cubierto para entrenamientos.',
      categoria: CategoriaInstalacion.pabellon,
      isla: 'Tenerife',
      municipio: 'La Laguna',
    ),
  ];
  static int _siguienteId = 3;

  Future<void> _abrirFormulario({Instalacion? existente}) async {
    final datos = await showDialog<DatosInstalacion>(
      context: context,
      builder: (context) => FormularioInstalacion(instalacion: existente),
    );
    if (!mounted || datos == null) return;

    setState(() {
      if (existente == null) {
        _instalaciones.add(Instalacion(
          id: _siguienteId++,
          nombre: datos.nombre,
          descripcion: datos.descripcion,
          categoria: datos.categoria,
          isla: datos.isla,
          municipio: datos.municipio,
        ));
      } else {
        final indice = _instalaciones.indexWhere((i) => i.id == existente.id);
        if (indice != -1) {
          _instalaciones[indice] = Instalacion(
            id: existente.id,
            nombre: datos.nombre,
            descripcion: datos.descripcion,
            categoria: datos.categoria,
            isla: datos.isla,
            municipio: datos.municipio,
          );
        }
      }
    });
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
      content: Text(existente == null
          ? 'Instalación añadida'
          : 'Instalación actualizada'),
    ));
  }

  Future<void> _confirmarEliminacion(Instalacion instalacion) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar instalación?'),
        content: Text(
            'Se eliminará «${instalacion.nombre}». Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar',
                style: TextStyle(color: ColoresApp.error)),
          ),
        ],
      ),
    );
    if (!mounted || confirmado != true) return;
    setState(() => _instalaciones.removeWhere((i) => i.id == instalacion.id));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, 80),
        content: Text('Instalación eliminada')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Tus instalaciones',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColoresApp.texto)),
                ),
                // El contador se actualiza automáticamente con setState.
                Chip(
                  avatar: const Icon(Icons.sports_soccer, size: 18),
                  label: Text('Total: ${_instalaciones.length}'),
                  backgroundColor: ColoresApp.secundario,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _instalaciones.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.sports_soccer_outlined,
                              size: 54, color: ColoresApp.primario),
                          SizedBox(height: 10),
                          Text('Aún no hay instalaciones'),
                          SizedBox(height: 4),
                          Text('Pulsa «Añadir instalación» para empezar.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _instalaciones.length,
                      itemBuilder: (context, indice) {
                        final instalacion = _instalaciones[indice];
                        return TarjetaInstalacion(
                          key: ValueKey(instalacion.id),
                          instalacion: instalacion,
                          alEditar: () =>
                              _abrirFormulario(existente: instalacion),
                          alEliminar: () => _confirmarEliminacion(instalacion),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => _abrirFormulario(),
              icon: const Icon(Icons.add),
              label: const Text('Añadir instalación'),
            ),
          ],
        ),
      ),
    );
  }
}
