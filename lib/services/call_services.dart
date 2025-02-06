import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CallServices {
  static const platform = MethodChannel("com.example.dialer/call");

  Future<void> onCallPressed(String phone, BuildContext context) async {
    if (phone.isNotEmpty) {
      try {
        final bool result = await platform.invokeMethod('makeCall', {
          "phoneNumber": phone,
        });

        if (!result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not make the call")),
          );
        }
      } on PlatformException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to make call: ${e.message}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a number")),
      );
    }
  }
}
