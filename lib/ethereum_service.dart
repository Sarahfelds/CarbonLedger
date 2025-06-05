import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class EthereumService {
  final _doc = FirebaseFirestore.instance.collection('liveData').doc('ethereum');

  Future<Map<String, double>?> getBlockchainData() async {
    try {
      // Get static environmental data from Firestore
      final snapshot = await _doc.get();
      if (!snapshot.exists) return null;
      final data = snapshot.data()!;

      // Fetch live price from CoinGecko
      final priceUSD = await _fetchLiveEthereumPrice();

      return {
        'carbonKg': (data['carbonKg'] ?? 0).toDouble(),
        'energyKWh': (data['energyKWh'] ?? 0).toDouble(),
        'feeUSD': (data['feeUSD'] ?? 0).toDouble(),
        'profitUSD': (data['profitUSD'] ?? 0).toDouble(),
        'transactions': (data['transactions'] ?? 0).toDouble(),
        'priceUSD': priceUSD,
      };
    } catch (e) {
      print('❌ Error in EthereumService: $e');
      return null;
    }
  }

  Future<double> _fetchLiveEthereumPrice() async {
    const url =
        'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['ethereum']['usd'] as num).toDouble();
    } else {
      throw Exception('Failed to fetch Ethereum price from CoinGecko');
    }
  }
}
