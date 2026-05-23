import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class FavoritesScreen extends StatelessWidget{
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context){
    final box = Hive.box('favoritesBox');

    final favorites = box.toMap();

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
            final title = favorites[key];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(title),
                trailing: const Icon(Icons.offline_pin, color: Colors.green),
              ),
            );
          },
          ),
    );
  }
}