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
      appBar: AppBar(title: Text("Dial Pad")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              phoneNumber,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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
                  child: Text(
                    buttons[index],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.backspace, size: 30),
                onPressed: _onBackspacePressed,
              ),
              SizedBox(width: 50),
              FloatingActionButton(
                onPressed: _onCallPressed, // Call this method on press
                backgroundColor: Colors.green,
                child: Icon(Icons.call, size: 30),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
