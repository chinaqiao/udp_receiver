import 'dart:io';
import 'dart:async';

class UdpReceiver {
  RawDatagramSocket? _socket;
  final int port;
  final Function(String, double) onMessageReceived;

  DateTime? _lastReceivedTime;

  UdpReceiver({required this.port, required this.onMessageReceived});

  Future<void> start() async {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
    _socket?.broadcastEnabled = true; // 启用广播
    _socket?.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? datagram = _socket?.receive();
        if (datagram != null) {
          String message = String.fromCharCodes(datagram.data);
          double interval = 0.0;
          if (_lastReceivedTime != null) {
            interval = DateTime.now().difference(_lastReceivedTime!).inMilliseconds / 1000.0;
          }
          _lastReceivedTime = DateTime.now();
          onMessageReceived(message, interval);
        }
      }
    });
  }

  void stop() {
    _socket?.close();
    _socket = null;
  }
}
