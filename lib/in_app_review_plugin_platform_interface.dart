import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'in_app_review_plugin_method_channel.dart';

abstract class InAppReviewPluginPlatform extends PlatformInterface {
  /// Constructs a InAppReviewPluginPlatform.
  InAppReviewPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static InAppReviewPluginPlatform _instance = MethodChannelInAppReviewPlugin();

  /// The default instance of [InAppReviewPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelInAppReviewPlugin].
  static InAppReviewPluginPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InAppReviewPluginPlatform] when
  /// they register themselves.
  static set instance(InAppReviewPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> requestReview() {
    throw UnimplementedError('requestReview() has not been implemented.');
  }
}
