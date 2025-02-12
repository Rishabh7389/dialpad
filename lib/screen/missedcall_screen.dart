import 'package:dialpad/services/call_services.dart';
import 'package:flutter/material.dart';
import 'package:call_e_log/call_log.dart'; // Import call_log package
import 'package:permission_handler/permission_handler.dart'; // Import for permission handling
// Your DialingScreen

class MissedCallsScreen extends StatefulWidget {
  @override
  _MissedCallsScreenState createState() => _MissedCallsScreenState();
}

class _MissedCallsScreenState extends State<MissedCallsScreen> {
  List<CallLogEntry> _missedCalls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissedCalls();
  }

  Future<void> _loadMissedCalls() async {
    // Request permission to access call logs
    PermissionStatus permission = await Permission.phone.request();
    if (permission.isGranted) {
      // Fetch call logs
      Iterable<CallLogEntry> callLogs = await CallLog.query();
      setState(() {
        // Filter only missed calls
        _missedCalls =
            callLogs.where((log) => log.callType == CallType.missed).toList();
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
          : _missedCalls.isEmpty
              ? Center(child: Text("No missed calls found"))
              : ListView.builder(
                  itemCount: _missedCalls.length,
                  itemBuilder: (context, index) {
                    CallLogEntry log = _missedCalls[index];
                    return ListTile(
                      leading: Icon(Icons.call_missed, color: Colors.red),
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
