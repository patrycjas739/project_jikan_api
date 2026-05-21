import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget{
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Anime'),
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Text(
          'szczegoly i dodaj do ulub.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}