class PokemonCard {
  final String id;
  final String name;
  final String supertype;
  final List<String> subtypes;
  final String hp;
  final List<String> types;
  final int? convertedRetreatCost;
  final String collectionId;
  final String number;
  final String artist;
  final String rarity;
  final String small;
  final String large;
  final List<int> nationalPokedexNumbers;
  final String releaseDate;
  final String collectionName;
  final String series;
  final List<String> tags;
  final bool tenho;
  final bool preciso;

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
    required this.collectionId,
    required this.number,
    required this.artist,
    required this.rarity,
    required this.nationalPokedexNumbers,
    required this.releaseDate,
    required this.collectionName,
    required this.series,
    required this.tags,
    required this.tenho,
    required this.preciso,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    List<String> tags = [];
    Map<String, dynamic> setInfo = json['set'] as Map<String, dynamic>? ?? {};

    return PokemonCard(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      small: json["images"]["small"] ?? '',
      large: json["images"]["large"] ?? '',
      supertype: json['supertype'] ?? '',
      subtypes: _convertToList(json['subtypes']),
      hp: json['hp'] ?? '',
      types: _convertToList(json['types']),
      convertedRetreatCost: json['convertedRetreatCost'] ?? 0,
      collectionId: setInfo['id'] ?? '',
      number: json['number'] ?? '',
      artist: json['artist'] ?? '',
      rarity: json['rarity'] ?? '',
      nationalPokedexNumbers: _convertToIntList(json['nationalPokedexNumbers']),
      releaseDate: setInfo['releaseDate'] ?? '',
      collectionName: setInfo['name'] ?? '',
      series: setInfo['series'] ?? '',
      tags: tags,
      tenho: false,
      preciso: false,
    );
  }

  factory PokemonCard.fromMap(Map<String, dynamic> map) {
    //print('map2card: $map');
    List<String> tags = [];
    return PokemonCard(
      id: map['id'] ,
      name: map['name'] ,
      small: map['small'] ,
      large: map['large'] ,
      supertype: map['supertype'] ,
      subtypes: _convertToList(map['subtypes']),
      hp: map['hp'],
      types: _convertToList(map['types']),
      convertedRetreatCost: map['convertedRetreatCost'] ?? 0,
      collectionId: map['collectionId'],
      number: map['number'],
      artist: map['artist'],
      rarity: map['rarity'],
      nationalPokedexNumbers: _convertToIntList(map['nationalPokedexNumbers']),
      releaseDate: map['releaseDate'],
      collectionName: map['collectionName'],
      series: map['series'],
      tags: tags,
      tenho: map['tenho'] == 1, // Corrigir a atribuição de int para bool
      preciso: map['preciso'] == 1, // Corrigir a atribuição de int para bool
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
      'collectionId': collectionId,
      'number': number,
      'artist': artist,
      'rarity': rarity,
      'nationalPokedexNumbers': nationalPokedexNumbers,
      'releaseDate': releaseDate,
      'collectionName': collectionName,
      'series': series,
      'tags': tags.toString(),
      'tenho': tenho, 
      'preciso': preciso,
    };
  }
}
