// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:teste_api/models/card_models.dart';
import 'package:teste_api/widgets/app_bar_widget.dart';
import 'package:teste_api/widgets/cards_widget.dart';
import 'package:teste_api/services/remote_services.dart';

class CardPage extends StatefulWidget {
  final String? setId;

  const CardPage({Key? key, this.setId}) : super(key: key);

  @override
  CardPageState createState() => CardPageState();
}

class CardPageState extends State<CardPage> {
  bool hasMoreData = true; 
  late Future<List<PokemonCard>?> pokemonCardsFuture;
  TextEditingController searchController = TextEditingController();
  bool isSearchExpanded = false;
  List<PokemonCard> cardsList = [];
  int currentPage = 1;
  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    pokemonCardsFuture = fetchCards(currentPage);
  }

  Future<List<PokemonCard>?> fetchCards(int page) async {
    if (isLoading || !hasMoreData) return null;

    setState(() {
      isLoading = true;
      print('loading');
    });

    final List<PokemonCard>? cards = await RemoteService().getCards(query: 'set.id:${widget.setId ?? 'xy'}', pageNumber: page);

    print('OLHA ISSO $cards');
    setState(() {
      isLoading = false;
    });

    if (cards != null) {
      if (cards.isEmpty) {
        // Se a resposta da API estiver vazia, não há mais dados
        setState(() {
          hasMoreData = false;
        });
      } else {
        setState(() {
          if (page == 1) {
            cardsList = cards;
          } else {
            cardsList.addAll(cards);
          }
          currentPage++;
          print('page: $currentPage');
        });
      }
    }

    return cards;
  }



  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMoreData) {
      fetchCards(currentPage);
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
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
          });
        },
        title: widget.setId!,
      ),
      
      body: FutureBuilder<List<PokemonCard>?>(
        future: pokemonCardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os dados'));
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Sem dados disponíveis'));
          } else {
            List<PokemonCard> cardsList = snapshot.data!;
            print('cardList: ${cardsList.length}');

            return  GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
              ),
              itemCount: cardsList.length + (isLoading ? 1 : 0),
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index == cardsList.length) {
                  // Verifique se há mais itens para carregar antes de mostrar o indicador
                  if (isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!hasMoreData) {
                    return const Center(child: Text('Todos os dados foram carregados.'));
                  } else {
                    return Container(); // Caso contrário, retorne um contêiner vazio
                  }
                }

                var item = cardsList[index];
                return CardWidget(pokemonCard: item);
              },
            );

          }
        },
      ),
    );
  }
}
