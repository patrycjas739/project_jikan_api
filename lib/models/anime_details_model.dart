class AnimeDetails {
  final int id;
  final String title;
  final String imageUrl;
  final String synopsis;
  final double score;
  final int episodes;

  AnimeDetails({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.score,
    required this.episodes,
  });

  factory AnimeDetails.fromJson(Map<String, dynamic> json) {
    return AnimeDetails(
      id: json['mal_id'] ?? 0,
      title: json['title'] ?? 'Brak tytułu',
      imageUrl: json['images']?['jpg']?['large_image_url'] ?? '',
      synopsis: json['synopsis'] ?? 'Brak opisu.',
      score: (json['score'] ?? 0).toDouble(),
      episodes: json['episodes'] ?? 0,
    );
  }
}

