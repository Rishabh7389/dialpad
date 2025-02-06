import 'package:dialpad/services/call_services.dart';
import 'package:flutter/material.dart';
import 'package:call_e_log/call_log.dart'; // Import call_log package
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling
import 'dialing_screen.dart'; // Your DialingScreen

class OutgoingCallsScreen extends StatefulWidget {
  @override
  _OutgoingCallsScreenState createState() => _OutgoingCallsScreenState();
}

class _OutgoingCallsScreenState extends State<OutgoingCallsScreen> {
  List<CallLogEntry> _callLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOutgoingCalls();
  }

  Future<void> _loadOutgoingCalls() async {
    // Request permission to access call logs
    PermissionStatus permission = await Permission.phone.request();
    if (permission.isGranted) {
      // Fetch call logs
      Iterable<CallLogEntry> callLogs = await CallLog.query();
      setState(() {
        // Filter only outgoing calls
        _callLogs =
            callLogs.where((log) => log.callType == CallType.outgoing).toList();
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
          : _callLogs.isEmpty
              ? Center(child: Text("No outgoing calls found"))
              : ListView.builder(
                  itemCount: _callLogs.length,
                  itemBuilder: (context, index) {
                    CallLogEntry log = _callLogs[index];
                    return ListTile(
                      leading: Icon(Icons.call_made, color: Colors.blue),
                      title: Text(log.name ?? 'Unknown'),
                      subtitle: Text('Phone: ${log.number ?? 'No number'}'),
                      trailing: Text(
                        log.timestamp != null
                            ? DateTime.fromMillisecondsSinceEpoch(
                                    log.timestamp!)
                                .toString()
                            : 'No Time',
                      ),
                      onTap: () {
                        // Navigate to the DialingScreen with real number
                        CallServices()
                            .onCallPressed(log.number.toString(), context);
                      },
                    );
                  },
                ),
    );
  }
}
