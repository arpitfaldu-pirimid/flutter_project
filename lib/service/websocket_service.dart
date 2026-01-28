import 'dart:convert';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../config/app_config.dart';

class WebSocketService {
  late StompClient _client;
  Function(dynamic)? onAllStocks;
  Function(dynamic)? onSingleStock;

  void connect() {

    _client = StompClient(
      config: StompConfig.sockJS(
        url: AppConfig.socketUrl,
        onConnect: _onConnect,
        onWebSocketError: (error) {
          print("Websocket connection is not successful: $error");
        },
        reconnectDelay: const Duration(seconds: 5),
      ),
    );
    _client.activate();

  }

  void _onConnect(StompFrame frame) {
    print("Connected to WebSocket");

    //for subscribing to prices of all stocks
    _client.subscribe(
      destination: AppConfig.allStocksTopic,
      callback: (frame) {
        if (frame.body == null) return;
        final decoded = jsonDecode(frame.body!);
        onAllStocks?.call(decoded);
      },
    );

    //for subscribing to price of any single stock
    _client.subscribe(
      destination: AppConfig.singleStockTopic,
      callback: (frame) {
        if (frame.body == null) return;
        final decoded = jsonDecode(frame.body!);
        onSingleStock?.call(decoded);
      },
    );

  }

  void requestSingleStock(String symbol) {

    if (!_client.connected) return;

    _client.send(
      destination: AppConfig.singleStockSend,
      body: symbol,
    );

  }

  void disconnect() {
    if (_client.connected) {
      _client.deactivate();
    }
  }

}