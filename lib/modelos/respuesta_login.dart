import '../excepciones/error_api.dart';

/// Convierte la respuesta JSON en un objeto Dart, como el modelo de los apuntes.
class RespuestaLogin {
  const RespuestaLogin({required this.mensaje, required this.token});
  final String mensaje;
  final String token;

  factory RespuestaLogin.fromJson(Map<String, dynamic> json) {
    final token = json['token'];
    if (token is! String || token.trim().isEmpty) {
      throw const ErrorApi('La API no ha enviado un token válido.');
    }
    return RespuestaLogin(mensaje: json['message'] as String, token: token);
  }
}
