import 'package:pokelens/models/collections_models.dart';


class CollectionFilterService {
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