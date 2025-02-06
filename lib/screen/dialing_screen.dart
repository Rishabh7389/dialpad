import 'package:flutter/material.dart';

class DialingScreen extends StatefulWidget {
  final String dialedNumber;

  // Constructor to accept the dialedNumber
  const DialingScreen({required this.dialedNumber});

  @override
  _DialingScreenState createState() => _DialingScreenState();
}

class _DialingScreenState extends State<DialingScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isCallEnded = false;

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _endCall() {
    setState(() {
      _isCallEnded = true;
    });
    Navigator.pop(context); // Go back to the previous screen when call ends
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dialing"),
        backgroundColor: const Color.fromARGB(255, 194, 140, 245),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dialed number display
            Text(
              'Dialing: ${widget.dialedNumber}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            // Simulate dialing process with a circular progress indicator
            _isCallEnded
                ? Icon(
                    Icons.call_end,
                    size: 100,
                    color: Colors.red,
                  )
                : CircularProgressIndicator(),
            SizedBox(height: 50),
            // Buttons for call controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mute Button
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.mic_off : Icons.mic,
                    size: 36,
                    color: _isMuted ? Colors.red : Colors.blue,
                  ),
                  onPressed: _toggleMute,
                ),
                // Speaker Button
                IconButton(
                  icon: Icon(
                    _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                    size: 36,
                    color: _isSpeakerOn ? Colors.green : Colors.blue,
                  ),
                  onPressed: _toggleSpeaker,
                ),
                // End Call Button
                IconButton(
                  icon: Icon(
                    Icons.call_end,
                    size: 36,
                    color: Colors.red,
                  ),
                  onPressed: _endCall,
                ),
              ],
            ),
            SizedBox(height: 30),
            // Additional space for layout
            _isCallEnded
                ? Text(
                    'Call Ended',
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
