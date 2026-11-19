# Cancha Canaria — P2 · Tarea 5: Sesión de usuario

Joel Sánchez Siliuto · 2.º DAM · Programación Multimedia y Dispositivos Móviles.

Aplicación Flutter de instalaciones deportivas de Canarias. Esta tarea añade
registro, inicio de sesión y gestión de un JWT sobre la Tarea 3, conservando
la bienvenida, el portfolio, el Drawer, las rutas con `go_router` y el CRUD de
instalaciones, incluido «Borrar todos».

**[Rama de entrega: P2-Tarea5-SesionUsuario](https://github.com/joelsanchhhez/PGL-P2-MyPortfolio/tree/P2-Tarea5-SesionUsuario)**

## Registro e inicio de sesión

- Registro con nombre completo, email y contraseña.
- Validación de nombre (3 a 100 caracteres), formato de email y contraseña de
  registro (8 a 64 caracteres, mayúscula, minúscula, número y símbolo).
- En login se valida email y contraseña no vacía, sin imponer reglas nuevas
  que pudieran impedir acceder a cuentas anteriores.
- Contraseña oculta, con un botón accesible para mostrarla.
- Toda respuesta de registro o login se muestra en un `AlertDialog`, tanto
  si la API acepta la petición como si devuelve un error.
- Un registro correcto vuelve a login al aceptar la alerta.
- Un login correcto guarda primero el JWT y muestra la respuesta; al aceptar
  la alerta se abre Bienvenida.
- Los botones se bloquean mientras hay una petición para evitar envíos dobles.
- Los errores de conexión, timeout o respuestas no válidas también se explican
  en alertas, sin mostrar HTML del servidor ni datos técnicos sensibles.

## Sesión y navegación protegida

Al arrancar solo se construye el login, fuera del `ShellRoute`: no aparece
el Drawer ni se puede acceder al portfolio o a Instalaciones.

1. Se busca el token con `flutter_secure_storage`.
2. Si no existe, se permanece en login.
3. Si existe, se consulta `GET /users/check-token`.
4. Si la API lo acepta, se abre automáticamente Bienvenida.
5. Si lo rechaza (401/403), se elimina del dispositivo y se permanece en login.
6. Si hay un problema de red o del servidor, no se permite entrar y se conserva
   el token guardado para poder usar «Reintentar sesión guardada».

El guard de `go_router` protege también los accesos por ruta y el regreso a
pantallas privadas después de cerrar sesión.

El Drawer contiene **Cerrar sesión**: elimina el JWT del almacenamiento seguro,
limpia la sesión en memoria y vuelve a login. Si el borrado falla, muestra una
alerta para poder reintentarlo.

Bienvenida incluye **Mensaje de bienvenida**, que consulta el endpoint protegido
`GET /users/welcome` y muestra su `message` en una alerta. Si la API rechaza el
token o ya no encuentra al usuario, se cierra la sesión tras aceptar el aviso.

## Almacenamiento seguro

Se guarda únicamente el JWT con `flutter_secure_storage`; nunca la contraseña.
En Android, el plugin cifra los datos y protege las claves con Android Keystore.
Se desactiva la copia de seguridad automática de Android para que el token
cifrado no se restaure sin sus claves. El manifiesto declara `INTERNET` también
para las compilaciones de distribución.

Esta implementación está orientada a Android móvil. La API utiliza una cabecera
`Authorization: Bearer <token>`; el cliente móvil la añade desde el servicio.
No se confía en decodificar el JWT localmente ni en guardar el token como texto
plano en preferencias. Las cookies de navegador son un mecanismo distinto del
almacenamiento seguro del dispositivo que pide esta tarea.

## API del profesor

- [Servicio desplegado](https://my-users-api.onrender.com)
- [Código de la API](https://github.com/adhernea/my-users-api)
- [Documentación de endpoints](https://github.com/adhernea/my-users-api/blob/main/docs/endpoints_api.md)
- [Contrato local de las rutas utilizadas](docs/api_sesion.openapi.json)

| Método | Ruta | Datos o autenticación |
| --- | --- | --- |
| POST | `/users/register` | JSON con `fullName`, `email`, `pwd` |
| POST | `/users/login` | JSON con `email`, `pwd`; devuelve `token` |
| GET | `/users/check-token` | Cabecera Bearer con el JWT |
| GET | `/users/welcome` | Cabecera Bearer con el JWT |

`ApiSesion` encapsula todas las peticiones HTTP y conserva los mensajes de la
API. Contempla códigos de error como 400, 401, 404, 409 y 5xx, sin asumir que
todos los fallos de login tienen el mismo código.

Render puede necesitar unos 50–60 segundos para despertar. Cada petición tiene
un límite de 90 segundos y un indicador de espera. No se reintenta un registro
automáticamente, porque un timeout no demuestra que el servidor no lo guardara.
Si se pierde la respuesta, se puede intentar iniciar sesión con esa cuenta.

La disponibilidad y persistencia de usuarios dependen del servidor del profesor.
Su SQLite puede perderse cuando Render reinicie o sustituya su contenedor; un
usuario anterior podría tener que registrarse de nuevo. El código del servidor
emite tokens con una duración de una hora.

## Capturas reales de la aplicación funcionando

Obtenidas en Android Pixel 9 ejecutando el flujo contra la API real de Render,
con un usuario ficticio de demostración. La contraseña permanece oculta y no
se muestran JWT en las capturas. Las respuestas de las alertas proceden de la API.

### Registro exitoso

![Registro exitoso](docs/capturas/tarea5_registro_exitoso.png)

### Login fallido

![Login fallido](docs/capturas/tarea5_login_fallido.png)

### Login exitoso

![Login exitoso](docs/capturas/tarea5_login_exitoso.png)

### Mensaje del endpoint de bienvenida

![Mensaje de bienvenida de la API](docs/capturas/tarea5_bienvenida_api.png)

## Ejecutar

```bash
git clone --branch P2-Tarea5-SesionUsuario https://github.com/joelsanchhhez/PGL-P2-MyPortfolio.git
cd PGL-P2-MyPortfolio
flutter pub get
flutter run
```

El identificador Dart es `pgl_p2_myportfolio`. Los directorios Android y web ya
forman parte del repositorio; no es necesario regenerarlos con `flutter create`.

## Comprobaciones

```bash
flutter analyze
flutter test
```

Verificado el **19 de noviembre de 2026**:

- `flutter analyze`: sin incidencias.
- `flutter test`: 13 pruebas superadas, incluidas las del CRUD anterior.
- Prueba de integración Android contra Render: flujo completo superado,
  incluido guardado/lectura/borrado del token mediante el plugin nativo.
- Servicio HTTP contra simulación local: registro/login/Bearer, token inválido,
  503 y timeout superados.

Las pruebas cubren serialización JSON, cabecera Bearer, validaciones, errores
HTTP/HTML y timeout; guardado, restauración y eliminación del token; protección
de rutas, alertas y flujo de sesión. Se mantienen las pruebas del Drawer,
portfolio y CRUD de Instalaciones de la tarea anterior.

También se incluye una prueba real de integración para Android que registra
un usuario ficticio, comprueba ambos resultados de login, obtiene la bienvenida,
recrea la app para comprobar la restauración y verifica el cierre de sesión.
Genera las cuatro capturas anteriores mediante `integration_test`.

Para repetirla, crea fuera del repositorio un archivo JSON de parámetros con
una clave `DEMO_PASSWORD` y una contraseña de prueba que cumpla las reglas.
No uses tu contraseña personal ni subas ese archivo a GitHub. Después:

```bash
flutter drive -d emulator-5554 \
  --driver=test_driver/capturas.dart \
  --target=integration_test/sesion_real_test.dart \
  --dart-define-from-file=/ruta/externa/parametros-prueba.json
```

La prueba elimina el token de esta app en el emulador y crea una cuenta ficticia
nueva en la API en cada ejecución. No se necesita una cuenta personal para probarla.

Para comprobar respuestas HTTP controladas sin modificar la API real:

```bash
# Terminal 1: simulación local (requiere Postman CLI con simulation).
postman simulation run postman/simulations/sesion.sim.yaml --port 4505 --no-history

# Terminal 2: ejecuta el servicio real de la app contra esa simulación.
dart run tool/probar_api_simulada.dart
```

La simulación verifica el cliente frente al contrato modelado y escenarios
503/timeout; no demuestra firmas JWT ni persistencia de la API del profesor.
La prueba Android usa el backend real y el almacenamiento seguro nativo.

## Estructura

```text
lib/
  main.dart                         # Inicializa controlador y router
  app_router.dart                   # Guard de sesión y ShellRoute privado
  tema.dart                         # Diseño de Cancha Canaria
  pantallas/
    sesion.dart                     # Login y registro reutilizan el formulario
    inicio.dart                     # Bienvenida y botón de la API
    portfolio.dart                  # Pestañas del portfolio
    instalaciones.dart              # CRUD de Tarea 3
    ajustes.dart                    # Destino reservado
  servicios/
    api_sesion.dart                 # HTTP, JSON, Bearer y errores
    almacen_token.dart              # Almacenamiento seguro del JWT
  sesion/
    controlador_sesion.dart         # Restaurar, entrar y cerrar sesión
  utilidades/
    validaciones_sesion.dart        # Validaciones de los formularios
  widgets/
    alerta_sesion.dart              # AlertDialog reutilizado
    menu_lateral.dart               # Drawer con cierre de sesión
    ...                             # Widgets del portfolio y del CRUD
integration_test/sesion_real_test.dart
test_driver/capturas.dart
```

Los comentarios explican las funciones y decisiones importantes, sin comentar
cada línea. Se conserva la paleta de la práctica 1: `#14345D`, `#9AD9F5`,
`#F4F7FA` y `#172B42`, además de las imágenes y el portfolio anteriores.
