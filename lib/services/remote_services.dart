// ignore_for_file: avoid_print

import 'package:teste_api/models/card_models.dart';
import 'package:teste_api/models/collections_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:teste_api/models/page_models.dart';
import 'package:teste_api/models/pokedex_list_models.dart';
import 'package:teste_api/models/pokedex_models.dart';

class RemoteService {
  final http.Client _client = http.Client();

  List<T> sortList<T>(List<T> list, int Function(T, T) compareFunction) {
    return list.toList()..sort(compareFunction);
  }

  Map<String, List<T>> groupListByProperty<T>(List<T> list, String Function(T) propertyFunction) {
    Map<String, List<T>> groupedMap = {};

    for (var item in list) {
      String key = propertyFunction(item);
      if (!groupedMap.containsKey(key)) {
        groupedMap[key] = [];
      }
      groupedMap[key]!.add(item);
    }

    return groupedMap;
  }

  List<T> filterList<T>(List<T> list, bool Function(T) filterFunction) {
    return list.where(filterFunction).toList();
  }

  Future<Map<String, dynamic>> fetch(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      final http.Response response = await _client.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Se houver um erro na resposta, lance uma exceção para indicar o problema
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      // Captura exceções durante a requisição
      print('Erro ao buscar página: $e');
      // Re-lança a exceção para que a chamada da função possa lidar com isso, se necessário
      rethrow;
    }
  }

  Future<Page> fetchPage(String type, {
    int pageNumber = 1,
    String query = '',
    int pageSize = 21,
  }) async {
    String url = 'https://api.pokemontcg.io/v2/$type?page=$pageNumber&pageSize=$pageSize';
    if (query.isNotEmpty) {
      url = 'https://api.pokemontcg.io/v2/$type?q=$query&page=$pageNumber&pageSize=$pageSize';
    }
    return Page.fromJson(await fetch(url) as Map<String, dynamic>);
  }

  Future<List<Collection>?> getCollections() async {
    try {
      Page pageCollections = await fetchPage('sets', pageSize: 1000);
      final List<Map<String, dynamic>> allCollections = pageCollections.data;

      if (allCollections.isEmpty) {
        print('No data available. (Collections)');
        return null;
      }
      final List<Collection> listCollection = allCollections.map((map) => Collection.fromJson(map)).toList();

      return listCollection;
    } catch (e) {
      print('Erro ao buscar coleções: $e');
      return null;
    }
  }

  Future<List<PokemonCard>?> getCards({String query = '', int pageNumber = 1}) async {
    Page pageCard = await fetchPage('cards', query: query, pageNumber: pageNumber);
    final List<Map<String, dynamic>> allCards = pageCard.data;

    if (allCards.isEmpty) {
      print('No data available.');
      return null;
    }

    print('allCards length ${allCards.length}');
    final List<PokemonCard> listCards = allCards.map((map) => PokemonCard.fromJson(map)).toList();
    print('listCards length ${listCards.length}');

    return listCards;
  }

  Future<int> getQuantidadeDeCartas() async {
    Page page = await fetchPage('cards', pageSize: 1);
    return page.totalCount;
  }

  Future<int> getQuantidadeDeSets() async {
    Page page = await fetchPage('sets', pageSize: 1);
    return page.totalCount;
  }

  Future<List<String>> fetchPokemonSpeciesUrls({
    int offset = 0,
    int limit = 10000,
  }) async {
    //Pega todas as espécies de pokemon e retorna uma lista com os urls
    String url = 'https://pokeapi.co/api/v2/pokemon-species?limit=$limit&offset=$offset';
    PokemonSpeciesList pokemonSpeciesList =
        PokemonSpeciesList.fromJson(await fetch(url) as Map<String, dynamic>);
    return pokemonSpeciesList.urls;
  }

  Future<List<PokedexEntry>> fetchPokedexEntryList() async {
    List<PokedexEntry> pokedexEntries = [];

    try {
      List<String> pokemonSpeciesUrls = await fetchPokemonSpeciesUrls();

      for (String speciesUrl in pokemonSpeciesUrls) {
        try {
          Map<String, dynamic> speciesJson = await fetch(speciesUrl);
          // speciesJson - página da espécie do pokemon {id(pokedexNumber), baby, legendary, mythical, varieties, genderDif}

          if (speciesJson.containsKey('varieties') && speciesJson['varieties'] is List) {
            List<String> varietiesUrls = speciesJson['varieties']
                .map<String>((map) => map["pokemon"]["url"])
                .toList(); // Pega a lista de URLs com as Variedades de determinado pokemon

            for (String variationUrl in varietiesUrls) {
              try {
                Map<String, dynamic> variationJson = await fetch(variationUrl);
                if (variationJson.containsKey('types') && variationJson['types'] is List) {
                  List<String> types = variationJson["types"]
                      .map<String>((type) => type["type"]["name"])
                      .toList();
                  List<String> varieties = variationJson['varieties']
                      .where((variation) => variation["is_default"] == false)
                      .map<String>((variation) => variation["pokemon"]["name"])
                      .toList();

                  PokedexEntry entry = PokedexEntry(
                    // Características que vêm da página de Variação (/Pokemon/)
                    id: variationJson['id'],
                    name: variationJson['name'],
                    height: variationJson['height'],
                    weight: variationJson['weight'],
                    isDefault: variationJson['is_default'],
                    types: types,
                    officialArtwork: variationJson['sprites']['other']['official-artwork']['front_default'],
                    shiny: variationJson['sprites']['other']['official-artwork']['front_shiny'],

                    // Características que vêm da página de Espécie (/Pokemon-species/)
                    pokedexNumber: speciesJson['id'],
                    isBaby: speciesJson['is_baby'],
                    isLegendary: speciesJson['is_legendary'],
                    isMythical: speciesJson['is_mythical'],
                    evolvesFromSpecies: speciesJson['evolves_from_species'] != null
                        ? speciesJson['evolves_from_species']['name']
                        : null,
                    varieties: varieties, // lista com o nome das variedades
                    female: variationJson['sprites']['other']['home']['front_female'],
                    shinyFemale: variationJson['sprites']['other']['home']['front_shiny_female'],
                  );

                  pokedexEntries.add(entry);
                } else {
                  print('Erro: Variante sem tipos definidos.');
                }
              } catch (e) {
                print('Erro ao processar variação: $e');
              }
            }
          } else {
            print('Erro: Espécie sem variedades definidas.');
          }
        } catch (e) {
          print('Erro ao processar espécie: $e');
        }
      }
    } catch (e) {
      print('Erro ao buscar URLs das espécies: $e');
    }

    return pokedexEntries;
  }

  void dispose() {
    _client.close();
  }
}
