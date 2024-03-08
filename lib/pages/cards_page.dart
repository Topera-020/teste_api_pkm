
import 'package:flutter/material.dart';
import 'package:pokelens/data/extensions/database_pokemon_card.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:pokelens/widgets/global/app_bar_widget.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/widgets/cards_widget.dart';
import 'package:pokelens/widgets/global/drawer_widget.dart';
import 'package:pokelens/widgets/global/filter_tab_widget.dart';
//import 'package:pokelens/widgets/global/filter_tab_widget.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  CardsPageState get createState => CardsPageState();
}

class CardsPageState extends State<CardsPage> {
  //Tamanho dos cards
  int selectedCardSize = 3;

  //Lista de todas as cartas
  List<PokemonCard> pokemonCards = [];
  
  //Título da página
  String title = 'Todas as cartas';
  Collection? collection;
  String? collectionId;

  // Controlador para o campo de pesquisa na barra de pesquisa
  TextEditingController searchController = TextEditingController();
  // Nodo de foco para o campo de pesquisa
  final FocusNode _searchFocusNode = FocusNode();
  // Variável para rastrear se a barra de pesquisa está expandida ou não
  bool isSearchExpanded = false;

  //Variaveis para ordenação
  List<String> sortingList = ['Data',  'Número', 'Nome', '# Pokédex', 'Artista', 'Raridade', 'Tipo', 'Hp','Sub-categoria','Super-categoria'];
  
  late String primarySortingOption = sortingList[0];
  late String secondaryOrderByClause = sortingList[1];

  bool isAscending1 = true;
  bool isAscending2 = true;

  Future<void> _updateCards( 
    //depois parâmetros para pesquisa específica
  ) async {
    try {
      List<PokemonCard>? updatedCards = await PokemonDatabaseHelper.instance.getPokemonCards(
        searchTerm: searchController.text,
        collectionId: collectionId,

        isAscending1: isAscending1,
        isAscending2: isAscending2,

        primaryOrderByClause: primarySortingOption,
        secondaryOrderByClause: secondaryOrderByClause,
      );
      
      setState(() {
        pokemonCards = updatedCards!;
      });
      
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao atualizar as cartas: $e');
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      final Collection? collection = args['collection'] as Collection?;
      if (collection != null) {
        sortingList.remove('Data');
        primarySortingOption = sortingList[0];
        secondaryOrderByClause = sortingList[1];
        collectionId = collection.id;
        title = collection.name;
      }

      _updateCards();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      collection = args['collection'] as Collection?;
      collectionId = collection?.id;
      //print('Page: Id da coleção: ${collection?.id} $collectionId');
    }

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
            _updateCards();
          });
        },
        title: title,
        searchFocusNode: _searchFocusNode,
      ),
      
      drawer: const DrawerWidget(),

      endDrawer: FiltersTab(

        //parâmetros do tamanho das carta
        selectedCardSize: selectedCardSize,
        onCardSizeChanged: (int size) {
          setState(() {
            selectedCardSize = size;
            //print('onCardSizeChanged - selectedCardSize: $selectedCardSize');
            _updateCards();
          });
        }, 
        
        //Ordenação primária
        sortingList: sortingList, 
        primarySortingOption: primarySortingOption,
        onPrimarySortingChanged: (String? value) { 
          setState(() {
            primarySortingOption = value!;
            if (secondaryOrderByClause == value){
              List<String> sortingList2 = List.from(sortingList);
              sortingList2.remove(primarySortingOption);
              secondaryOrderByClause = sortingList2[0];
            }
            //print('onPrimarySortingChanged - primarySortingOption: $primarySortingOption');
            _updateCards();
          });
        }, 

        //Ordenação Primária - sentido
        isAscending1: isAscending1, 
        onPrimaryAscendingChanged: (bool value) {
          setState(() {
            isAscending1 =  value;
            //print('isAscending1 Changed: $isAscending1');
            _updateCards();
          });
        }, 
        
        //Ordenação secundária
        secondaryOrderByClause: secondaryOrderByClause,
        onsecondarySortingChanged: (String? value) { 
          setState(() {
            secondaryOrderByClause = value!;
            //print('onsecondarySortingChanged - secondaryOrderByClause: $secondaryOrderByClause');
            _updateCards();
          });
        }, 

        //Ordenação secundária - sentido
        isAscending2: isAscending2, 
        onsecondaryAscendingChanged: (bool value) {
          setState(() {
            isAscending2 =  value;
            //print('isAscending2 Changed: $isAscending2');
            _updateCards();
          });
        }, 

      ),




      body: GestureDetector(
        onTap: () {
          _searchFocusNode.unfocus();
        },
        child: pokemonCards.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma carta disponível.',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: selectedCardSize,
                    childAspectRatio: 0.73,
                    crossAxisSpacing: 6.0/selectedCardSize,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: pokemonCards.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      pokemonCard: pokemonCards[index],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
