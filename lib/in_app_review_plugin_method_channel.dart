import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'in_app_review_plugin_platform_interface.dart';

/// An implementation of [InAppReviewPluginPlatform] that uses method channels.
class MethodChannelInAppReviewPlugin extends InAppReviewPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('in_app_review_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> requestReview() async {
    await methodChannel.invokeMethod<String>('requestReview');
  }
}
