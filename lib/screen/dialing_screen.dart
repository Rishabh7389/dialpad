import 'package:flutter/material.dart';

class DialingScreen extends StatelessWidget {
  final String dialedNumber;

  // Constructor to accept the dialedNumber
  const DialingScreen({required this.dialedNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dialing"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dialing: $dialedNumber', // Display the dialed number
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(), // Simulate dialing process
            ],
          ),
        ),
      ),
    );
  }
}
