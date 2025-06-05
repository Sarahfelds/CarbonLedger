// migrate_success_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for NumberFormat

class MigrateSuccessScreen extends StatelessWidget {
  final String greenerCoin;
  final double convertedAmount;

  const MigrateSuccessScreen({
    Key? key,
    required this.greenerCoin,
    required this.convertedAmount,
  }) : super(key: key);

  // Helper function to format the converted amount for better readability
  String _formatConvertedAmount(double amount) {
    // If the amount is very small, show more decimal places
    if (amount.abs() < 1.0) {
      return NumberFormat('0.00000000', 'en_US').format(amount); // Typically 8 decimal places for crypto
    }
    // For larger amounts, use fewer decimal places for readability
    return NumberFormat('0.00', 'en_US').format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('Migration Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cash.png', // Assuming 'cash.png' is the image of money bundles
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your transaction has been migrated successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 30),
            Text(
              'You now have ${_formatConvertedAmount(convertedAmount)} $greenerCoin', // Use formatted amount
              style: const TextStyle(color: Colors.greenAccent, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}