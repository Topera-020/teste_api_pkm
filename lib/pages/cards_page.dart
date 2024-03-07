
import 'package:flutter/material.dart';
import 'package:pokelens/data/extensions/database_filters.dart';
import 'package:pokelens/data/extensions/database_pokemon_card.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';

import 'package:pokelens/widgets/global/app_bar_widget.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/widgets/cards_widget.dart';
import 'package:pokelens/widgets/global/drawer_widget.dart';
import 'package:pokelens/widgets/global/filter_tab_widget.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  CardsPageState get createState => CardsPageState();
}

class CardsPageState extends State<CardsPage> {
  int selectedCardSize = 3;
  List<PokemonCard> pokemonCards = [];
  
  String title = 'Todas as cartas';
  String? collectionId;

  TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool isSearchExpanded = false;
  int selectedOrderIndex = 0;
  
  List<String> sortingList = ['Data',  'Número', 'Nome', '# Pokédex', 'Artista'];
  late String sortingOption = sortingList[0];

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      final Collection? collection = args['collection'] as Collection?;
      if (collection != null) {
        sortingList.remove('Data');
        sortingOption = sortingList[0];
        collectionId = collection.id;
        title = collection.name;
      }

     pokemonCards =(await PokemonDatabaseHelper.instance.getPokemonCards(
        collectionId: collectionId,
      ))!;

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

  Future<void>  sortCards() async {
      pokemonCards = (await PokemonDatabaseHelper.instance.getFilteredAndSortedPokemonCards(
        collectionId: collectionId,
        searchTerm: searchController.text,
        isAscending: selectedOrderIndex == 1,
      ))!;
      
      if (mounted) {setState(() { });}
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      final Collection? collection = args['collection'] as Collection?;
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
          setState(() {
            searchController.text = value;
          });
        },
        title: title,
        searchFocusNode: _searchFocusNode,
      ),
      endDrawer: FiltersTab(
        sortingList: sortingList,
        sortingOption: sortingOption,
        selectedOrderIndex: selectedOrderIndex,
        selectedCardSize: selectedCardSize,
        onSortingChanged: (value) {
          setState(() {
            sortingOption = value;
            sortCards();
          });
        },
        onOrderChanged: (index) {
          setState(() {
            selectedOrderIndex = index;
            sortCards();
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
