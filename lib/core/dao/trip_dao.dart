import 'dart:convert';
import '../models/trip.dart';
import '../api/api_client.dart';

class TripDAO {
  Future<int> insertTrip(Trip trip) async {
    try {
      final response = await ApiClient.post('/trips', {
        'title': trip.title,
        'startDate': trip.startDate,
        'endDate': trip.endDate,
        'coverType': trip.coverType,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return data['id'] ?? 1; // Retorna o ID gerado pelo backend
      }
    } catch (e) {
      print("Erro ao inserir viagem na API: $e");
    }
    return 0;
  }

  Future<List<Trip>> getTripsByUser(int userId) async {
    try {
      final response = await ApiClient.get('/trips');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((e) {
          return Trip(
            id: e['id'],
            userId: userId, // Backend gerencia o userId pelo JWT
            title: e['title'],
            startDate: e['startDate'],
            endDate: e['endDate'],
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
