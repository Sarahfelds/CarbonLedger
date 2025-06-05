import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getSmartBitcoinData() async {
  try {
    // Fetch Bitcoin hashrate (in GH/s) and transaction count
    final hashrateResponse = await http.get(Uri.parse('https://api.blockchain.info/q/hashrate'));
    final txCountResponse = await http.get(Uri.parse('https://api.blockchain.info/q/24hrtransactioncount'));

    if (hashrateResponse.statusCode != 200 || txCountResponse.statusCode != 200) {
      throw Exception('Failed to fetch hashrate or transaction count');
    }

    double hashrateGHs = double.parse(hashrateResponse.body);
    double hashrateTHs = hashrateGHs / 1000.0;
    int transactions = int.parse(txCountResponse.body);

    // Fetch Bitcoin price in USD from CoinGecko
    final priceResponse = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd'));

    if (priceResponse.statusCode != 200) {
      throw Exception('Failed to fetch Bitcoin price');
    }

    final priceData = jsonDecode(priceResponse.body);
    final priceUSD = priceData['bitcoin']?['usd']?.toDouble() ?? 0.0;

    return {
      'hashrateTHs': hashrateTHs,
      'transactions': transactions,
      'priceUSD': priceUSD,
    };
  } catch (e) {
    print('Error in getSmartBitcoinData: $e');
    throw Exception('Failed to fetch live Bitcoin data');
  }
}
