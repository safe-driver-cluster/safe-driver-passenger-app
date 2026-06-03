import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safedriver_passenger_app/main.dart';

void main() {
  testWidgets('SafeDriver app renders the startup shell', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SafeDriverApp()));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
