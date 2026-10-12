import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_inv/app.dart';

void main() {
  setUpAll(() async {
    final loader = FontLoader('Amiri')
      ..addFont(rootBundle.load('assets/fonts/Amiri-Regular.ttf'));
    await loader.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
    final display = FontLoader('CormorantGaramond')
      ..addFont(rootBundle.load('assets/fonts/CormorantGaramond.ttf'))
      ..addFont(rootBundle.load('assets/fonts/CormorantGaramond-Italic.ttf'));
    await display.load();
    final body = FontLoader('Montserrat')
      ..addFont(rootBundle.load('assets/fonts/Montserrat.ttf'));
    await body.load();
    await (FontLoader(
      'GreatVibes',
    )..addFont(rootBundle.load('assets/fonts/GreatVibes-Regular.ttf'))).load();
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('Engagement details at $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: key, child: const WeddingInvitationApp()),
      );
      await _animate(tester);
      expect(find.text('Ahmed'), findsOneWidget);
      expect(find.text('Habiba'), findsOneWidget);
      expect(find.textContaining('Asmaa'), findsNothing);
      expect(find.byKey(const Key('rsvp')), findsNothing);
      if (size.width == 390)
        await tester.runAsync(() => _capture(key, 'engagement-hero'));
      await tester.ensureVisible(find.byKey(const Key('engagement-venue')));
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/venue/golden_gate_villa.png'),
          tester.element(find.byKey(const Key('villa-photo'))),
        ),
      );
      await _animate(tester);
      expect(find.text('Golden Gate Villa'), findsOneWidget);
      if (size.width == 390)
        await tester.runAsync(() => _capture(key, 'engagement-venue'));
      await tester.ensureVisible(find.text('6:30 PM'));
      await _animate(tester);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
  testWidgets('Large text and reduced motion', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const WeddingInvitationApp());
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('open-map')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Future<void> _capture(GlobalKey key, String name) async {
  if (!const bool.fromEnvironment('CAPTURE_PREVIEWS')) return;
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 2);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final directory = Directory('build/previews')..createSync(recursive: true);
  File('${directory.path}/$name.png')
      .writeAsBytesSync(bytes!.buffer.asUint8List());
  image.dispose();
}

Future<void> _animate(WidgetTester tester) async {
  for (var i = 0; i < 80; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}
