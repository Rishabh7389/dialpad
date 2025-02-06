import 'package:dialpad/services/call_services.dart';
import 'package:flutter/material.dart';
import 'package:call_e_log/call_log.dart'; // Add this to fetch call logs
import 'package:permission_handler/permission_handler.dart'; // Add for permissions
import 'dialing_screen.dart'; // Your DialingScreen

class IncomingCallsScreen extends StatefulWidget {
  @override
  _IncomingCallsScreenState createState() => _IncomingCallsScreenState();
}

class _IncomingCallsScreenState extends State<IncomingCallsScreen> {
  List<CallLogEntry> _callLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIncomingCalls();
  }

  Future<void> _loadIncomingCalls() async {
    // Request permission to read call logs
    PermissionStatus permission = await Permission.phone.request();
    if (permission.isGranted) {
      // Fetch call logs
      Iterable<CallLogEntry> callLogs = await CallLog.query();
      setState(() {
        // Filter incoming calls
        _callLogs =
            callLogs.where((log) => log.callType == CallType.incoming).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission to access call logs is required")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _callLogs.length,
              itemBuilder: (context, index) {
                CallLogEntry log = _callLogs[index];
                return ListTile(
                  leading: Icon(Icons.call_received, color: Colors.green),
                  title: Text(log.name ?? 'Unknown'),
                  subtitle: Text('Phone Number: ${log.number ?? 'No number'}'),
                  trailing: Text(
                    log.timestamp != null
                        ? DateTime.fromMillisecondsSinceEpoch(log.timestamp!)
                            .toString()
                        : 'No Time',
                  ),
                  onTap: () {
                    // Navigate to the DialingScreen and pass the incoming number
                    CallServices()
                        .onCallPressed(log.number.toString(), context);
                  },
                );
              },
            ),
    );
  }
}
