import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class DialPadScreen extends StatefulWidget {
  @override
  _DialPadScreenState createState() => _DialPadScreenState();
}

class _DialPadScreenState extends State<DialPadScreen> {
  String phoneNumber = "";
  String fullPhoneNumber = "";
  static const platform = MethodChannel("com.example.dialer/call");

  // Controller to manage the phone number input field
  final TextEditingController _phoneController = TextEditingController();

  void _onNumberPressed(String number) {
    setState(() {
      phoneNumber += number;
      _phoneController.text =
          phoneNumber; // Update the phone number in the input field
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (phoneNumber.isNotEmpty) {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
        _phoneController.text =
            phoneNumber; // Update the phone number in the input field
      }
    });
  }

  Future<void> _onCallPressed() async {
    if (phoneNumber.isNotEmpty) {
      try {
        final bool result = await platform.invokeMethod('makeCall', {
          "phoneNumber":
              phoneNumber, // Use full phone number including country code
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
      body: SingleChildScrollView(
        // Wrap everything in a SingleChildScrollView
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phone number input with country code
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: IntlPhoneField(
                controller:
                    _phoneController, // Set the controller to manage the input
                initialCountryCode: 'US', // Set default country code
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                onChanged: (phone) {
                  setState(() {
                    fullPhoneNumber =
                        phone.completeNumber; // Store full phone number
                    phoneNumber = phone
                        .number; // Store the local number (without country code)
                  });
                },
                onCountryChanged: (country) {
                  setState(() {
                    // The selected country code will automatically update here
                  });
                },
              ),
            ),
            // Displaying the phone number
            Text(phoneNumber,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Dial pad grid
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

            // Backspace and call button
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
      ),
    );
  }
}
