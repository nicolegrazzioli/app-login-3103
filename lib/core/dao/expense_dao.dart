import 'dart:convert';
import '../models/expense.dart';
import '../api/api_client.dart';

class ExpenseDAO {
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

  Future<int> insertExpense(Expense expense) async {
    try {
      final response = await ApiClient.post('/expenses', {
        'tripId': expense.tripId,
        'title': expense.title,
        'amount': expense.amount,
        'currency': expense.currency,
        'category': expense.category,
        'date': _toApiDate(expense.date),
        'isAverageCost': expense.isAverageCost,
        'exchangeRate': expense.exchangeRate,
        'amountBrl': expense.amountBrl,
        'description': expense.description,
        'photoPath': expense.photoPath,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['id'] ?? 1;
      } else {
        print("Erro na API: ${response.body}");
        throw Exception("Erro: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao inserir gasto na API: $e");
      throw e;
    }
  }

  Future<List<Expense>> getExpensesByTrip(int tripId) async {
    try {
      final response = await ApiClient.get('/expenses/trip/$tripId');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) {
          return Expense(
            id: e['id'],
            tripId: e['tripId'],
            title: e['title'],
            amount: e['amount']?.toDouble() ?? 0.0,
            currency: e['currency'],
            category: e['category'],
            date: _fromApiDate(e['date']),
            isAverageCost: e['isAverageCost'] ?? false,
            exchangeRate: e['exchangeRate']?.toDouble() ?? 1.0,
            amountBrl: e['amountBrl']?.toDouble() ?? 0.0,
            description: e['description'],
            photoPath: e['photoPath'],
          );
        }).toList();
      }
    } catch (e) {
      print("Erro ao buscar gastos na API: $e");
    }
    return [];
  }

  Future<int> updateExpense(Expense expense) async {
    return 1;
  }

  Future<int> deleteExpense(int id) async {
    try {
      final response = await ApiClient.delete('/expenses/$id');
      if (response.statusCode == 204) return 1;
    } catch (e) {
      print("Erro ao excluir gasto na API: $e");
    }
    return 0;
  }
}
