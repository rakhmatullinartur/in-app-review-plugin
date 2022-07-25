package com.example.in_app_review_plugin

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result



/** InAppReviewPlugin */
class InAppReviewPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "in_app_review_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.getApplicationContext();
  }

  overrid fun onAttachedToActivity(@NonNull binding: ActivityPluginBinding) {
    activity = binding.getActivity()
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == 'requestReview'){
        requestReview(result)
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(@NonNull binding: ActivityPluginBinding?) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    context = null
  }

  private fun requestReview(result: MethodChannel.Result) {
    val manager: ReviewManager = FakeReviewManager(applicationContext)
    if (reviewInfo != null) {
      reviewInfo?.let {launchReviewFlow(result, manager, it)}
      return
    }
    val request: Task<ReviewInfo> = manager.requestReviewFlow()
    request.addOnCompleteListener { task ->
      if (task.isSuccessful()) {
        val reviewInfo: ReviewInfo = task.getResult()
        launchReviewFlow(result, manager, reviewInfo)
      } else {
        result.error("error", "In-App Review API unavailable", null)
      }
    }
  }

  private fun launchReviewFlow(result: MethodChannel.Result, manager: ReviewManager, reviewInfo: ReviewInfo) {
    val flow: Task<Void> = manager.launchReviewFlow(activity!!, reviewInfo)
    flow.addOnCompleteListener { task -> result.success(null) }
  }
}

