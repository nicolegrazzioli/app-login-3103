import 'dart:convert';
import '../models/trip.dart';
import '../api/api_client.dart';

class TripDAO {
  String _toApiDate(String date) {
    // dd/MM/yyyy -> yyyy-MM-dd
    final parts = date.split('/');
    if (parts.length == 3) {
      return "${parts[2]}-${parts[1]}-${parts[0]}";
    }
    return date;
  }

  String _fromApiDate(String date) {
    // yyyy-MM-dd -> dd/MM/yyyy
    final parts = date.split('-');
    if (parts.length == 3) {
      return "${parts[2]}/${parts[1]}/${parts[0]}";
    }
    return date;
  }

  Future<int> insertTrip(Trip trip) async {
    try {
      final response = await ApiClient.post('/trips', {
        'title': trip.title,
        'startDate': _toApiDate(trip.startDate),
        'endDate': trip.endDate != null ? _toApiDate(trip.endDate!) : null,
        'coverType': trip.coverType,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['id'] ?? 1;
      } else {
        print("Erro na API (Status ${response.statusCode}): ${response.body}");
        throw Exception("Erro ao criar viagem. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro ao inserir viagem na API: $e");
      throw e;
    }
  }

  Future<List<Trip>> getTripsByUser(int userId) async {
    try {
      final response = await ApiClient.get('/trips');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) {
          return Trip(
            id: e['id'],
            userId: userId,
            title: e['title'],
            startDate: _fromApiDate(e['startDate']),
            endDate: e['endDate'] != null ? _fromApiDate(e['endDate']) : null,
            coverType: e['coverType'],
          );
        }).toList();
      }
    } catch (e) {
      print("Erro ao buscar viagens na API: $e");
    }
    return [];
  }

  Future<int> updateTrip(Trip trip) async {
    // Para simplificar agora
    return 1;
  }

  Future<int> deleteTrip(int id) async {
    try {
      final response = await ApiClient.delete('/trips/$id');
      if (response.statusCode == 204) return 1;
    } catch (e) {
      print("Erro ao excluir viagem na API: $e");
    }
    return 0;
  }
}
