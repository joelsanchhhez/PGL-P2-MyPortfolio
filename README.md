# Cancha Canaria — PGL-P2-MyPortfolio

**UD2 / Práctica 2 · Tarea 1: Navegación**

Joel Sánchez Siliuto · 2.º DAM · Salesianos La Cuesta

## Qué hace la aplicación

Cancha Canaria muestra una bienvenida y permite acceder desde un Drawer al
portfolio de Joel, a Instalaciones y a Ajustes. El portfolio tiene las pestañas
Sobre mí y Mis proyectos, con fotografía, actividades y QR del perfil de GitHub.
Instalaciones y Ajustes son pantallas informativas: el CRUD y las preferencias
se desarrollarán en tareas posteriores.

## Navegación siguiendo los apuntes

Se utiliza `Navigator` con rutas nombradas, siguiendo el ejemplo de las páginas
6 y 7 de los apuntes UD2.1. `AppRouter` contiene un `Scaffold` con un `AppBar`
y un `Drawer` comunes. Dentro del cuerpo hay un `Navigator` cuya
`GlobalKey<NavigatorState>` permite cambiar la pantalla desde el menú.

1. El usuario pulsa una opción del Drawer.
2. `Navigator.pop(context)` cierra el menú.
3. Un callback comunica la ruta a `AppRouter`.
4. `setState` actualiza el título y la selección del menú.
5. `pushReplacementNamed` sustituye la pantalla del cuerpo sin acumular destinos.

`onGenerateRoute` utiliza un `switch` clásico con `case` para devolver la pantalla
correspondiente mediante `MaterialPageRoute`.

| Ruta | Pantalla |
| --- | --- |
| `/` | Bienvenida |
| `/portfolio` | Portfolio con dos pestañas |
| `/instalaciones` | Aviso de próxima tarea |
| `/ajustes` | Aviso de próxima tarea |

El ZIP inicial utilizaba `go_router`. Esta versión lo sustituye por el ejemplo
de rutas nombradas de clase. Ya no utiliza `ShellRoute`, `CustomPainter` ni
clases `abstract final`.

## Portfolio y diseño

Las pestañas usan `DefaultTabController`, `TabBar` y `TabBarView`. Son widgets
estándar para implementar las dos secciones del diseño, aunque su implementación
no se desarrolla en los apuntes aportados. Las tarjetas, la presentación y los
proyectos se separan en widgets pequeños y comentados.

Se conservan los colores: primario `#14345D`, secundario `#9AD9F5`, fondo
`#F4F7FA` y texto `#172B42`. La fotografía está en `assets/images/joel.jpg`.
La cancha del código inicial se ha exportado como `assets/images/cancha.png`:
la bienvenida utiliza `Image.asset`, sin código para dibujar con un lienzo.

`qr_flutter` y `url_launcher` conservan el QR y el enlace del portfolio inicial.

## Ejecutar y compilar

```bash
flutter pub get
flutter run
```

Para ejecutar en navegador:

```bash
flutter run -d chrome
```

Para analizar y compilar:

```bash
flutter analyze
flutter build apk --debug
flutter build web
```

El APK se genera en `build/app/outputs/flutter-apk/app-debug.apk`.
El identificador Dart es `pgl_p2_myportfolio`, porque el nombre del paquete
no admite mayúsculas ni guiones.

## Estructura

```text
lib/
  main.dart                  # MaterialApp, tema y AppRouter
  app_router.dart            # Scaffold común y Navigator con rutas nombradas
  tema.dart                  # Colores y tema
  pantallas/
    inicio.dart              # Imagen y bienvenida
    portfolio.dart           # Sobre mí y Mis proyectos
    instalaciones.dart       # Reservada para otra tarea
    ajustes.dart             # Reservada para otra tarea
  widgets/
    menu_lateral.dart        # Opciones del Drawer y callback
    presentacion.dart        # Fotografía y presentación
    actividades.dart         # Tarjetas de actividades
    proyectos.dart           # QR y enlace a GitHub
assets/images/
  joel.jpg
  cancha.png
```

## Comprobación manual

- Abrir el Drawer y comprobar las cuatro opciones y la selección activa.
- Entrar en cada destino y comprobar el título y el cierre del menú.
- Pulsar otra vez el destino activo y comprobar que el Drawer se cierra.
- Volver a Inicio y pulsar Ver instalaciones.
- Abrir el portfolio y alternar Sobre mí y Mis proyectos, también deslizando.
- Comprobar la fotografía, las actividades, el QR y el enlace de GitHub.

La navegación simplificada también se ha comprobado con una prueba de widgets
utilizada durante la revisión. Ese código auxiliar no forma parte de la entrega.

## Capturas reales

Capturas de la versión simplificada ejecutada en Android Pixel 9.
Resolución del emulador: 540 × 1212, densidad 210.

![Bienvenida](docs/capturas/inicio.png)
![Drawer](docs/capturas/drawer.png)
![Sobre mí](docs/capturas/portfolio_sobre_mi.png)
![Mis proyectos](docs/capturas/portfolio_proyectos.png)

## Repositorio y entrega

[Repositorio público](https://github.com/joelsanchhhez/PGL-P2-MyPortfolio)

[Rama P2-Tarea1-Navegación](https://github.com/joelsanchhhez/PGL-P2-MyPortfolio/tree/P2-Tarea1-Navegaci%C3%B3n)

La rama de esta tarea conserva el nombre solicitado para entregar.
Las actualizaciones usan mensajes con prefijos Karma (`refactor:`, `docs:`, etc.).
Para cerrar la tarea se integra su rama en `develop` y después `develop` en `main`,
siguiendo el orden indicado en los apuntes. Los commits anteriores se conservan
como historial del trabajo inicial.

```bash
git clone --branch 'P2-Tarea1-Navegación' https://github.com/joelsanchhhez/PGL-P2-MyPortfolio.git
cd PGL-P2-MyPortfolio
flutter pub get
flutter run
```
