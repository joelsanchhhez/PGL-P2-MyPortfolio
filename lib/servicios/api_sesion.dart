import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Conserva el mensaje de la API y el estado HTTP para decidir qué hacer en UI.
class ErrorSesion implements Exception {
  const ErrorSesion(this.mensaje, {this.codigo});
  final String mensaje;
  final int? codigo;
  bool get tokenRechazado => codigo == 401 || codigo == 403;
}

class ResultadoLogin {
  const ResultadoLogin(this.mensaje, this.token, this.nombre);
  final String mensaje;
  final String token;
  final String? nombre;
}

/// Único lugar que conoce las rutas HTTP, el JSON y la cabecera Bearer.
class ApiSesion {
  ApiSesion(
      {http.Client? cliente,
      String? baseUrl,
      this.tiempoEspera = const Duration(seconds: 90)})
      : _cliente = cliente ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment('API_BASE_URL',
                defaultValue: 'https://my-users-api.onrender.com');

  final http.Client _cliente;
  final String _baseUrl;
  final Duration tiempoEspera;

  Future<Map<String, dynamic>> _peticion(String ruta,
      {Map<String, String>? datos, String? token}) async {
    final uri =
        Uri.parse('${_baseUrl.replaceFirst(RegExp(r'/$'), '')}/users/$ruta');
    final cabeceras = <String, String>{
      'Accept': 'application/json',
      if (datos != null) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    try {
      final respuesta = await (datos == null
              ? _cliente.get(uri, headers: cabeceras)
              : _cliente.post(uri, headers: cabeceras, body: jsonEncode(datos)))
          .timeout(tiempoEspera);
      Map<String, dynamic>? json;
      try {
        final valor = jsonDecode(utf8.decode(respuesta.bodyBytes));
        if (valor is Map<String, dynamic>) json = valor;
      } on FormatException {
        // Un proxy puede devolver HTML; nunca mostramos ese HTML al usuario.
      }
      if (respuesta.statusCode < 200 || respuesta.statusCode >= 300) {
        throw ErrorSesion(
            json?['message'] is String
                ? json!['message'] as String
                : 'El servidor no está disponible (HTTP ${respuesta.statusCode}). Inténtalo de nuevo.',
            codigo: respuesta.statusCode);
      }
      if (json == null || json['message'] is! String) {
        throw const ErrorSesion('La API ha enviado una respuesta no válida.');
      }
      return json;
    } on TimeoutException {
      throw const ErrorSesion(
          'La API ha tardado demasiado. Render puede estar despertando; espera un momento e inténtalo de nuevo.');
    } on http.ClientException {
      throw const ErrorSesion(
          'No se ha podido conectar con la API. Comprueba tu conexión e inténtalo de nuevo.');
    }
  }

  Future<String> registrar(
      String nombre, String email, String contrasena) async {
    final json = await _peticion('register', datos: {
      'fullName': nombre.trim(),
      'email': email.trim(),
      'pwd': contrasena,
    });
    return json['message'] as String;
  }

  Future<ResultadoLogin> login(String email, String contrasena) async {
    final json = await _peticion('login', datos: {
      'email': email.trim(),
      'pwd': contrasena,
    });
    final token = json['token'];
    if (token is! String || token.trim().isEmpty) {
      throw const ErrorSesion(
          'La API no ha enviado un token de sesión válido.');
    }
    final usuario = json['user'];
    final nombre =
        usuario is Map ? usuario['fullName'] ?? usuario['name'] : null;
    return ResultadoLogin(
        json['message'] as String, token, nombre is String ? nombre : null);
  }

  Future<String> comprobarToken(String token) async =>
      (await _peticion('check-token', token: token))['message'] as String;

  Future<String> bienvenida(String token) async =>
      (await _peticion('welcome', token: token))['message'] as String;

  void cerrar() => _cliente.close();
}
