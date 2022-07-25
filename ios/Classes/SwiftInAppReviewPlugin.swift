import Flutter
import UIKit
import StoreKit

public class SwiftInAppReviewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "in_app_review_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftInAppReviewPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
          case "requestReview":
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview() // Requesting alert view for getting rating from the user.
                result("Later than iOS 10.3 the App will Request the App Review, Users can turn this off in settings for all apps, Apple will manage when to request the review from the user. In Debug it will always show")
            } else {
                // Fallback on earlier versions
                result("Prior to iOS 10.3 App Review from App is not available. ")
            }
          default:
            result(FlutterMethodNotImplemented)
    }
  }
}
