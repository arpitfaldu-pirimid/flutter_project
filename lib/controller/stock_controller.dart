import 'package:flutter/material.dart';
import '../model/stock_model.dart';
import '../service/websocket_service.dart';

class StockController extends ChangeNotifier {

  final WebSocketService _socket = WebSocketService();
  final List<Stock> _allStocks = [];
  Stock? _singleStock;
  String? _error;
  List<Stock> get allStocks => _allStocks;
  Stock? get singleStock => _singleStock;
  String? get error => _error;

  void init() {
    _socket.onAllStocks = (dynamic data) {
      if (data is List) {
        _allStocks.clear();
        for (final item in data) {
          if (item is Map<String, dynamic>) {
            _allStocks.add(Stock.fromJson(item));
          }
        }
      }
      notifyListeners();
    };
    _socket.onSingleStock = (dynamic data) {
      if (data is Map<String, dynamic>) {
        _singleStock = Stock.fromJson(data);
        _error = null;
        notifyListeners();
      }
    };

    _socket.connect();
  }

  void loadSingleStock(String symbol) {

    _singleStock = null;
    _error = null;
    notifyListeners();
    _socket.requestSingleStock(symbol);
    Future.delayed(const Duration(seconds: 1), () {
      if (_singleStock == null) {
        setError(
          "Enter a valid stock symbol by checking 'Show All Stocks'",
        );
      }
    });
  }

  void setError(String message) {
    _error = message;
    _singleStock = null;
    notifyListeners();
  }

  void disposeController() {

    _socket.disconnect();
  }
}
