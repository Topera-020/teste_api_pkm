// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/services/filter_services.dart';
import 'package:pokelens/widgets/app_bar_widget.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/widgets/drawer_widget.dart';
import 'package:pokelens/widgets/filter_tab_widget.dart';
import 'package:pokelens/widgets/sets_widget.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  CollectionsPageState get createState => CollectionsPageState();
}

class CollectionsPageState extends State<CollectionsPage> {
  List<Collection> pokemonCollections = [];
  List<Collection> filteredCollections = [];
  TextEditingController searchController = TextEditingController();
  bool isSearchExpanded = false;
  int selectedOrderIndex = 0; // 0 para Ascendente, 1 para Descendente
  CollectionFilterService filterService = CollectionFilterService();

  final FocusNode _searchFocusNode = FocusNode();

  String sortingOption = 'Data';

  int Function(Collection, Collection) get compareFunction {
    switch (sortingOption) {
      case 'Data':
        return (a, b) => a.releaseDate.compareTo(b.releaseDate);
      case 'Nome':
        return (a, b) => a.name.compareTo(b.name);
      default:
        return (a, b) => 0;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final List<Collection> collections =
        await PokemonDatabaseHelper.instance.getCollections();

    setState(() {
      pokemonCollections = collections;
      // Inicialize filteredCollections com a lista completa
      filteredCollections = List.from(pokemonCollections);
      sortCollections();
    });
  }

  void filterCollections() {
    String searchTerm = searchController.text;
    setState(() {
      filteredCollections = filterService.filterCollections(pokemonCollections, searchTerm);
      sortCollections();
    });
  }

  void sortCollections() {
    setState(() {
      filteredCollections = filterService.sortList(
        filteredCollections,
        compareFunction,
        ascending: selectedOrderIndex == 0,
      );
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        searchController: searchController,
        isSearchExpanded: isSearchExpanded,
        onSearchToggled: (isExpanded) {
          setState(() {
            isSearchExpanded = isExpanded;
          });
        },
        onSearchChanged: (value) {
          setState(() {
            searchController.text = value;
            filterCollections();
          });
        },
        title: 'Sets Oficiais',
        searchFocusNode: _searchFocusNode,
      ),
      endDrawer: FiltersTab(
        sortingOption:sortingOption,
        selectedOrderIndex: selectedOrderIndex,
        onSortingChanged: (value) {
          setState(() {
            sortingOption = value;
            sortCollections();
          });
        },
        onOrderChanged: (index) {
          setState(() {
            selectedOrderIndex = index;
            sortCollections();
          });
        },
      ),
      drawer: const DrawerWidget(),
      body: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: filteredCollections.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma coleção disponível.',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: filteredCollections.length,
                  itemBuilder: (context, index) {
                    return SetsCardWidget(
                      collection: filteredCollections[index],
                    );
                  },
                ),
            ),
      ),
    );
  }
}
