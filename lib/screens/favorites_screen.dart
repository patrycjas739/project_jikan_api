import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoriteScreenState();
}
class _FavoriteScreenState extends State<FavoritesScreen> {
  late Box _favoritesBox;

  @override
  void initState() {
    super.initState();
    _favoritesBox = Hive.box('favoritesBox');
  }

  void _removeFavorite(dynamic key) {
    _favoritesBox.delete(key);
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    final Map<dynamic, dynamic> favorites = _favoritesBox.toMap();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Anime (Offline)'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: favorites.isEmpty
        ? const Center(child: Text('No favorites yet.', style: TextStyle(fontSize: 18)))
          : ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final key = favorites.keys.elementAt(index);
            final item = favorites[key];

            String title = 'Unknown Title';
            String dateAdded = 'Unknown Date';

            if (item is String){
              title = item;
              dateAdded = 'Added earlier';
            } else if (item is Map) {
              title = item['title'] ?? 'Unknown Title';
              dateAdded = item['date'] ?? 'Unknown Date';
            }
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Added: $dateAdded', style: const TextStyle(color: Colors.grey)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _removeFavorite(key),
                ),
              ),
            );
          },
          ),
    );
  }
}