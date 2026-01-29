import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {

  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? '';

  static String get socketUrl =>
      '$baseUrl${dotenv.env['SOCKET_ENDPOINT'] ?? ''}';

  static String get allStocksTopic =>
      dotenv.env['ALL_STOCKS_TOPIC'] ?? '';

  static String get singleStockTopic =>
      dotenv.env['SINGLE_STOCK_TOPIC'] ?? '';

  static String get singleStockSend =>
      dotenv.env['SINGLE_STOCK_SEND'] ?? '';
}
