import 'dart:convert';
import '../models/wallet.dart';
import '../api/api_client.dart';

class WalletDAO {
  Future<int> insertWallet(Wallet wallet) async {
    return 0; // Gerenciado automaticamente pelo backend
  }

  Future<List<Wallet>> getWalletsByUser(int userId) async {
    try {
      final response = await ApiClient.get('/wallets');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) {
          return Wallet(
            userId: userId,
            currency: e['currency'],
            balance: e['balance']?.toDouble() ?? 0.0,
            averageVet: e['averageVet']?.toDouble() ?? 0.0,
          );
        }).toList();
      }
    } catch (e) {
      print("Erro ao buscar carteiras na API: $e");
    }
    return [];
  }

  Future<Wallet?> getWallet(int userId, String currency) async {
    return null; // Apenas usado internamente, backend cuida
  }

  Future<int> updateWallet(Wallet wallet) async {
    return 1; // Gerenciado pelo backend
  }

  Future<int> deleteWallet(int userId, String currency) async {
    return 1; // Gerenciado pelo backend
  }
}
