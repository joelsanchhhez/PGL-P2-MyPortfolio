import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pgl_p2_myportfolio/servicios/almacen_token.dart';
import 'package:pgl_p2_myportfolio/servicios/api_sesion.dart';
import 'package:pgl_p2_myportfolio/sesion/controlador_sesion.dart';

class AlmacenMemoria implements AlmacenToken {
  AlmacenMemoria([this.token]);
  String? token;
  bool fallarGuardado = false;
  bool fallarBorrado = false;
  @override
  Future<String?> leer() async => token;
  @override
  Future<void> guardar(String valor) async {
    if (fallarGuardado) throw StateError('fallo simulado');
    token = valor;
  }

  @override
  Future<void> eliminar() async {
    if (fallarBorrado) throw StateError('fallo simulado');
    token = null;
  }
}

http.Response jsonRespuesta(Map<String, Object?> datos, [int estado = 200]) =>
    http.Response(jsonEncode(datos), estado,
        headers: {'content-type': 'application/json; charset=utf-8'});

ControladorSesion sesionPrueba() => ControladorSesion(
      almacen: AlmacenMemoria('token-de-prueba'),
      api: ApiSesion(
          cliente: MockClient(
              (_) async => jsonRespuesta({'message': 'Token válido.'}))),
    );
