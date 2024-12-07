import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SMSListener extends StatefulWidget {
  @override
  _SMSListenerState createState() => _SMSListenerState();
}

class _SMSListenerState extends State<SMSListener> {
  static const eventChannel = EventChannel('sms_stream');
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    eventChannel.receiveBroadcastStream().listen(
      (data) {
        setState(() {
          messages.add(data);
        });
      },
      onError: (error) {
        setState(() {
          messages.add("Error receiving SMS: ${error.message}");
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SMS Listener")),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index]),
          );
        },
      ),
    );
  }
}
