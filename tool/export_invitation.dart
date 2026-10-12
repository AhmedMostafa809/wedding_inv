// Run: flutter test tool/export_invitation.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wedding_inv/data/local_invitation.dart';
import 'package:wedding_inv/views/printable_invitation.dart';

void main() {
  testWidgets('Export the Arabic invitation as a shareable PNG', (
    tester,
  ) async {
    await initializeDateFormatting('ar');
    for (final font in {
      'Amiri': 'Amiri-Regular.ttf',
      'GreatVibes': 'GreatVibes-Regular.ttf',
      'CormorantGaramond': 'CormorantGaramond.ttf',
    }.entries) {
      await (FontLoader(
        font.key,
      )..addFont(rootBundle.load('assets/fonts/${font.value}'))).load();
    }
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(540, 960);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: PrintableInvitation(invitation: localInvitation),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.runAsync(() async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final directory = Directory('documents')..createSync(recursive: true);
      await File('${directory.path}/Ahmed_Asmaa_Arabic_Invitation.png')
          .writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  });
}
