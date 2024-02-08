class PokemonCard {
  final String? id;
  final String? name;
  final String? number;
  final String? setId;
  final String? smallImg;
  final String? largeImg;

  PokemonCard({
     this.id,
     this.name,
     this.number,
     this.setId,
     this.smallImg,
     this.largeImg,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'],
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      setId: json['set']['id'],
      smallImg: json["images"]["small"],
      largeImg: json["images"]["large"],
    );
  }

  @override
  String toString() {
    return 'PokemonCard(id: $id, name: $name, number: $number, setId: $setId)';
  }
}
