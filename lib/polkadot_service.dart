import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PolkadotService {
  final _doc = FirebaseFirestore.instance.collection('liveData').doc('polkadot');

  Future<Map<String, double>?> getBlockchainData() async {
    try {
      final snapshot = await _doc.get();
      if (!snapshot.exists) return null;

      final data = snapshot.data()!;
      final price = await _fetchPriceUSD(); // Live price

      return {
        'carbonKg': (data['carbonKg'] ?? 0).toDouble(),
        'energyKWh': (data['energyKWh'] ?? 0).toDouble(),
        'priceUSD': price,
        'transactions': (data['transactions'] ?? 0).toDouble(),
        'feeUSD': (data['feeUSD'] ?? 0).toDouble(),
        'profitUSD': (data['profitUSD'] ?? 0).toDouble(),
      };
    } catch (e) {
      print('❌ Error fetching Polkadot data: $e');
      return null;
    }
  }

  Future<double> _fetchPriceUSD() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=polkadot&vs_currencies=usd'));
      final body = json.decode(response.body);
      return (body['polkadot']['usd'] ?? 0).toDouble();
    } catch (e) {
      print('❌ Error fetching Polkadot price: $e');
      return 0;
    }
  }
}
