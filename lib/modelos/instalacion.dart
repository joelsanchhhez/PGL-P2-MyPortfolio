/// Tipos de instalación. Cada tipo determina la imagen que aparece en la lista.
enum CategoriaInstalacion { cancha, pabellon, campoFutbol }

extension CategoriaInstalacionDatos on CategoriaInstalacion {
  String get nombre => switch (this) {
        CategoriaInstalacion.cancha => 'Cancha',
        CategoriaInstalacion.pabellon => 'Pabellón',
        CategoriaInstalacion.campoFutbol => 'Campo de fútbol',
      };

  String get imagen => switch (this) {
        CategoriaInstalacion.cancha => 'assets/images/categoria_cancha.png',
        CategoriaInstalacion.pabellon => 'assets/images/categoria_pabellon.png',
        CategoriaInstalacion.campoFutbol => 'assets/images/categoria_campo.png',
      };
}

/// Los registros de esta práctica viven en memoria: no se usa base de datos.
class Instalacion {
  const Instalacion({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    this.isla = '',
    this.municipio = '',
  });

  final int id;
  final String nombre;
  final String descripcion;
  final CategoriaInstalacion categoria;
  final String isla;
  final String municipio;
}

/// Resultado sencillo que devuelve el diálogo al guardar o editar.
class DatosInstalacion {
  const DatosInstalacion({
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.isla,
    required this.municipio,
  });

  final String nombre;
  final String descripcion;
  final CategoriaInstalacion categoria;
  final String isla;
  final String municipio;
}
