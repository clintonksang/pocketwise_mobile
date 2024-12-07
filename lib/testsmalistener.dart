import 'package:flutter/material.dart';

import 'Databasehelper.dart';

class SMSListener extends StatefulWidget {
  @override
  _SMSListenerState createState() => _SMSListenerState();
}

class _SMSListenerState extends State<SMSListener> {
  List<String> messages = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  void loadMessages() async {
    var smsMessages = await dbHelper.messages();
    setState(() {
      messages = smsMessages;
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: loadMessages,
        tooltip: 'Refresh Messages',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
