import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salvia_ai/core/widgets/glass_container.dart';
import 'package:salvia_ai/core/widgets/salvia_watermark.dart';

void main() {
  testWidgets('GlassContainer renders child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlassContainer(
            child: Text('Test'),
          ),
        ),
      ),
    );
    expect(find.text('Test'), findsOneWidget);
  });

  testWidgets('SalviaWatermark renders without error', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: SalviaWatermark()),
        ),
      ),
    );
    expect(find.byType(SalviaWatermark), findsOneWidget);
  });
}
