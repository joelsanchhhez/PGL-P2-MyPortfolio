# Cancha Canaria — PGL-P2-MyPortfolio

**UD2 / Práctica 2 · Tarea 1: Navegación**  
Alumno: Joel Sánchez Siliuto · 2.º DAM · Salesianos La Cuesta

## Descripción

Aplicación Flutter de instalaciones deportivas de Canarias. Esta primera tarea
de implementación reproduce el diseño de la práctica 1 e incorpora la
**bienvenida**, la navegación lateral con **Drawer + go_router** y el
**portfolio de Joel** con pestañas. Las secciones Instalaciones y Ajustes se
muestran como futuras ampliaciones; no se ha implementado aún el CRUD ni las
preferencias persistentes.

## Implementado

- **Inicio** (`/`): ilustración de cancha, presentación y botón «Ver instalaciones».
- **Drawer**: cabecera azul, menú Inicio / Portfolio / Instalaciones / Ajustes,
  con opción activa destacada.
- **Portfolio** (`/portfolio`): `DefaultTabController` + `TabBar` + `TabBarView`;
  datos biográficos, tarjetas de actividades y QR de GitHub.
- **go_router**: rutas declaradas en `app_router.dart` con `ShellRoute` para
  conservar el mismo `Scaffold`, `AppBar` y `Drawer` en todas las pantallas.
- **Tema**: primario `#14345D`, secundario `#9AD9F5`, fondo `#F4F7FA`, texto
  `#172B42`.

## Preparación y ejecución

> La carpeta es un paquete de **código fuente** de Flutter. Los directorios
> nativos de Android/iOS/Web se generan en tu máquina porque aquí no se ha
> dispuesto del SDK de Flutter para ejecutar `flutter create`.

1. Instala Flutter y Android Studio (o prepara tu dispositivo/emulador).
2. Descomprime esta carpeta y abre una terminal dentro de ella.
3. Genera los directorios nativos, descarga las dependencias y ejecuta:

```bash
flutter create --project-name pgl_p2_myportfolio --platforms=android,ios,web .
flutter pub get
flutter run
```

> `PGL-P2-MyPortfolio` es el nombre del repositorio y la carpeta de entrega.
> `pgl_p2_myportfolio` es el identificador válido del paquete Dart: no puede
> llevar guiones ni mayúsculas.

### Comprobaciones

```bash
flutter analyze
flutter test
```

## Estructura

```text
lib/
  main.dart                    # MaterialApp.router
  tema.dart                    # Paleta de la práctica 1
  app_router.dart              # ShellRoute y destinos
  pantallas/
    inicio.dart                # Bienvenida
    portfolio.dart             # Pestañas
    instalaciones.dart         # Próxima tarea (marcador)
    ajustes.dart               # Próxima tarea (marcador)
  widgets/
    menu_lateral.dart          # Drawer reutilizable
    cancha_fondo.dart          # Ilustración de cancha
    presentacion.dart          # Presentación de Joel
    actividades.dart           # Tarjetas de actividades
    proyectos.dart             # QR y enlace al GitHub
```

## Capturas de pantalla

**Pendiente de aportar capturas reales del emulador.** No se incluyen capturas
inventadas ni imágenes del PDF presentadas como una app en ejecución.
Después de ejecutar la app, guarda las capturas con estos nombres en
`docs/capturas/` y descomenta las líneas Markdown siguientes:

<!--
![Pantalla de bienvenida](docs/capturas/inicio.png)
![Drawer de navegación](docs/capturas/drawer.png)
![Portfolio - Sobre mí](docs/capturas/portfolio_sobre_mi.png)
![Portfolio - Mis proyectos](docs/capturas/portfolio_proyectos.png)
-->

En un emulador Android puedes hacer una captura con el botón de cámara del
emulador; también puedes usar `adb exec-out screencap -p > docs/capturas/inicio.png`
(repite con el nombre correspondiente después de abrir cada pantalla).

## Publicación en GitHub

Crea un **repositorio vacío** en el perfil `joelsanchhhez` con el nombre
`PGL-P2-MyPortfolio`. Después, desde el proyecto:

```bash
git init
git checkout -b 'P2-Tarea1-Navegación'
git add .
git commit -m "P2 tarea 1: navegación con Drawer y portfolio"
git remote add origin https://github.com/joelsanchhhez/PGL-P2-MyPortfolio.git
git push -u origin 'P2-Tarea1-Navegación'
```

**Entregable:** una vez creada y subida la rama, copia su enlace desde la web
de GitHub. No se incluye un enlace a una rama inexistente.

## Recursos pendientes del portfolio anterior

La práctica 1 hacía referencia a `LaVidaDeJoel.zip`, que no se ha adjuntado con
esta entrega. Se ha empleado un avatar Material de sustitución en lugar de la
foto personal. El resto de la presentación y las actividades se basan en el
PDF aportado. Para conseguir una coincidencia exacta, añade la foto de ese
portfolio anterior (consulta `assets/images/README.md`).

## Referencia del diseño

`Cancha_Canaria_Diseno_Joel.pdf` — páginas 2 (bienvenida), 3 (portfolio),
7 (organización), 8 (colores) y 9 (iconos), según la numeración impresa.
