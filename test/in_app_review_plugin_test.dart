import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review_plugin/in_app_review_plugin.dart';
import 'package:in_app_review_plugin/in_app_review_plugin_platform_interface.dart';
import 'package:in_app_review_plugin/in_app_review_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInAppReviewPluginPlatform 
    with MockPlatformInterfaceMixin
    implements InAppReviewPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final InAppReviewPluginPlatform initialPlatform = InAppReviewPluginPlatform.instance;

  test('$MethodChannelInAppReviewPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInAppReviewPlugin>());
  });

  test('getPlatformVersion', () async {
    InAppReviewPlugin inAppReviewPlugin = InAppReviewPlugin();
    MockInAppReviewPluginPlatform fakePlatform = MockInAppReviewPluginPlatform();
    InAppReviewPluginPlatform.instance = fakePlatform;
  
    expect(await inAppReviewPlugin.getPlatformVersion(), '42');
  });
}
