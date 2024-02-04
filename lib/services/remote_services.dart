// ignore_for_file: avoid_print

import 'package:teste_api/models/collections_models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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


  Future<Page> fetchPage(String type, {
    int pageNumber = 1,
    String query = '',
    int pageSize = 21,
  }) async {
    print('query: $query');
    String url = 'https://api.pokemontcg.io/v2/$type?page=$pageNumber&pageSize=$pageSize';
    if (query != ''){
      url = 'https://api.pokemontcg.io/v2/$type?q=$query&page=$pageNumber&pageSize=$pageSize';
    }
    print('url: $url');
    final Uri uri = Uri.parse(url);
    try {
      final http.Response response = await _client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print('jsonResponse $jsonResponse');
        return Page.fromJson(jsonResponse);
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

  Future<List<Map<String, dynamic>>?> getFullData(String type, {String query = '',} ) async {
    try {
      int totalCount = 1;
      List<Map<String, dynamic>> allData = [];

      // Lógica para buscar páginas até que todos os dados sejam carregados
      var currentPage = 1;
      
      while (allData.length < totalCount) {
        print(allData.length);
        print(totalCount);

        try {
          Page page = await fetchPage(type, pageNumber: currentPage, query:query);
          allData.addAll(page.data);
          totalCount = page.totalCount;
          currentPage++;

        } catch (e) {
          print('Erro ao buscar página $currentPage: $e');
          break;
        }
      }
      return allData;
    } catch (e) {
      // Trate as exceções de maneira adequada
      print('Erro ao buscar coleções: $e');
      return null;
    } finally {
      _client.close();
    }
  }

  

  Future<List<Collection>?> getCollections() async {
    final List<Map<String, dynamic>>? allCollections = await getFullData('sets');
    if (allCollections == null) {
      return null;
    } else {
      final List<Collection> listCollection =
          allCollections.map((map) => Collection.fromJson(map)).toList();
      return listCollection;
    }
  }

  Future<List<PokemonCard>?> getCards({String query = '', int pageNumber = 1}) async {
    Page pageCard = await fetchPage('cards', query: query, pageNumber: pageNumber);
    final List<Map<String, dynamic>> allCards = pageCard.data;

    if (allCards == null || allCards.isEmpty) {
      print('No data available.');
      return null;
    }

    print('allCards ${allCards[0]}');
    final List<PokemonCard> listCards =
        allCards.map((map) => PokemonCard.fromJson(map)).toList();
    print('listCards ${listCards.length}');

    return listCards;
  }


}