import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MqttService {
  late MqttServerClient client;
  Function(Map<String, dynamic>)? onMessageReceived;

  Future<void> connect() async {
    if (kIsWeb) {
      client = MqttServerClient.withPort('broker.hivemq.com', '', 8000);
      client.useWebSocket = true;
      client.secure = false;
    } else {
      client = MqttServerClient('broker.hivemq.com', '');
      client.port = 1883;
      client.secure = false;
    }

    client.logging(on: true);

    client.onConnected = () => print('MQTT Connected');
    client.onDisconnected = () => print('MQTT Disconnected');

    try {
      await client.connect();
    } catch (e) {
      print('MQTT Connection error: $e');
      client.disconnect();
      return;
    }

    client.subscribe('locker/1/status', MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received MQTT: $message');

      if (onMessageReceived != null) {
        onMessageReceived!(json.decode(message));
      }
    });
  }
}
