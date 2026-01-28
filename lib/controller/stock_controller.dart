import 'package:flutter/material.dart';
import '../model/stock_model.dart';
import '../service/websocket_service.dart';

class StockController extends ChangeNotifier {

  final WebSocketService _socket = WebSocketService();
  final List<Stock> _allStocks = [];
  Stock? _singleStock;
  List<Stock> get allStocks => _allStocks;
  Stock? get singleStock => _singleStock;


  void init() {

    _socket.onAllStocks = (dynamic data) {
      if (data is List) {
        print("data is list");
        _allStocks.clear();

        for (final item in data) {
          if (item is Map<String, dynamic>) {
            _allStocks.add(Stock.fromJson(item));
          }
        }

      }
      else if (data is Map<String, dynamic>) {
        print("data is map");
        final stock = Stock.fromJson(data);
        _updateOrAdd(stock);
      }
      notifyListeners();
    };
    _socket.onSingleStock = (dynamic data) {
      if (data is Map<String, dynamic>) {
        print("data is map for single stock");
        _singleStock = Stock.fromJson(data);
        notifyListeners();
      }
    };
    _socket.connect();
  }

  void _updateOrAdd(Stock stock) {

    final index =
    _allStocks.indexWhere((s) => s.symbol == stock.symbol);
    print(index);
    if (index == -1) {
      print("New entry made");
      _allStocks.add(stock);
    } else {
      _allStocks[index] = stock;
      print(_allStocks[index]);
    }
  }

  void loadSingleStock(String symbol) {
    _socket.requestSingleStock(symbol);
  }

  void disposeController() {
    _socket.disconnect();
  }

}