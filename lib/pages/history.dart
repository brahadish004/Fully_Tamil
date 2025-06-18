import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<String> history;

  const HistoryPage({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EAF0E),
        title: const Text('History Page',
        style: TextStyle(
          color: Colors.white
        ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            // Handle the back arrow press, e.g., navigate back
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const Center(
        child: Text(
          'Temporarily not available',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
