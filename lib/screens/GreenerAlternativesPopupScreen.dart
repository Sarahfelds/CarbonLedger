import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'migrate_success_screen.dart';
import 'dart:math'; // For random number generation
import 'package:intl/intl.dart'; // Import for NumberFormat

class GreenerAlternativesPopupScreen extends StatefulWidget {
  final String selectedBlockchain;
  final double transactionSize;
  final double transactionAmount;
  final double originalCarbonEmission;
  final double originalEnergyConsumed;

  const GreenerAlternativesPopupScreen({
    Key? key,
    required this.selectedBlockchain,
    required this.transactionSize,
    required this.transactionAmount,
    required this.originalCarbonEmission,
    required this.originalEnergyConsumed,
  }) : super(key: key);

  @override
  _GreenerAlternativesPopupScreenState createState() =>
      _GreenerAlternativesPopupScreenState();
}

class _GreenerAlternativesPopupScreenState
    extends State<GreenerAlternativesPopupScreen> {
  bool _loading = true;
  Map<String, Map<String, double>> _blockchainData = {};
  String? _suggestedGreenerAlternative;
  String? _alternativeReason;
  late double _calculatedOriginalProfit;
  late double _calculatedAlternativeProfit;

  @override
  void initState() {
    super.initState();
    _fetchFirestoreDataAndFindAlternative();
  }

  Future<void> _fetchFirestoreDataAndFindAlternative() async {
    await _fetchFirestoreData();
    _findGreenerAlternative();
  }

  Future<void> _fetchFirestoreData() async {
    try {
      final liveDataCollection =
      FirebaseFirestore.instance.collection('liveData');

      final docs = await Future.wait([
        liveDataCollection.doc('bitcoin').get(),
        liveDataCollection.doc('ethereum').get(),
        liveDataCollection.doc('solana').get(),
        liveDataCollection.doc('algorand').get(),
        liveDataCollection.doc('polkadot').get(),
        // Add other blockchains you might have in Firestore
      ]);

      final keys = ['bitcoin', 'ethereum', 'solana', 'algorand', 'polkadot'];
      Map<String, Map<String, double>> tempData = {};

      for (int i = 0; i < docs.length; i++) {
        final doc = docs[i];
        if (doc.exists) {
          final data = doc.data()!;
          tempData[keys[i]] = {
            'carbonKg': (data['carbonKg'] ?? 0.0).toDouble(),
            'energyKWh': (data['energyKWh'] ?? 0.0).toDouble(),
            'feeUSD': (data['feeUSD'] ?? 0.0).toDouble(),
            'profitUSD': (data['profitUSD'] ?? 0.0).toDouble(),
            'priceUSD': (data['priceUSD'] ?? 0.0).toDouble(), // Crucial for conversion
            'transactions': (data['transactions'] ?? 0.0).toDouble(),
          };
        }
      }

      setState(() {
        _blockchainData = tempData;
      });
    } catch (e) {
      print('❌ Error fetching Firestore data: $e');
    }
  }

  void _findGreenerAlternative() {
    String selected = widget.selectedBlockchain;
    double originalCarbon = widget.originalCarbonEmission;
    double originalEnergy = widget.originalEnergyConsumed;
    double originalFee = _blockchainData[selected]?['feeUSD'] ?? 0.0;

    // Use transactionAmount (which should be the USD value) for profit calculation
    _calculatedOriginalProfit =
        (widget.transactionAmount * (0.01 + Random().nextDouble() * 0.05)) - originalFee;
    _calculatedOriginalProfit = max(0.01, _calculatedOriginalProfit);

    String? bestAlternative;

    Map<String, Map<String, double>> potentialAlternatives = {};
    _blockchainData.forEach((key, value) {
      if (key == selected) return;

      double carbon = value['carbonKg'] ?? double.infinity;
      double energy = value['energyKWh'] ?? double.infinity;

      if (carbon < originalCarbon && energy < originalEnergy && carbon != 0 && energy != 0) {
        potentialAlternatives[key] = value;
      }
    });

    if (potentialAlternatives.isNotEmpty) {
      double currentBestScore = double.infinity;

      potentialAlternatives.forEach((blockchain, data) {
        double carbon = data['carbonKg'] ?? double.infinity;
        double energy = data['energyKWh'] ?? double.infinity;
        double fee = data['feeUSD'] ?? 0.0;
        double baseProfit = data['profitUSD'] ?? 0.0;

        double carbonWeight = 0.4;
        double energyWeight = 0.3;
        double feeWeight = 0.2;
        double profitWeight = 0.1;

        double score = (carbon * carbonWeight) +
            (energy * energyWeight) +
            (fee * feeWeight) -
            (baseProfit * profitWeight);

        if (score < currentBestScore) {
          currentBestScore = score;
          bestAlternative = blockchain;
        }
      });
    }

    if (bestAlternative != null) {
      double alternativeFee = _blockchainData[bestAlternative]!['feeUSD'] ?? 0.0;
      // Use transactionAmount (USD value) for alternative profit calculation
      _calculatedAlternativeProfit = (widget.transactionAmount * (0.05 + Random().nextDouble() * 0.10)) - alternativeFee;
      _calculatedAlternativeProfit = max(0.01, _calculatedAlternativeProfit);
    } else {
      _calculatedAlternativeProfit = 0.0;
    }


    setState(() {
      _suggestedGreenerAlternative = bestAlternative;
      if (bestAlternative != null) {
        _alternativeReason =
        "Lower carbon and energy consumption and potentially higher profit than ${selected.toUpperCase()}";
      } else {
        _alternativeReason = null;
      }
      _loading = false;
    });
  }

  String _formatValue(double value, {int? defaultDecimalPlaces, bool isCarbon = false, bool isCryptoAmount = false}) {
    if (value == 0) return '0';

    if (isCarbon && value.abs() < 0.1) {
      return NumberFormat('0.000000', 'en_US').format(value);
    }

    if (isCryptoAmount && value.abs() < 1.0) {
      return NumberFormat('0.00000000', 'en_US').format(value);
    }

    if (value.abs() >= 1000) {
      final formatter = NumberFormat.compact(locale: "en_US");
      return formatter.format(value);
    } else {
      final int actualDecimalPlaces = defaultDecimalPlaces ?? 2;
      final formatter = NumberFormat('0.${'0' * actualDecimalPlaces}', 'en_US');
      return formatter.format(value);
    }
  }


  @override
  Widget build(BuildContext context) {
    final greenerAlternative = _suggestedGreenerAlternative;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text('Greener Alternatives',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : _blockchainData.isEmpty
          ? const Center(
          child: Text('No data available to compare.',
              style: TextStyle(color: Colors.white)))
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/GA.png',
                  height: 150, fit: BoxFit.contain),
              const SizedBox(height: 30),
              if (greenerAlternative != null) ...[
                _buildSuggestionCard(
                  widget.selectedBlockchain,
                  widget.originalCarbonEmission,
                  widget.originalEnergyConsumed,
                  _blockchainData[widget.selectedBlockchain]?['feeUSD'] ?? 0.0,
                  _calculatedOriginalProfit,
                  greenerAlternative,
                  _blockchainData[greenerAlternative]!['carbonKg'] ?? 0.0,
                  _blockchainData[greenerAlternative]!['energyKWh'] ?? 0.0,
                  _blockchainData[greenerAlternative]!['feeUSD'] ?? 0.0,
                  _calculatedAlternativeProfit,
                ),
                if (_alternativeReason != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    "Reason: $_alternativeReason",
                    style: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[700],
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.autorenew,
                      color: Colors.white),
                  label: const Text(
                    'Migrate to Green Option',
                    style:
                    TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    if (_blockchainData.containsKey(greenerAlternative)) {
                      // Get the USD value of the original transaction
                      // Assumes widget.transactionSize is the amount of the original coin (e.g., 0.5 for 0.5 BTC)
                      // and widget.selectedBlockchain corresponds to its price
                      double originalCoinPrice = _blockchainData[widget.selectedBlockchain.toLowerCase()]?['priceUSD'] ?? 1.0;
                      double originalTransactionUSDValue = widget.transactionSize * originalCoinPrice;


                      final greenerCoinPrice = _blockchainData[greenerAlternative]?['priceUSD'] ?? 1.0;

                      double convertedAmount;
                      if (greenerCoinPrice != 0) {
                        convertedAmount = originalTransactionUSDValue / greenerCoinPrice;
                      } else {
                        convertedAmount = originalTransactionUSDValue; // Fallback if price is 0
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MigrateSuccessScreen(
                            greenerCoin: greenerAlternative.toUpperCase(),
                            convertedAmount: convertedAmount,
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
              ] else ...[
                Center(
                  child: Text(
                    'No significantly greener alternative found for ${widget.selectedBlockchain}.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 16),
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(
      String selected,
      double originalCarbon,
      double originalEnergy,
      double originalFee,
      double originalProfit,
      String greener,
      double greenerCarbon,
      double greenerEnergy,
      double greenerFee,
      double greenerProfit
      ) {
    final selectedDisplayData = {
      'carbonKg': originalCarbon,
      'energyKWh': originalEnergy,
      'feeUSD': originalFee,
      'profitUSD': originalProfit,
    };

    final greenerDisplayData = {
      'carbonKg': greenerCarbon,
      'energyKWh': greenerEnergy,
      'feeUSD': greenerFee,
      'profitUSD': greenerProfit,
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.green.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.greenAccent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Suggested Greener Alternative',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildBlockchainCard(selected, selectedDisplayData,
                    isSelected: true),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_forward_rounded,
                    size: 32, color: Colors.white70),
              ),
              Expanded(child: _buildBlockchainCard(greener, greenerDisplayData)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBlockchainCard(String name, Map<String, double> data,
      {bool isSelected = false}) {
    final textColor =
    isSelected ? Colors.black87 : Colors.grey.shade800;
    final cardColor =
    isSelected ? Colors.white : Colors.grey.shade200;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(name.toUpperCase(),
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 12),
          _metricRow('Carbon',
              '${_formatValue(data['carbonKg'] ?? 0.0, isCarbon: true)} kg CO₂', textColor),
          _metricRow('Energy',
              '${_formatValue(data['energyKWh'] ?? 0.0)} kWh', textColor),
          _metricRow(
              'Fee', '\$${_formatValue(data['feeUSD'] ?? 0.0, defaultDecimalPlaces: 4)}', textColor),
          _metricRow('Profit',
              '\$${_formatValue(data['profitUSD'] ?? 0.0, defaultDecimalPlaces: 2)}', textColor),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.w600)),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(value, style: TextStyle(color: textColor)),
            ),
          ),
        ],
      ),
    );
  }
}