import 'package:flutter/material.dart';

import '../modelos/instalacion.dart';

/// Formulario en un Dialog. Devuelve los datos sin modificar directamente la lista.
class FormularioInstalacion extends StatefulWidget {
  const FormularioInstalacion({super.key, this.instalacion});

  final Instalacion? instalacion;

  @override
  State<FormularioInstalacion> createState() => _FormularioInstalacionState();
}

class _FormularioInstalacionState extends State<FormularioInstalacion> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre;
  late final TextEditingController _descripcion;
  late final TextEditingController _municipio;
  CategoriaInstalacion? _categoria;
  String? _isla;

  static const _islas = [
    'El Hierro',
    'La Palma',
    'La Gomera',
    'Tenerife',
    'Gran Canaria',
    'Fuerteventura',
    'Lanzarote',
    'La Graciosa',
  ];

  @override
  void initState() {
    super.initState();
    _nombre = TextEditingController(text: widget.instalacion?.nombre ?? '');
    _descripcion =
        TextEditingController(text: widget.instalacion?.descripcion ?? '');
    _municipio =
        TextEditingController(text: widget.instalacion?.municipio ?? '');
    _categoria = widget.instalacion?.categoria;
    final valorIsla = widget.instalacion?.isla ?? '';
    _isla = _islas.contains(valorIsla) ? valorIsla : null;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    _municipio.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      DatosInstalacion(
        nombre: _nombre.text.trim(),
        descripcion: _descripcion.text.trim(),
        categoria: _categoria!,
        isla: _isla ?? '',
        municipio: _municipio.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.instalacion != null;
    return AlertDialog(
      title: Text(editando ? 'Editar instalación' : 'Añadir instalación'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombre,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) => valor == null || valor.trim().isEmpty
                    ? 'Introduce el nombre'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descripcion,
                maxLines: 2,
                maxLength: 120,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción breve *',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) => valor == null || valor.trim().isEmpty
                    ? 'Introduce una descripción'
                    : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<CategoriaInstalacion>(
                initialValue: _categoria,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Categoría *',
                  border: OutlineInputBorder(),
                ),
                items: CategoriaInstalacion.values
                    .map((categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria.nombre),
                        ))
                    .toList(),
                onChanged: (categoria) =>
                    setState(() => _categoria = categoria),
                validator: (categoria) =>
                    categoria == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _isla,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Isla (opcional)',
                  border: OutlineInputBorder(),
                ),
                items: _islas
                    .map((isla) =>
                        DropdownMenuItem(value: isla, child: Text(isla)))
                    .toList(),
                onChanged: (isla) => setState(() => _isla = isla),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _municipio,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Municipio (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('* Campos obligatorios'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _guardar,
          icon: const Icon(Icons.save),
          label: Text(editando ? 'Actualizar' : 'Guardar'),
        ),
      ],
    );
  }
}
