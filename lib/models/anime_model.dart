class Anime{
  final int id;
  final String title;
  final String imageUrl;

  Anime({required this.id, required this.title, required this.imageUrl});

  factory Anime.fromJson(Map<String, dynamic> json){
    return Anime(
      id: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Brak tytułu',
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
    );
  }
}