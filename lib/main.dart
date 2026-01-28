import 'package:flutter/material.dart';
import 'package:flutter_mini_project/screens/stock_screen.dart';
import 'package:provider/provider.dart';
import 'controller/stock_controller.dart';
import 'screens/stock_screen.dart' hide StockScreen;

void main() {
  runApp(const StockApp());
}

class StockApp extends StatelessWidget {
  const StockApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => StockController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stock Live',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const StockScreen(),
      ),
    );
  }
}
