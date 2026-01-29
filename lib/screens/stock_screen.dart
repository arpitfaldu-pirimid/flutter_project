import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/stock_controller.dart';
import '../model/stock_model.dart';

class StockScreen extends StatefulWidget {

  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {

  final TextEditingController _symbolController =
  TextEditingController();

  bool showAll = false;
  bool showSingle = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<StockController>().init();
    });
  }

  @override
  void dispose() {

    context.read<StockController>().disposeController();

    _symbolController.dispose();

    super.dispose();
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {

    final controller = context.watch<StockController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Stock Prices"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            // Input
            TextField(
              controller: _symbolController,

              decoration: const InputDecoration(
                labelText: "Stock Symbol (AAPL)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Buttons
            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAll = true;
                        showSingle = false;
                      });
                    },
                    child: const Text("Show All"),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final symbol =
                      _symbolController.text
                          .trim()
                          .toUpperCase();
                      if (symbol.isEmpty) {
                        context
                            .read<StockController>()
                            .setError("Please enter a stock symbol");
                        setState(() {
                          showAll = false;
                          showSingle = true;
                        });
                        return;
                      }
                      context
                          .read<StockController>()
                          .loadSingleStock(symbol);
                      setState(() {
                        showAll = false;
                        showSingle = true;
                      });
                    },
                    child: const Text("Single Stock"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (controller.error != null)
              Text(
                controller.error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: _buildContent(controller),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildContent(StockController controller) {

    if (showAll) {
      return _buildAllStocks(controller.allStocks);
    }

    if (showSingle) {
      return _buildSingleStock(
        controller.singleStock,
        controller.error,
      );
    }

    return const Center(
      child: Text("Select an option"),
    );
  }


  Widget _buildAllStocks(List<Stock> stocks) {

    if (stocks.isEmpty) {
      return const Center(child: Text("Waiting..."));
    }
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return Card(
          child: ListTile(
            title: Text(stock.symbol),
            subtitle: Text(stock.name),
            trailing: Text(
              "₹ ${stock.price}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSingleStock(Stock? stock, String? error) {
    if (error != null) {
      return const SizedBox();
    }
    if (stock == null) {
      return const Center(child: Text("Loading..."));
    }
    return Card(
      child: ListTile(
        title: Text(stock.symbol),
        subtitle: Text(stock.name),
        trailing: Text(
          "₹ ${stock.price}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}