import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialPadScreen extends StatefulWidget {
  @override
  _DialPadScreenState createState() => _DialPadScreenState();
}

class _DialPadScreenState extends State<DialPadScreen> {
  String phoneNumber = "";
  static const platform = MethodChannel("com.example.dialer/call");

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

  Future<void> _onCallPressed() async {
    if (phoneNumber.isNotEmpty) {
      try {
        final bool result = await platform.invokeMethod('makeCall', {
          "phoneNumber": phoneNumber,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dial Pad", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 194, 140, 245),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(phoneNumber,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.5,
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
                child: Text(buttons[index],
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              );
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.backspace, size: 36, color: Colors.red),
                  onPressed: _onBackspacePressed),
              SizedBox(width: 40),
              FloatingActionButton(
                onPressed: _onCallPressed,
                backgroundColor: Colors.green,
                child: Icon(Icons.call, size: 36),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
