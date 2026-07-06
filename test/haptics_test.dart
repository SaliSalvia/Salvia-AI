import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salvia_ai/core/utils/haptics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async => null,
    );
  });

  test('HapticUtils.light does not throw', () async {
    expect(() async => HapticUtils.light(), returnsNormally);
  });

  test('HapticUtils.success does not throw', () async {
    expect(() async => HapticUtils.success(), returnsNormally);
  });

  test('HapticUtils.error does not throw', () async {
    expect(() async => HapticUtils.error(), returnsNormally);
  });
}
