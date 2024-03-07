
import 'package:flutter/material.dart';
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
  List<PokemonCard> filteredCards = [];
  String title = 'Todas as cartas';
  String? collectionId;
  TextEditingController searchController = TextEditingController();
  bool isSearchExpanded = false;
  int selectedOrderIndex = 0;
  //FilterService filterService = FilterService();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> sortingList = ['Data',  'Número', 'Nome', '# Pokédex', 'Artista'];
  late String sortingOption = sortingList[0];

  int Function(PokemonCard, PokemonCard) get compareFunction {
    switch (sortingOption) {
      case 'Data':
        return (a, b) => a.releaseDate.compareTo(b.releaseDate);
      case 'Nome':
        return (a, b) => a.name.compareTo(b.name);
      case 'Hp':
        return (a, b) => a.hp.compareTo(b.hp);
      case 'Tipos':
        return (a, b) => a.types[0].compareTo(b.types[0]);
      case 'Número':
        return (a, b) => a.numberINT.compareTo(b.numberINT);
      case 'Artista':
        return (a, b) => a.artist.compareTo(b.artist);
      case '# Pokédex':
        return (a, b) {
          return a.nationalPokedexNumbers[0].compareTo(b.nationalPokedexNumbers[0]);
        };
      default:
        return (a, b) {
          // ignore: avoid_print
          print('erro: $sortingOption');
          return 0;
        };
    }
  }

  @override
  void didChangeDependencies() {
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

      fetchData();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData() async {
    final List<PokemonCard>? cards =
        await PokemonDatabaseHelper.instance.getPokemonCards(
      collectionId: collectionId,
    );

    if (cards != null) {
       
      if (mounted) {
        setState(() {
          pokemonCards = cards;
          filteredCards = List.from(pokemonCards);
        });
      }

    } else {
      // ignore: avoid_print
      print('A lista de cartas é nula.');
    }
  }

  void filterCards() {
    String searchTerm = searchController.text;
    if (mounted) {
      setState(() {
        // = filterService.filterCards(pokemonCards, searchTerm);
        sortCards();
      });
    }
  }

  void sortCards() {
    if(sortingOption=='# Pokédex'){
      //filteredCards = filterService.filterPokemonCardsBySupertype(filteredCards);
      if (mounted) {
        setState(() {
          //filteredCards = filterService.sortList(
           // filteredCards,
        //  compareFunction,
        //  ascending: selectedOrderIndex == 0,
         // );
        });
      }
    }
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
            filterCards();
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
        child: filteredCards.isEmpty
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
                  itemCount: filteredCards.length,
                  itemBuilder: (context, index) {
                    return CardWidget(
                      pokemonCard: filteredCards[index],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
