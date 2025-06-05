import 'package:flutter/material.dart';
import 'package:greenchain_3/screens/CarbonOffsetScreen.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:greenchain_3/screens/GreenerAlternativesPopupScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart'; // For Clipboard

class EmissionsPopupScreen extends StatelessWidget {
  final double carbonEmission; // in Tonnes CO₂ (but often used as kg CO2 in comparisons)
  final double energyConsumed; // in Wh
  final String comparisonText; // This is a property but also derived locally.
  final String selectedBlockchain; // e.g., 'Bitcoin', 'Ethereum', 'Polygon', 'Solana', 'Algorand', 'Polkadot'
  final double transactionSize;
  final double transactionAmount;

  const EmissionsPopupScreen({
    Key? key,
    required this.carbonEmission,
    required this.energyConsumed,
    required this.comparisonText,
    required this.selectedBlockchain,
    required this.transactionSize,
    required this.transactionAmount,
  }) : super(key: key);

  static Map<String, double> calculateBitcoinImpact({
    required double networkHashrateTHs,
    required double minerEfficiencyJPerTH,
    required int transactionsPerDay,
    required double carbonIntensityGPerKWh,
  }) {
    // Calculate network energy use per day
    double networkEnergyJoules = networkHashrateTHs * minerEfficiencyJPerTH * 1e12; // TH/s * J/TH * seconds/day
    double networkEnergyKWh = networkEnergyJoules / 3.6e6; // Convert Joules to kWh
    double energyPerTransactionKWh = networkEnergyKWh / transactionsPerDay;

    double carbonPerTransactionG = energyPerTransactionKWh * carbonIntensityGPerKWh;

    return {
      'energyKWh': energyPerTransactionKWh, // Keep this in kWh
      'carbonKg': carbonPerTransactionG / 1000,
      'energyWh': energyPerTransactionKWh * 1000, // Added Wh for consistency with class property
    };
  }

  String getCreativeComparison(double emissionInKg) {
    List<String> options = [];

    // Ensure emissionInKg is used correctly based on carbonEmission's actual unit
    // If carbonEmission is truly in Tonnes as per comment, convert it here to kg.
    // Assuming 'carbonEmission' property is actually in kg for the comparisons based on its usage
    // If carbonEmission is in Tonnes, change `double emissionInKg = carbonEmission;` to `double emissionInKg = carbonEmission * 1000;`

    if (emissionInKg < 100) {
      options = [
        'Equivalent to charging 1,000 phones 📱',
        'Equivalent to 3 short airplane trips ✈️',
        'Equivalent to powering a small home for a day 🏠',
      ];
    } else if (emissionInKg < 10000) {
      options = [
        'Equivalent to driving 500 miles 🚗',
        'Equivalent to a cross-country flight 🛩️',
        'Equivalent to 50 washing machines running all day 👕',
      ];
    } else {
      options = [
        'Equivalent to powering an entire village for a week 🌍',
        'Equivalent to manufacturing 10,000 laptops 💻',
        'Equivalent to charging 1 million phones 📱',
      ];
    }

    final random = Random();
    return options[random.nextInt(options.length)];
  }

  // Modified formatNumber to handle decimal places
  String formatNumber(double value, {int? decimalPlaces}) {
    // This is for displaying the numbers in the info cards.
    // Use NumberFormat.compact for larger numbers, regular format for small
    if (value.abs() >= 1000) { // Use absolute value to handle negative numbers too
      final formatter = NumberFormat.compact(locale: "en_US");
      return formatter.format(value);
    } else {
      // For smaller numbers, control decimal places more strictly.
      // If decimalPlaces is provided, use it. Otherwise, default to 2.
      // For very small numbers that round to 0, show more precision.
      if (value.abs() > 0 && value.abs() < 0.01 && decimalPlaces == null) {
        return NumberFormat('0.000000', 'en_US').format(value); // More precision for tiny values
      }
      final formatter = NumberFormat('0.${'0' * (decimalPlaces ?? 2)}', 'en_US');
      return formatter.format(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the number of decimal places for carbon emission display
    int emissionDecimalPlaces = 2; // Default for most cases
    if (selectedBlockchain.toLowerCase() == 'solana' ||
        selectedBlockchain.toLowerCase() == 'algorand' ||
        selectedBlockchain.toLowerCase() == 'polkadot') {
      emissionDecimalPlaces = 6; // More precision for very low emission chains
    }
    // Note: If carbonEmission is in Tonnes, convert it to kg for display if needed:
    // double displayCarbonEmission = carbonEmission * 1000; // If carbonEmission is in Tonnes

    return Scaffold(
      backgroundColor: const Color(0xF50E0F10), // Dark background, consistent with other screens
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInfoCard('Carbon Emission', carbonEmission, 'kg CO₂', emissionDecimalPlaces), // Pass decimal places
                    const SizedBox(height: 16),
                    _buildInfoCard('Energy Consumed', energyConsumed, 'Wh', 2), // Fixed 2 decimal places for energy
                    const SizedBox(height: 16),
                    _buildComparisonCard(getCreativeComparison(carbonEmission)), // Pass carbonEmission in kg
                    const SizedBox(height: 24),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 32, color: Colors.white), // Close icon in white
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modified _buildInfoCard to accept decimalPlaces
  Widget _buildInfoCard(String title, double value, String unit, int decimalPlaces) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F23), // Darker grey for card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)), // Subtle shadow
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white), // White text
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              formatNumber(value, decimalPlaces: decimalPlaces), // Use formatNumber with decimalPlaces
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 36, color: Colors.white), // White text
            ),
            const SizedBox(height: 6),
            Text(
              unit,
              style: const TextStyle(fontSize: 20, color: Colors.white70), // Slightly less prominent white
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonCard(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F23), // Darker grey for card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)), // Subtle shadow
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
        child: Column(
          children: [
            Text(
              'Comparison with\nEveryday Activities',
              semanticsLabel: getCreativeComparison(carbonEmission), // Still pass carbonEmission in kg
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white), // White text
            ),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.white70), // Slightly less prominent white
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // Determine the network display name for CarbonOffsetScreen
    String networkDisplayName;
    switch (selectedBlockchain.toLowerCase()) {
      case 'ethereum':
        networkDisplayName = 'ETH';
        break;
      case 'polygon':
        networkDisplayName = 'MATIC';
        break;
      case 'bitcoin':
        networkDisplayName = 'BTC';
        break;
      case 'binance smart chain':
      case 'bsc': // Include common abbreviation
        networkDisplayName = 'BNB';
        break;
      case 'solana':
        networkDisplayName = 'SOL';
        break;
      case 'algorand':
        networkDisplayName = 'ALGO'; // Corrected mapping
        break;
      case 'polkadot':
        networkDisplayName = 'DOT';
        break;
    // Add other blockchains here as needed
      default:
        networkDisplayName = 'Crypto'; // Default if blockchain isn't explicitly mapped
        break;
    }


    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GreenerAlternativesPopupScreen(
                selectedBlockchain: selectedBlockchain, // string like 'bitcoin'
                transactionSize: transactionSize,
                transactionAmount: transactionAmount,
                originalCarbonEmission: carbonEmission,   // Pass the calculated emission from EmissionsPopupScreen
                originalEnergyConsumed: energyConsumed,

              )),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F1F23), // Already dark, good
            foregroundColor: Colors.white, // Text color is white, good
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            minimumSize: const Size(250, 48),
          ),
          child: const Text('View Greener Alternatives 🍃'),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarbonOffsetScreen(
                  emissionAmount: carbonEmission, // Pass the carbon emission amount (as kg)
                  selectedNetwork: networkDisplayName, // Pass the dynamically determined network name
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1F1F23), // Already dark, good
            foregroundColor: Colors.white, // Text color is white, good
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            minimumSize: const Size(250, 48),
          ),
          child: const Text('Offset Carbon Footprint 💨'),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.share_rounded, color: Colors.white, size: 28), // White icon
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.transparent,
                  builder: (context) => SharePopup( // This will now show the image directly
                    carbonEmission: carbonEmission,
                    energyConsumed: energyConsumed,
                  ),
                );
              },
            ),
            const SizedBox(width: 24),
            IconButton(
              icon: const Icon(Icons.bookmark, color: Colors.white), // White icon
              onPressed: () async {
                await FirebaseFirestore.instance.collection('bookmarks').add({
                  'carbonEmission': carbonEmission,
                  'energyConsumed': energyConsumed,
                  'comparisonText': getCreativeComparison(carbonEmission),
                  'selectedBlockchain': selectedBlockchain, // Also bookmark the blockchain
                  'transactionSize': transactionSize,
                  'transactionAmount': transactionAmount,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                // SnackBar usually adapts to theme, no explicit text color needed here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Report bookmarked!')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}


// Modified SharePopup to show the image directly
class SharePopup extends StatelessWidget {
  final double carbonEmission;
  final double energyConsumed;

  const SharePopup({
    Key? key,
    required this.carbonEmission,
    required this.energyConsumed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16), bottom: Radius.circular(16)),
      child: Container(
        // Set a dark background for the modal itself
        color: const Color(0xF50E0F10), // Consistent dark background
        child: Column(
          mainAxisSize: MainAxisSize.min, // Takes minimum vertical space
          children: [
            // Display the image of the iOS share sheet
            Image.asset(
              'assets/share.png', // Path to your image file
              fit: BoxFit.fitWidth,
              height: 400, // Ensure the image fits the width of the modal
              // You might need to adjust height or add a fixed height if the image
              // is too tall and causes overflow issues, e.g., height: 400
            ),
            // You might want to add a close button here within the modal too.
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //     onPressed: () => Navigator.pop(context),
            //     child: const Text('Close'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}