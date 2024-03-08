// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/data/extensions/database_collections.dart';
import 'package:pokelens/widgets/global/app_bar_widget.dart';
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
  //Tamanho dos cards
  int selectedCardSize = 2;

  // Lista de todas as coleções e lista filtrada após aplicar pesquisa e ordenação
  List<Collection> collections = [];

  // Controlador para o campo de pesquisa na barra de pesquisa
  TextEditingController searchController = TextEditingController();
  // Variável para rastrear se a barra de pesquisa está expandida ou não
  bool isSearchExpanded = false;
  // Nodo de foco para o campo de pesquisa
  final FocusNode _searchFocusNode = FocusNode();

  //Variaveis para ordenação
  List<String> sortingList = ['Data', 'Nome', 'Série', '# Cartas'];

  late String primarySortingOption = sortingList[0];
  late String secundarySortingOption = sortingList[1];

  bool isAscending1 = false;
  bool isAscending2 = false;

  Future<void> _updateCollections({
    List<String>? collectionId,
    String? nameSearch,
    String? seriesSearch,
    int? printedTotalSearch,
    int? totalSearch,
    String? ptcgoCodeSearch,
    String? releaseDateSearch,
   


  }) async {
    print('Loading...');
    
    try {
      List<Collection> updatedCollections = await PokemonDatabaseHelper.instance.getCollections(
        collectionId: collectionId,
        
        nameSearch: nameSearch,
        seriesSearch: seriesSearch,
        printedTotalSearch: printedTotalSearch,
        totalSearch: totalSearch,
        ptcgoCodeSearch: ptcgoCodeSearch,
        releaseDateSearch: releaseDateSearch,

        searchTerm: searchController.text,

        isAscending1: isAscending1,
        isAscending2: isAscending2,

        primaryOrderByClause: primarySortingOption,
        secundaryOrderByClause: secundarySortingOption,
      );
      
      print(updatedCollections.map((e) => e.id));
      setState(() {
        collections = updatedCollections;
      });
    } catch (e) {
      print('Erro ao atualizar as coleções: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _updateCollections();
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
          // Pesquisa textual
          setState(() {
            searchController.text = value;
            _updateCollections();
          });
        },
        title: 'Sets Oficiais',
        searchFocusNode: _searchFocusNode,
      ),

      endDrawer: FiltersTab(

        //parâmetros do tamanho das carta
        selectedCardSize: selectedCardSize,
        onCardSizeChanged: (int size) {
          setState(() {
            selectedCardSize = size;
            print('onCardSizeChanged - selectedCardSize: $selectedCardSize');
            _updateCollections();
          });
        }, 
        
        //Ordenação primária
        sortingList: sortingList, 
        primarySortingOption: primarySortingOption,
        onPrimarySortingChanged: (String? value) { 
          setState(() {
            primarySortingOption = value!;
            if (secundarySortingOption == value){
              List<String> sortingList2 = List.from(sortingList);
              sortingList2.remove(primarySortingOption);
              secundarySortingOption = sortingList2[0];
            }
            print('onPrimarySortingChanged - primarySortingOption: $primarySortingOption');
            _updateCollections();
          });
        }, 

        //Ordenação Primária - sentido
        isAscending1: isAscending1, 
        onPrimaryAscendingChanged: (bool value) {
          setState(() {
            isAscending1 =  value;
            print('isAscending1 Changed: $isAscending1');
            _updateCollections();
          });
        }, 
        
        //Ordenação secundária
        secundarySortingOption: secundarySortingOption,
        onSecundarySortingChanged: (String? value) { 
          setState(() {
            secundarySortingOption = value!;
            print('onSecundarySortingChanged - secundarySortingOption: $secundarySortingOption');
            _updateCollections();
          });
        }, 

        //Ordenação secundária - sentido
        isAscending2: isAscending2, 
        onSecundaryAscendingChanged: (bool value) {
          setState(() {
            isAscending2 =  value;
            print('isAscending2 Changed: $isAscending2');
            _updateCollections();
          });
        }, 

      ),

      drawer: const DrawerWidget(),
      body: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: collections.isEmpty
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
                    crossAxisSpacing: 1.0 / selectedCardSize,
                    mainAxisSpacing: 1.0 / selectedCardSize,
                  ),
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    return CollectionsCardWidget(
                      collection: collections[index],
                    );
                  },
                ),
              ),
              
      ),
    );
  }
}
