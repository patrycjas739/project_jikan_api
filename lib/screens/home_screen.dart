import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:project_jikan_api/screens/favorites_screen.dart';
import '../models/anime_model.dart';
import '../services/api_service.dart';
import 'details_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State <HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  late Future<List<Anime>> _futureAnime;

  @override
  void initState() {
    super.initState();
    _futureAnime = ApiService().fetchTopAnime();
  }
  @override
  Widget build(BuildContext context){
    final favoritesBox = Hive.box('favoritesBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Anime'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Anime>>(
        future: _futureAnime,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size:80, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text("No internet connection", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Check your internet connection and try again.', textAlign: TextAlign.center, style:TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          }
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No anime to display.'));
          }

          final animeList = snapshot.data!;
          return ListView.builder(
            itemCount: animeList.length,
            itemBuilder: (context, index) {
              final anime = animeList[index];
              final isFavorite = favoritesBox.containsKey(anime.id);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: Hero(
                    tag: 'anime-pic-${anime.id}',
                    child: Image.network(
                    anime.imageUrl,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                  ),
                  ),
                  title: Text(anime.title),
                  trailing: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     if (isFavorite) const Icon(Icons.favorite, color: Colors.red, size:20),
                     const SizedBox(width:8),
                     const Icon(Icons.arrow_forward_ios, size: 16),
                   ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          animeId: anime.id,
                          animeTitle: anime.title,
                        ),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}