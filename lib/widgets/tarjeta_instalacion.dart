import 'package:flutter/material.dart';

import '../modelos/instalacion.dart';
import '../tema.dart';

/// Tarjeta reutilizable: foto de la categoría, datos y acciones de CRUD.
class TarjetaInstalacion extends StatelessWidget {
  const TarjetaInstalacion({
    super.key,
    required this.instalacion,
    required this.alEditar,
    required this.alEliminar,
  });

  final Instalacion instalacion;
  final VoidCallback alEditar;
  final VoidCallback alEliminar;

  @override
  Widget build(BuildContext context) {
    final ubicacion = [instalacion.isla, instalacion.municipio]
        .where((parte) => parte.isNotEmpty)
        .join(' · ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                instalacion.categoria.imagen,
                width: 82,
                height: 90,
                fit: BoxFit.cover,
                semanticLabel:
                    'Imagen de categoría ${instalacion.categoria.nombre}',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instalacion.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColoresApp.texto,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(instalacion.categoria.nombre,
                      style: const TextStyle(color: ColoresApp.primario)),
                  const SizedBox(height: 3),
                  Text(instalacion.descripcion),
                  if (ubicacion.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(ubicacion,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Editar ${instalacion.nombre}',
                  onPressed: alEditar,
                  icon: const Icon(Icons.edit, color: ColoresApp.primario),
                ),
                IconButton(
                  tooltip: 'Eliminar ${instalacion.nombre}',
                  onPressed: alEliminar,
                  icon: const Icon(Icons.delete, color: ColoresApp.error),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
