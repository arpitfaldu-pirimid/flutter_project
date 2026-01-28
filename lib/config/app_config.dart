class AppConfig {

  // Backend websocket link
  static const String baseUrl =
      "http://192.168.1.58:8080";

  //main  connection endpoint
  static const String socketUrl =
      "$baseUrl/prices";

  static const String allStocksTopic =
      "/topic/prices";

  static const String singleStockTopic =
      "/topic/single";

  static const String singleStockSend =
      "/app/single-stock";
}
