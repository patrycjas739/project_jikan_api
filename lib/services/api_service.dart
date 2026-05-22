import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  Future<List<Anime>> fetchTopAnime() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/top/anime'));
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        final List animeList = data['data'];
        return animeList.map((json) => Anime.fromJson(json)).toList();
    } else {
        throw Exception('Błąd serwera API (Kod: ${response.statusCode}');
    }
    } catch (e) {
      throw Exception('Nie udało się pobrać danych.');
    }
  }
}