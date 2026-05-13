import 'dart:convert';
import '../models/currency_transaction.dart';
import '../api/api_client.dart';

class CurrencyTransactionDAO {
  String _toApiDate(String date) {
    final parts = date.split('/');
    if (parts.length == 3) {
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    }
    return date;
  }

  String _fromApiDate(String date) {
    final parts = date.split('-');
    if (parts.length == 3) {
      return "${parts[2]}/${parts[1]}/${parts[0]}";
    }
    return date;
  }

  Future<int> insertTransaction(CurrencyTransaction transaction) async {
    try {
      final response = await ApiClient.post('/currency-transactions', {
        'amount': transaction.amount,
        'currency': transaction.currency,
        'amountBrl': transaction.amountBrl,
        'source': transaction.source,
        'date': _toApiDate(transaction.date),
        'vetRate': transaction.vetRate,
        'description': transaction.description,
        'photoPath': transaction.photoPath,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['id'] ?? 1;
      } else {
        print("Erro na API: ${response.body}");
        throw Exception("Erro: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao inserir transação na API: $e");
      throw e;
    }
  }

  Future<List<CurrencyTransaction>> getTransactionsByUser(int userId) async {
    try {
      final response = await ApiClient.get('/currency-transactions');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) {
          return CurrencyTransaction(
            id: e['id'],
            userId: userId,
            amount: e['amount']?.toDouble() ?? 0.0,
            currency: e['currency'],
            amountBrl: e['amountBrl']?.toDouble() ?? 0.0,
            source: e['source'],
            date: _fromApiDate(e['date']),
            vetRate: e['vetRate']?.toDouble() ?? 1.0,
            description: e['description'],
            photoPath: e['photoPath'],
          );
        }).toList();
      }
    } catch (e) {
      print("Erro ao buscar transações na API: $e");
    }
    return [];
  }

  Future<int> updateTransaction(CurrencyTransaction transaction) async {
    return 1;
  }

  Future<int> deleteTransaction(int id) async {
    try {
      final response = await ApiClient.delete('/currency-transactions/$id');
      if (response.statusCode == 204) return 1;
    } catch (e) {
      print("Erro ao excluir transação na API: $e");
    }
    return 0;
  }
}
