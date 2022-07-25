import 'package:flutter/material.dart';
import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:in_app_review_plugin/in_app_review_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _inAppReviewPlugin = InAppReviewPlugin();
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'In app review',
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('Example project')),
        body: Builder(builder: (context) =>
          Center(
              child: TextButton(
                onPressed: (){
                  ReviewDialog(
                      context: context,
                      btnRateOnPress: (){
                        Navigator.of(context).pop();
                        _inAppReviewPlugin.requestReview();
                      },
                      btnFeedbackOnPress: (){
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmailRoute()),
                        );
                      }
                  ).show();
                },
                child: const Text('Show Dialog'),
              )
          ),
        ),
      ),
    );
  }
}


class EmailRoute extends StatelessWidget {
  EmailRoute({super.key});

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final _inAppReviewPlugin = InAppReviewPlugin();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'In app review',
        scaffoldMessengerKey: _messangerKey,
        home: Scaffold(
          backgroundColor: const Color(0xfff5f5fd),
          body: Center(
            child: Container(
              height: 450,
              width: 400,
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey[300]!)
                  ]),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Feedback email',
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Required*';
                        } else if (!EmailValidator.validate(email)) {
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: messageController,
                      decoration: const InputDecoration(hintText: 'Message'),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '*Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 45,
                      width: 110,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: const Color(0xff151534),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40))),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final response = await _inAppReviewPlugin.sendEmail(
                                nameController.value.text,
                                'artur.rakhmatullin@gmail.com',
                                messageController.value.text,
                                'your service name',
                                'your template id',
                                'your public token',
                            );
                            _messangerKey.currentState!.showSnackBar(
                              response == 200
                                  ? const SnackBar(
                                  content: Text('Message Sent!'),
                                  backgroundColor: Colors.green)
                                  : const SnackBar(
                                  content: Text('Failed to send message!'),
                                  backgroundColor: Colors.red),
                            );
                            nameController.clear();
                            emailController.clear();
                            messageController.clear();
                          }
                        },
                        child: const Text(
                            'Send', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    SizedBox(
                        height: 45,
                        width: 110,
                        child: TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: const Color(0xff151534),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Go back!')
                        )
                    )
                  ],
                ),
              ),
            ),
          ),)
    );
  }
}