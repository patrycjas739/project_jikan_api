import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:project_jikan_api/models/anime_model.dart';
import '../models/anime_details_model.dart';
import '../services/api_service.dart';

class DetailsScreen extends StatefulWidget {
  final int animeId;
  final String animeTitle;

  const DetailsScreen({
    super.key,
    required this.animeId,
    required this.animeTitle
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<AnimeDetails> _futureAnimeDetails;
  late Box _favoritesBox;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _futureAnimeDetails = ApiService().fetchAnimeDetails(widget.animeId);

    _favoritesBox = Hive.box('favoritesBox');
    _isFavorite = _favoritesBox.containsKey(widget.animeId);
  }

  void _toggleFavorite(){
    if (_isFavorite) {
      _favoritesBox.delete(widget.animeId);
    } else {
      _favoritesBox.put(widget.animeId, widget.animeTitle);
    }

    setState(() {
      _isFavorite = !_isFavorite;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.animeTitle),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: FutureBuilder<AnimeDetails>(
       future: _futureAnimeDetails,
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
         } else if (snapshot.hasError) {
           return Center(child: Text('${snapshot.error}', style: const TextStyle(color: Colors.red)));
         } else if (!snapshot.hasData) {
           return const Center(child: Text('No data available.'));
         }

         final details = snapshot.data!;
         return SingleChildScrollView(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Center(
                 child: Image.network(
                   details.imageUrl,
                   height: 300,
                   fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size:100),
                 ),
               ),
               const SizedBox(height: 16),
               Text(
                 details.title,
                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
               ),
               const SizedBox(height: 8),
               Row(
                 children: [
                   const Icon(Icons.star, color: Colors.amber),
                   Text(' ${details.score} / 10', style: const TextStyle(fontSize: 18)),
                   const SizedBox(width: 20),
                   const Icon(Icons.tv, color: Colors.blue),
                   Text(' Episodes: ${details.episodes > 0 ? details.episodes : "Unknown"}', style: const TextStyle(fontSize: 18)),
                 ],
               ),
               const SizedBox(height: 16),
               const Text(
                 'Synopsis:',
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
               ),
               const SizedBox(height: 8),
               Text(
                 details.synopsis,
                 style: const TextStyle(fontSize: 16),
               ),
             ],
           ),
         );
       },
      ),
    );
  }
}