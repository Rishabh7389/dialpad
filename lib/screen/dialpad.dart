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
  final ValueNotifier<bool> _isDarkMode = ValueNotifier<bool>(false);

  void _onNumberPressed(String number) {
    setState(() {
      phoneNumber += number;
      _phoneController.text = phoneNumber;
    });
  }

  void _onBackspacePressed() {
    setState(() {
      if (phoneNumber.isNotEmpty) {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
        _phoneController.text = phoneNumber;
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
    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          theme: isDark ? ThemeData.dark() : ThemeData.light(),
          home: Scaffold(
            appBar: AppBar(
              title: Text("Dial Pad",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              backgroundColor: const Color.fromARGB(255, 152, 231, 245),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IntlPhoneField(
                      style: TextStyle(height: 2.3),
                      controller: _phoneController,
                      initialCountryCode: 'US',
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(width: 50),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.backspace, color: Colors.red),
                          onPressed: _onBackspacePressed,
                        ),
                      ),
                      onChanged: (phone) {
                        setState(() {
                          fullPhoneNumber = phone.completeNumber;
                          phoneNumber = phone.number;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 25,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1.7,
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
                      return SizedBox(
                        // Ensure equal height
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), // Makes the button circular
                            padding:
                                EdgeInsets.all(20), // Controls inner spacing
                            backgroundColor: const Color.fromARGB(
                                255, 208, 238, 247), // Change color if needed
                          ),
                          onPressed: () => _onNumberPressed(buttons[index]),
                          child: Text(
                            buttons[index],
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(
                                    255, 18, 136, 232)), // Bigger text
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 90, // Increased width
                      height: 90, // Increased height
                      child: FloatingActionButton(
                        onPressed: _onCallPressed,
                        shape: CircleBorder(),
                        backgroundColor:
                            const Color.fromARGB(255, 109, 202, 113),
                        child: Icon(Icons.call, size: 46), // Bigger call icon
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
