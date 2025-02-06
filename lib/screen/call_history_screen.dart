import 'package:dialpad/screen/incoming_screen.dart';
import 'package:dialpad/screen/missedcall_screen.dart';
import 'package:dialpad/screen/outgoingcall_screen.dart';
import 'package:flutter/material.dart';

class CallHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs (Incoming, Outgoing, Missed)
      child: Scaffold(
        appBar: AppBar(
          title: Text("Call History"),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Incoming'),
              Tab(text: 'Outgoing'),
              Tab(text: 'Missed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            IncomingCallsScreen(), // Display incoming calls
            OutgoingCallsScreen(), // Display outgoing calls
            MissedCallsScreen(), // Display missed calls
          ],
        ),
      ),
    );
  }
}
