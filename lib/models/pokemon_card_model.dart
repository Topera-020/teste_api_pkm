import 'dart:convert';

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
  List<String> tags;
  bool tenho;
  bool preciso;
  final int numberINT;

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
    required this.numberINT
  });
  
  
  factory PokemonCard.fromMap(Map<String, dynamic> map) {
    //para recuperar do SQL
    List<String> tags = [];
    return PokemonCard(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      small: map['small'] ?? map["images"]["small"] ?? '',
      large: map['large'] ?? map["images"]["large"] ?? '',
      supertype: map['supertype'] ?? '',
      subtypes: convertToList(map['subtypes']),
      hp: map['hp'] ?? '',
      types: convertToList(map['types']),
      convertedRetreatCost: map['convertedRetreatCost'] ?? 0,
      number: map['number'] ?? '',
      artist: map['artist'] ?? '',
      rarity: map['rarity'] ?? '',
      nationalPokedexNumbers: convertToIntList(map['nationalPokedexNumbers']),

      //collection
      collectionId: map['collectionId'] ?? (map['set'] != null ? map['set']['id'] : ''),
      releaseDate: map['releaseDate'] ?? (map['set'] != null ? map['set']['releaseDate'] : ''),
      collectionName: map['collectionName'] ?? (map['set'] != null ? map['set']['name'] : ''),
      series: map['series'] ?? (map['set'] != null ? map['set']['name'] : ''),

      //user_data
      tags: tags,
      tenho: map['tenho'] == 1,
      preciso: map['preciso'] == 1,
      numberINT: map['numberINT'] ?? extractDigits(map['number']) ?? 0,
    );
  }

  static List<String> convertToList(dynamic value) {
    if (value is String) {
      
      // Se for uma string, tenta converter para uma lista de strings
      try {
        List<String> result = json.decode(value).cast<String>().toList();
        return result;
      } catch (e) {
        // Se houver algum erro, retorna uma lista vazia
        return [];
      }
    } else if (value is List<dynamic>) {
      // Se já for uma lista, verifica se cada item é uma string e converte para string
      return value.map((item) => item.toString()).toList();
    } else {
      return [];
    }
  }


  static List<int> convertToIntList(dynamic value) {
    if (value is String) {

      // Remove os colchetes e divide a string em uma lista de strings separadas por vírgulas
      List<String> numbers = value.replaceAll(RegExp(r'[\[\]]'), '').split(',');
   
      // Converte cada string para int e cria uma lista de ints
      return numbers.map((item) => int.tryParse(item) ?? 0).toList();

    } else if (value is List<dynamic>) {
      // Se já for uma lista, verifica se cada item é uma string e converte para int
      return value.map((item) => item is String ? int.tryParse(item.trim()) ?? 0 : item as int).toList();
    } else {
      return [];
    }
  }



  static int extractDigits(String input) {
    String digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  Map<String, dynamic> toMap() { 
    var map = {
      'id': id,
      'name': name,
      'small': small,
      'large': large,
      'supertype': supertype,
      'subtypes': subtypes,
      'hp': hp,
      'types': types,
      'convertedRetreatCost': convertedRetreatCost,
      'number': number,
      'artist': artist,
      'rarity': rarity,
      'nationalPokedexNumbers': nationalPokedexNumbers,

      'collectionId': collectionId,
      'collectionName': collectionName,
      'series': series,
      'releaseDate': releaseDate,
      
      'tags': tags.toString(),
      'tenho': tenho, 
      'preciso': preciso,
      'numberINT': numberINT,
    };

    //para inserir no SQL
    return map;
  }
}
