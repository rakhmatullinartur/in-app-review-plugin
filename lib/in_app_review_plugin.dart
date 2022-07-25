import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'in_app_review_plugin_platform_interface.dart';

class InAppReviewPlugin {

  Future<void> requestReview() {
    return InAppReviewPluginPlatform.instance.requestReview();
  }

  Future sendEmail(
      String name, String email, String message, String serviceId, String templateId, String userId
      ) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'from_name': name,
            'from_email': email,
            'message': message
          }
        }));
    return response.statusCode;
  }


}
class ReviewDialog {
  /// [@required]
  final BuildContext context;
  final Function()? btnRateOnPress;
  final Function()? btnFeedbackOnPress;

  ReviewDialog({
    required this.context,
    this.btnRateOnPress,
    this.btnFeedbackOnPress,
  });


  Future<dynamic> show() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Free money'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('I did not sleep nights to provide you with such a wonderful plugin'),
                  Text('Go and give us feedback(?)'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Rate App'),
                onPressed: () {
                  if (btnRateOnPress != null) {
                    btnRateOnPress?.call();
                  }
                }
              ),
              TextButton(
                child: const Text('Feedback'),
                onPressed: () {
                  if (btnFeedbackOnPress !=null) {
                    btnFeedbackOnPress?.call();
                  }
                },
              ),
            ],
          );
        },
      );
    }
}
