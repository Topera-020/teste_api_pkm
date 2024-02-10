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


  factory PokemonCard.fromMap(Map<String, dynamic> map) {
    return PokemonCard(
      id: map['id'],
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      setId: map['setId'],
      smallImg: map['smallImg'],
      largeImg: map['largeImg'],
    );
  }

  // Método para converter um objeto PokemonCard em um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'setId': setId,
      'smallImg': smallImg,
      'largeImg': largeImg,
    };
  }

  @override
  String toString() {
    return 'PokemonCard(id: $id, name: $name, number: $number, setId: $setId)';
  }
  
}
