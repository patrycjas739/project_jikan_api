import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';
import '../models/anime_details_model.dart';

class ApiService {
  static const String baseUrl = 'https://api.jikan.moe/v4';

  Future<List<Anime>> fetchTopAnime() async {
    try{
      final response = await http.get(Uri.parse('$baseUrl/top/anime'))
      .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200){
        final data = json.decode(response.body);
        final List animeList = data['data'];
        return animeList.map((json) => Anime.fromJson(json)).toList();
    } else {
        throw Exception('API server error (Code: ${response.statusCode}');
    }
    } catch (e) {
      throw Exception('Failed to fetch data. Check your internet connection.');
    }
  }

  Future<AnimeDetails> fetchAnimeDetails(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/anime/$id/full'))
      .timeout(const Duration(seconds:5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AnimeDetails.fromJson(data['data']);
      } else {
        throw Exception('API server error (Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch anime details.');
    }
  }
}