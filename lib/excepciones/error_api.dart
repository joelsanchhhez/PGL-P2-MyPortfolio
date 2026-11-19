/// Excepción propia: el servicio comunica el error y la pantalla muestra la alerta.
class ErrorApi implements Exception {
  const ErrorApi(this.mensaje, {this.codigo});
  final String mensaje;
  final int? codigo;

  @override
  String toString() => mensaje;
}
