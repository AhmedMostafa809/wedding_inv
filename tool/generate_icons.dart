// Run with: flutter test tool/generate_icons.dart
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_inv/views/widgets/infinity_memories.dart';

Future<Uint8List> renderIcon(int size) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  canvas.drawColor(const ui.Color(0xFFF0EAE1), ui.BlendMode.src);
  canvas.translate(size * .18, size * .30);
  canvas.drawPath(
    infinityPath(ui.Size(size * .64, size * .40)),
    ui.Paint()
      ..color = const ui.Color(0xFF000000)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = size * .034
      ..strokeCap = ui.StrokeCap.round
      ..strokeJoin = ui.StrokeJoin.round,
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return data!.buffer.asUint8List();
}

void main() {
  test(
    'Generate infinity launcher artwork for all existing platforms',
    () async {
      final files = <File>[];
      for (final directory in [
        'web',
        'android/app/src/main/res',
        'ios/Runner/Assets.xcassets/AppIcon.appiconset',
        'macos/Runner/Assets.xcassets/AppIcon.appiconset',
      ]) {
        files.addAll(
          Directory(directory)
              .listSync(recursive: true)
              .whereType<File>()
              .where(
                (file) =>
                    RegExp(r'(favicon|Icon-|ic_launcher|app_icon_).*\.png$')
                        .hasMatch(file.path),
              ),
        );
      }
      for (final file in files) {
        final codec = await ui.instantiateImageCodec(await file.readAsBytes());
        final frame = await codec.getNextFrame();
        final size = frame.image.width;
        frame.image.dispose();
        codec.dispose();
        await file.writeAsBytes(await renderIcon(size));
      }
      final png = await renderIcon(256);
      final header = ByteData(22)
        ..setUint16(2, 1, Endian.little)
        ..setUint16(4, 1, Endian.little)
        ..setUint16(10, 1, Endian.little)
        ..setUint16(12, 32, Endian.little)
        ..setUint32(14, png.length, Endian.little)
        ..setUint32(18, 22, Endian.little);
      await File('windows/runner/resources/app_icon.ico')
          .writeAsBytes([...header.buffer.asUint8List(), ...png]);
      expect(files.length, greaterThan(20));
    },
  );
}
