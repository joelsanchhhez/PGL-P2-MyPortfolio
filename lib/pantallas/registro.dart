import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../excepciones/error_api.dart';
import '../servicios/api_sesion.dart';
import '../utilidades/validaciones_sesion.dart';
import '../widgets/alerta_sesion.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});
  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _formulario = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _email = TextEditingController();
  final _contrasena = TextEditingController();
  final _api = ApiSesion();
  bool _enviando = false;

  /// La pantalla gestiona formulario y alerta; el servicio gestiona HTTP y errores.
  Future<void> _registrar() async {
    if (_enviando || !_formulario.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _enviando = true);
    String mensaje;
    bool correcto = false;
    try {
      mensaje =
          await _api.registrar(_nombre.text, _email.text, _contrasena.text);
      correcto = true;
    } on ErrorApi catch (e) {
      mensaje = e.mensaje;
    }
    if (!mounted) return;
    setState(() => _enviando = false);
    await mostrarAlertaSesion(
        context, correcto ? 'Registro exitoso' : 'Registro fallido', mensaje);
    if (mounted && correcto) context.go('/login');
  }

  @override
  void dispose() {
    _nombre.dispose();
    _email.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Crear cuenta'),
            automaticallyImplyLeading: false),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formulario,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        key: const ValueKey('nombre'),
                        controller: _nombre,
                        enabled: !_enviando,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: 'Nombre completo',
                            border: OutlineInputBorder()),
                        validator: ValidacionesSesion.nombre,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        key: const ValueKey('email'),
                        controller: _email,
                        enabled: !_enviando,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            labelText: 'Email', border: OutlineInputBorder()),
                        validator: ValidacionesSesion.email,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        key: const ValueKey('contrasena'),
                        controller: _contrasena,
                        enabled: !_enviando,
                        obscureText: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            border: OutlineInputBorder(),
                            errorMaxLines: 3),
                        validator: ValidacionesSesion.contrasenaRegistro,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                          '8 a 64 caracteres: mayúscula, minúscula, número y símbolo.',
                          style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 24),
                      if (_enviando) ...[
                        const Center(child: CircularProgressIndicator()),
                        const SizedBox(height: 12),
                        const Text('Esperando respuesta de la API…',
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                      ],
                      FilledButton(
                        key: const ValueKey('enviar-sesion'),
                        onPressed: _enviando ? null : _registrar,
                        child: const Text('Registrarme'),
                      ),
                      TextButton(
                        onPressed:
                            _enviando ? null : () => context.go('/login'),
                        child: const Text('Volver al login'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
