class PokemonSpeciesList {
  final int count;
  final String? next;
  final String? previous;
  final List<String> urls;

  PokemonSpeciesList({
    required this.count,
    required this.next,
    required this.previous,
    required this.urls,
  });

  factory PokemonSpeciesList.fromJson(Map<String, dynamic> json) {
    List<dynamic> results = json['results'] as List<dynamic>;
    List<String> urls = results.map((result) => result['url'].toString()).toList();
    
    return PokemonSpeciesList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      urls: urls,
    );
  }
}
