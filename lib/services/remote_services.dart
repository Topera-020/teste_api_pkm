// ignore_for_file: avoid_print

import 'package:pokelens/models/collections_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokelens/models/page_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';

class RemoteService {
  final http.Client _client = http.Client();

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
    int pageSize = 250,
  }) async {
    String url = 'https://api.pokemontcg.io/v2/$type?page=$pageNumber&pageSize=$pageSize';
    if (query.isNotEmpty) {
      url = 'https://api.pokemontcg.io/v2/$type?q=$query&page=$pageNumber&pageSize=$pageSize';
    }
    print(url);
    return Page.fromJson(await fetch(url));
  }

  Future<List<Collection>?> getCollections() async {
    try {
      Page pageCollections = await fetchPage('sets', pageSize: 1000);
      final List<Map<String, dynamic>> allCollections = pageCollections.data;

      if (allCollections.isEmpty) {
        print('No data available. (Collections)');
        return null;
      }
      final List<Collection> listCollection = allCollections.map((map) => Collection.fromMap(map)).toList();

      return listCollection;
    } catch (e) {
      print('Erro ao buscar coleções: $e');
      return null;
    }
  }

  Future<List<PokemonCard>> getAllCardsByCollection(String collectionId) async {
    print('getAllCardsByCollection');
    int pageNumber = 1;
    List<Map<String, dynamic>> allCards = [];
    int totalCount = 0;

    do{
      Page pageCard = await fetchPage('cards', query: 'id:$collectionId', pageNumber: pageNumber);
      allCards.addAll(pageCard.data);
      totalCount = pageCard.totalCount;
      pageNumber++;
    }while (allCards.length < totalCount);

    if (allCards.isEmpty) {
      print('No data available.');
      return [];
    }

    print(allCards);
    final List<PokemonCard> listCards = allCards.map((cardData) {
      return PokemonCard.fromMap(cardData);
    }).toList();

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


  void dispose() {
    _client.close();
  }
}
