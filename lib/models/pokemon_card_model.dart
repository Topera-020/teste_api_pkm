
class PokemonCard {
  final String id;
  final String name;
  final String supertype;
  final List<String> subtypes;
  final String hp;
  final List<String> types;
  final int? convertedRetreatCost;
  final String setId;
  final String number;
  final String artist;
  final String rarity;
  final String small;
  final String large;
  final List<int> nationalPokedexNumbers;

  PokemonCard({
    required this.id,
    required this.name,
    required this.small,
    required this.large,
    required this.supertype,
    required this.subtypes,
    required this.hp,
    required this.types,
    required this.convertedRetreatCost,
    required this.setId,
    required this.number,
    required this.artist,
    required this.rarity,
    required this.nationalPokedexNumbers,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'],
      name: json['name'] ?? '',
      small: json["images"]["small"],
      large: json["images"]["large"],
      supertype: json['supertype'] ?? '',
      subtypes: _convertToList(json['subtypes']),
      hp: json['hp'] ?? '',
      types: _convertToList(json['types']),
      convertedRetreatCost: json['convertedRetreatCost'] ?? 0,
      setId: json['set'],
      number: json['number'] ?? '',
      artist: json['artist'] ?? '',
      rarity: json['rarity'] ?? '',
      nationalPokedexNumbers: _convertToIntList(json['nationalPokedexNumbers']),
    );
  }

  factory PokemonCard.fromMap(Map<String, dynamic> map) {
    return PokemonCard(
      id: map['id'],
      name: map['name'],
      small: map['small'],
      large: map['large'],
      supertype: map['supertype'],
      subtypes: _convertToList(map['subtypes']),
      hp: map['hp'],
      types: _convertToList(map['types']),
      convertedRetreatCost: map['convertedRetreatCost'],
      setId: map['setId'],
      number: map['number'],
      artist: map['artist'],
      rarity: map['rarity'],
      nationalPokedexNumbers: _convertToIntList(map['nationalPokedexNumbers']),
    );
  }

  static List<String> _convertToList(dynamic value) {
    if (value is String) {
      return [value];
    } else if (value is List<dynamic>) {
      return value.map((item) => item.toString()).toList();
    } else {
      return [];
    }
  }

  static List<int> _convertToIntList(dynamic value) {
    if (value is int) {
      return [value];
    } else if (value is List<dynamic>) {
      return value.map((item) => item as int).toList();
    } else {
      return [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'small': small,
      'large': large,
      'supertype': supertype,
      'subtypes': subtypes,
      'hp': hp,
      'types': types,
      'convertedRetreatCost': convertedRetreatCost,
      'setId': setId,
      'number': number,
      'artist': artist,
      'rarity': rarity,
      'nationalPokedexNumbers': nationalPokedexNumbers,
    };
  }
}
