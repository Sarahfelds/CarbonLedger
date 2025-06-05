import 'package:flutter/material.dart';
import 'package:greenchain_3/screens/EmissionsPopupScreen.dart';
import '../bitcoin_service.dart';
import '../ethereum_service.dart';
import '../solana_service.dart';
import '../algorand_service.dart';
import '../polkadot_service.dart';

class CalculateScreen extends StatefulWidget {
  @override
  _CalculateScreenState createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  String _selectedBlockchain = 'Bitcoin';
  String _selectedTransactionType = 'Send Cryptocurrency';
  double _transactionSize = 0.5;
  final TextEditingController _amountController = TextEditingController();

  final List<String> blockchainNetworks = [
    'Bitcoin',
    'Ethereum',
    'Solana',
    'Algorand',
    'Polkadot',
  ];

  final List<String> transactionTypes = [
    'Send Cryptocurrency',
    'Use a Smart Contract',
    'Mint an NFT',
    'Buy/Sell an NFT',
    'DeFi Transaction',
  ];

  final Map<String, String> blockchainUnits = {
    'Bitcoin': 'BTC',
    'Ethereum': 'ETH',
    'Solana': 'SOL',
    'Algorand': 'ALGO',
    'Polkadot': 'DOT',
  };

  @override
  void initState() {
    super.initState();
    _updateAmountController();
  }

  void _updateAmountController() {
    String unit = blockchainUnits[_selectedBlockchain] ?? '';
    _amountController.text = '0.5 $unit';
  }

  Future<Map<String, dynamic>> _fetchDataForBlockchain(String blockchain) async {
    try {
      Map<String, double>? data;
      switch (blockchain) {
        case 'Ethereum':
          print('Fetching Ethereum data...');
          data = await EthereumService().getBlockchainData();
          break;
        case 'Solana':
          print('Fetching Solana data...');
          data = await SolanaService().getBlockchainData();
          break;
        case 'Algorand':
          print('Fetching Algorand data...');
          data = await AlgorandService().getBlockchainData();
          break;
        case 'Polkadot':
          print('Fetching Polkadot data...');
          data = await PolkadotService().getBlockchainData();
          break;
        case 'Bitcoin':
        default:
          return getSmartBitcoinData();
      }
      if (data == null) {
        throw Exception('Data not found for $blockchain');
      }
      return Map<String, dynamic>.from(data);
    } catch (e, stacktrace) {
      print('❌ Error fetching data for $blockchain: $e');
      print(stacktrace);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1B),
      appBar: AppBar(
        title: const Text('Carbon Emissions Estimation', style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF17191B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Blockchain Network', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: _selectedBlockchain,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  items: blockchainNetworks.map((network) {
                    return DropdownMenuItem<String>(
                      value: network,
                      child: Text(network),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedBlockchain = newValue!;
                      _updateAmountController();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Transaction Type', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: _selectedTransactionType,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  style: const TextStyle(color: Colors.white),
                  items: transactionTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTransactionType = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text('Transaction Size', style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _amountController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Colors.white38)),
                onChanged: (value) {
                  final numericValue = value.split(' ').first;
                  setState(() {
                    _transactionSize = double.tryParse(numericValue) ?? 0.0;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final data = await _fetchDataForBlockchain(_selectedBlockchain);
                    print('Fetched data: $data');

                    double carbonKg;
                    double energyKWh;

                    if (_selectedBlockchain == 'Bitcoin') {
                      final double hashrate = (data['hashrateTHs'] as num).toDouble();
                      final int transactions = (data['transactions'] as num).toInt();
                      final double priceUSD = (data['priceUSD'] as num).toDouble();

                      double minerEfficiency = 30;
                      double carbonIntensity = 475;

                      final result = EmissionsPopupScreen.calculateBitcoinImpact(
                        networkHashrateTHs: hashrate,
                        minerEfficiencyJPerTH: minerEfficiency,
                        transactionsPerDay: transactions,
                        carbonIntensityGPerKWh: carbonIntensity,
                      );

                      double amountInUSD = _transactionSize * priceUSD;
                      double avgTransactionValueUSD = 100.0;
                      double scaleFactor = amountInUSD / avgTransactionValueUSD;
                      carbonKg = (result['carbonKg'] ?? 0.0) * scaleFactor;
                      energyKWh = (result['energyKWh'] ?? 0.0) * scaleFactor;
                    } else {
                      final double baseCarbon = (data['carbonKg'] as num).toDouble();
                      final double baseEnergy = (data['energyKWh'] as num).toDouble();
                      double priceUSD;
                      if (data.containsKey('priceUSD') && data['priceUSD'] != null) {
                        priceUSD = (data['priceUSD'] as num).toDouble();
                      } else {
                        priceUSD = 100.0;
                      }
                      double amountInUSD = _transactionSize * priceUSD;
                      double avgTransactionValueUSD = 100.0;
                      double scaleFactor = amountInUSD / avgTransactionValueUSD;
                      carbonKg = baseCarbon * scaleFactor;
                      energyKWh = baseEnergy * scaleFactor;
                    }

                    // Pass the calculated carbon and energy as the "original" values
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmissionsPopupScreen(
                          carbonEmission: carbonKg,
                          energyConsumed: energyKWh,
                          comparisonText: '',
                          selectedBlockchain: _selectedBlockchain.toLowerCase(),
                          transactionSize: _transactionSize,
                          transactionAmount: _transactionSize,
                        ),
                      ),
                    );
                  } catch (e) {
                    print('Calculation error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error fetching data or calculating emissions')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[900],
                  padding: const EdgeInsets.symmetric(horizontal: 160, vertical: 22),
                ),
                child: const Text('Calculate', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Image.asset('assets/calc.png', width: 190, height: 190, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
