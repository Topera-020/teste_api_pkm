class PkDxPage {
  final int count;
  final String? next;
  final String? previous;
  final List<Pokemon> results;

  PkDxPage({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory PkDxPage.fromJson(Map<String, dynamic> json) {
    List<Pokemon> pokemonList = List<Pokemon>.from(
      json['results'].map((pokemon) => Pokemon.fromJson(pokemon)),
    );

    return PkDxPage(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: pokemonList,
    );
  }
}

class Pokemon {
  final String name;
  final String url;

  Pokemon({
    required this.name,
    required this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}
