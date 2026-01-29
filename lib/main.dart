import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'controller/stock_controller.dart';
import 'screens/stock_screen.dart';

Future<void> main() async {

  // Required before async calls in main
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: ".env");

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
