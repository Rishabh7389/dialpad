import 'package:flutter/material.dart';
import 'dialing_screen.dart'; // Import the DialingScreen

class DialPadScreen extends StatefulWidget {
  @override
  _DialPadScreenState createState() => _DialPadScreenState();
}

class _DialPadScreenState extends State<DialPadScreen> {
  String phoneNumber = "";

  void _onNumberPressed(String number) {
    setState(() {
      phoneNumber += number;
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (phoneNumber.isNotEmpty) {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      }
    });
  }

  void _onCallPressed() {
    if (phoneNumber.isNotEmpty) {
      // Navigate to DialingScreen and pass the phone number
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DialingScreen(dialedNumber: phoneNumber), // Pass phone number
        ),
      );
    } else {
      // Show an error message if no number is entered
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a number")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dial Pad", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 194, 140, 245),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the entered phone number
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            // Dial pad buttons
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12, // Reduced spacing between buttons
                  mainAxisSpacing: 12, // Reduced spacing between buttons
                  childAspectRatio:
                      1.2, // Reduced aspect ratio for smaller buttons
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  List<String> buttons = [
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '*',
                    '0',
                    '#'
                  ];
                  return ElevatedButton(
                    onPressed: () => _onNumberPressed(buttons[index]),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 8,
                    ),
                    child: Text(
                      buttons[index],
                      style: TextStyle(
                        fontSize: 28, // Reduced font size
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 117, 51, 198),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Backspace and Call Button
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Backspace button
                  IconButton(
                    icon: Icon(Icons.backspace,
                        size: 36,
                        color: const Color.fromARGB(255, 217, 35, 41)),
                    onPressed: _onBackspacePressed,
                    padding: EdgeInsets.all(0),
                    constraints: BoxConstraints(),
                  ),
                  SizedBox(width: 40),
                  // Call button
                  FloatingActionButton(
                    onPressed: _onCallPressed, // Call this method on press
                    backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                    child: Icon(Icons.call, size: 36),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
