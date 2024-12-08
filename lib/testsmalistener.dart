import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SMSListener extends StatefulWidget {
  @override
  _SMSListenerState createState() => _SMSListenerState();
}

class _SMSListenerState extends State<SMSListener> {
  List<String> messages = [];
  static const EventChannel _smsChannel = EventChannel('sms_stream');

  @override
  void initState() {
    super.initState();
    _listenToSMS();
  }

  void _listenToSMS() {
    _smsChannel.receiveBroadcastStream().listen((dynamic message) {
      setState(() {
        messages.insert(0, message.toString()); // Add new messages at the top
      });
    }, onError: (dynamic error) {
      print('Received error: ${error}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SMS Listener")),
      body: messages.isEmpty
          ? Center(child: Text("No messages received"))
          : ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                messages[index],
                style: TextStyle(color: Colors.black)
            ),
          );
        },
      ),
    );
  }
}