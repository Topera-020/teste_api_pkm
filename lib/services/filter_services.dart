import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';


class FilterService {
  List<Collection> filterCollections(List<Collection> allCollections, String searchTerm) {
    searchTerm = searchTerm.toLowerCase();
    return allCollections.where((collection) {
      return 
          collection.id.toLowerCase().contains(searchTerm) ||
          collection.ptcgoCode.toLowerCase().contains(searchTerm) ||
          collection.name.toLowerCase().contains(searchTerm) ||
          collection.series.toLowerCase().contains(searchTerm) ||
          collection.releaseDate.toLowerCase().contains(searchTerm);
    }).toList();
  }

  List<PokemonCard> filterPokemonCardsBySupertype(List<PokemonCard> allCards) {
    return allCards.where((card) => card.supertype.toLowerCase() == 'pokémon').toList();
  }

  List<PokemonCard> filterCards(List<PokemonCard> allCards, String searchTerm) {
    searchTerm = searchTerm.toLowerCase();
    return allCards.where((card) {
      return 
          card.id.toLowerCase().contains(searchTerm) ||
          card.name.toLowerCase().contains(searchTerm) ||
          card.supertype.toLowerCase().contains(searchTerm) ||
          card.subtypes.toString().toLowerCase().contains(searchTerm) ||
          card.number.toString().contains(searchTerm) ||
          card.artist.toLowerCase().contains(searchTerm) ||
          card.rarity.toLowerCase().contains(searchTerm) ||
          card.nationalPokedexNumbers.toString().toLowerCase().contains(searchTerm) ||
          card.collectionName.toString().toLowerCase().contains(searchTerm) ||
          card.series.toLowerCase().contains(searchTerm) ||
          card.releaseDate.toLowerCase().contains(searchTerm);
    }).toList();
  }

  List<T> sortList<T>(
    List<T> list,
    int Function(T, T) compareFunction, {
    bool ascending = true,
  }) {
    List<T> sortedList = list.toList()..sort(compareFunction);
    if (!ascending) {
      sortedList = sortedList.reversed.toList();
    }
    return sortedList;
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
}