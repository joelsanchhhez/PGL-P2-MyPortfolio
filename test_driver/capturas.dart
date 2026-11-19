import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async => integrationDriver(
      onScreenshot: (nombre, bytes, [argumentos]) async {
        await Directory('docs/capturas').create(recursive: true);
        await File('docs/capturas/$nombre.png').writeAsBytes(bytes);
        return true;
      },
    );
