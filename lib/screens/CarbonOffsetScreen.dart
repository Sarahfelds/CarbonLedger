import 'package:flutter/material.dart';
import 'CreditCardPaymentScreen.dart';
import 'CreditCardPaymentScreen.dart';

class CarbonOffsetScreen extends StatelessWidget {
  final double emissionAmount; // This should be in kg CO₂
  final String selectedNetwork;

  const CarbonOffsetScreen({
    Key? key,
    required this.emissionAmount,
    this.selectedNetwork = 'ETH',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- Realistic Example Conversion Logic ---
    // These are EXAMPLE rates. You MUST replace them with actual, up-to-date
    // rates for carbon offsetting and cryptocurrency values.

    // 1. Fiat (Credit Card) Offsetting
    // Assume a rate of $10 per 1000 kg (1 tonne) of CO₂
    // Or, a more common rate: $15 - $30 per tonne of CO2
    // Let's use a flat rate per kg for simplicity.
    const double dollarCostPerKgCO2 = 0.015; // Example: $0.015 per kg CO₂ ($15 per tonne)
    final double dollarAmount = emissionAmount * dollarCostPerKgCO2;

    // Assume 1 tree offsets roughly 10-20 kg CO2 per year over its lifetime.
    // For simplicity, let's say $1 plants X trees.
    // If $15 offsets 1 tonne (1000kg), and 1 tree offsets 20kg over its life,
    // then 1 tonne requires 1000/20 = 50 trees.
    // So, $15 plants 50 trees, meaning $0.3 per tree.
    const double treesPerDollar = 3.0; // Example: 3 trees for every dollar donated
    final int treesToPlant = (dollarAmount * treesPerDollar).round();

    // 2. Crypto Offsetting
    // Carbon credits are often traded in tonnes.
    // Current market price for voluntary carbon credits (e.g., CORSIA-eligible)
    // can range widely, often $3 to $20+ per tonne depending on project type.
    // Let's assume a fixed price for carbon credits (in tonnes)
    const double carbonCreditPricePerTonneUSD = 15.0; // Example: $15 per tonne of carbon credit

    // Convert emission (kg) to tonnes for carbon credits
    final double carbonCreditsTons = emissionAmount / 1000;

    // Calculate total USD cost for carbon credits
    final double totalCarbonCreditUSD = carbonCreditsTons * carbonCreditPricePerTonneUSD;

    // Assume a conversion rate from USD to selected crypto.
    // You would typically fetch this from a live API. For now, use placeholders.
    double cryptoPriceInUSD; // This would come from an API
    if (selectedNetwork == 'ETH') {
      cryptoPriceInUSD = 3500.0; // Example ETH price in USD
    } else if (selectedNetwork == 'BTC') {
      cryptoPriceInUSD = 70000.0; // Example BTC price in USD
    } else if (selectedNetwork == 'MATIC') {
      cryptoPriceInUSD = 0.70; // Example MATIC price in USD
    } else if (selectedNetwork == 'BNB') {
      cryptoPriceInUSD = 600.0; // Example BNB price in USD
    } else {
      cryptoPriceInUSD = 1.0; // Fallback, e.g., for stablecoins or unmapped networks
    }

    final double cryptoOffsetAmount = totalCarbonCreditUSD / cryptoPriceInUSD;
    // --- End of Realistic Example Conversion Logic ---


    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1B), // Deep dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        title: const Text(
          'Carbon Offsetting',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Image.asset(
              'assets/safe.png',
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Text(
              'Take action to “balance” pollution by\nsupporting green projects.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 44),

            // Option 1: Credit Card
            const Text(
              '💳 1. Offset via Payment (Credit Card / Fiat Money)',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            GlowCard(
              text:
              '“Your transaction emitted ${emissionAmount.toStringAsFixed(2)} kg CO₂. Donate \$${dollarAmount.toStringAsFixed(2)} to plant $treesToPlant trees and offset this footprint.”',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CreditCardPaymentScreen()));
              },
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CreditCardPaymentScreen()));
              },
              child: Text(
                '[Pay with Credit/Debit Card]',
                style: TextStyle(
                  color: Colors.blue[200],
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 66),

            // Option 2: Crypto
            const Text(
              '₿ 2. Offset via Crypto Transaction',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            GlowCard(
              text:
              '“Buy ${carbonCreditsTons.toStringAsFixed(2)} tons of carbon credits for ${cryptoOffsetAmount.toStringAsFixed(4)} $selectedNetwork to offset this transaction.”',
              // Increased decimal places for crypto amount to show smaller values
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CryptoPayment()),
                );
              },
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CryptoPayment()));
              },
              child: Text(
                '[Offset with Crypto]',
                style: TextStyle(
                  color: Colors.blue[200],
                  decoration: TextDecoration.underline,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlowCard extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GlowCard({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  _GlowCardState createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.cyan[800],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.cyan.withOpacity(0.4),
              width: 0.8,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: Colors.cyan.withOpacity(0.6),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: const Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}