import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review_plugin/in_app_review_plugin_method_channel.dart';

void main() {
  MethodChannelInAppReviewPlugin platform = MethodChannelInAppReviewPlugin();
  const MethodChannel channel = MethodChannel('in_app_review_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
