// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/data/extensions/database_collections.dart';
import 'package:pokelens/services/filter_services.dart';
import 'package:pokelens/widgets/global/app_bar_widget.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/widgets/global/drawer_widget.dart';
import 'package:pokelens/widgets/global/filter_tab_widget.dart';
import 'package:pokelens/widgets/collections_widget.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  CollectionsPageState get createState => CollectionsPageState();
}

class CollectionsPageState extends State<CollectionsPage> {
  int selectedCardSize = 2;

  // Lista de todas as coleções e lista filtrada após aplicar pesquisa e ordenação
  List<Collection> pokemonCollections = [];
  List<Collection> filteredCollections = [];

  // Controlador para o campo de pesquisa na barra de pesquisa
  TextEditingController searchController = TextEditingController();

  // Variável para rastrear se a barra de pesquisa está expandida ou não
  bool isSearchExpanded = false;

  // Serviço de filtro para manipulação das coleções
  FilterService filterService = FilterService();

  // Nodo de foco para o campo de pesquisa
  final FocusNode _searchFocusNode = FocusNode();

  // Índice da opção de ordenação selecionada (Ascendente ou Descendente)
  int selectedOrderIndex = 1;

  // Opção atual de ordenação
  List<String> sortingList = ['Data', 'Nome', 'Série', '# Cartas'];
  late String sortingOption = sortingList[0];
  

  // Função de comparação para a ordenação das coleções
  int Function(Collection, Collection) get compareFunction {
    switch (sortingOption) {
      case 'Data':
        return (a, b) => a.releaseDate.compareTo(b.releaseDate);
      case 'Nome':
        return (a, b) => a.name.compareTo(b.name);
      case 'Série':
        return (a, b) => a.series.compareTo(b.series);
      case '# Cartas':
        return (a, b) => a.printedTotal.compareTo(b.printedTotal);
      default:
        return (a, b) => 0;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Inicializa os dados das coleções ao criar o widget
  }

  // Método assíncrono para buscar dados das coleções no banco de dados
  Future<void> fetchData() async {
    final List<Collection> collections =
        await PokemonDatabaseHelper.instance.getAllCollections();

    setState(() {
      pokemonCollections = collections;
      // Inicialize filteredCollections com a lista completa
      filteredCollections = List.from(pokemonCollections);
      sortCollections(); // Aplica a ordenação inicial
    });
  }

  // Método para filtrar as coleções com base na barra de pesquisa
  void filterCollections() {
    String searchTerm = searchController.text;
    setState(() {
      filteredCollections = filterService.filterCollections(pokemonCollections, searchTerm);
      sortCollections(); // Reaplica a ordenação após a filtragem
    });
  }

  // Método para ordenar as coleções com base na opção selecionada
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
        selectedCardSize: selectedCardSize,
        sortingList: sortingList,
        selectedOrderIndex: selectedOrderIndex,
        sortingOption: sortingOption,
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
        onCardSizeChanged: (size) {
          setState(() {
            selectedCardSize = size;
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: selectedCardSize,
                    crossAxisSpacing: 1.0/selectedCardSize,
                    mainAxisSpacing: 1.0/selectedCardSize,
                  ),
                  itemCount: filteredCollections.length,
                  itemBuilder: (context, index) {
                    return CollectionsCardWidget(
                      collection: filteredCollections[index],
                    );
                  },
                ),
            ),
      ),
    );
  }
}
