import 'package:flutter/material.dart';
import 'udp_receiver.dart';

void main() {
  runApp(UdpReceiverApp());
}

class UdpReceiverApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UDP Receiver',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UdpReceiverScreen(),
    );
  }
}

class UdpReceiverScreen extends StatefulWidget {
  @override
  _UdpReceiverScreenState createState() => _UdpReceiverScreenState();
}

class _UdpReceiverScreenState extends State<UdpReceiverScreen> {
  late UdpReceiver _udpReceiver;
  List<Map<String, dynamic>> _receivedMessages = [];

  @override
  void initState() {
    super.initState();
    _udpReceiver = UdpReceiver(
      port: 9004,
      onMessageReceived: (message, interval) {
        setState(() {
          _receivedMessages.insert(0, {
            'message': message,
            'interval': interval.toStringAsFixed(1),
          });
        });
      },
    );
    _udpReceiver.start();
  }

  @override
  void dispose() {
    _udpReceiver.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UDP Receiver'),
      ),
      body: ListView.builder(
        itemCount: _receivedMessages.length,
        itemBuilder: (context, index) {
          final message = _receivedMessages[index];
          return ListTile(
            title: Text('Message: ${message['message']}'),
            subtitle: Text('Interval: ${message['interval']} seconds'),
          );
        },
      ),
    );
  }
}
