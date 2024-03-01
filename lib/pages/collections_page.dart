// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/widgets/app_bar_widget.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/widgets/drawer_widget.dart';
import 'package:pokelens/widgets/sets_widget.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  CollectionsPageState get createState => CollectionsPageState();
}

class CollectionsPageState extends State<CollectionsPage> {
  List<Collection> pokemonCollections = [];

  TextEditingController searchController = TextEditingController();
  bool isSearchExpanded = false;

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
      });
    
  }

  Future<void> addCollection() async {
    // Exemplo: Adicionar instância de Collection com dados fictícios
    Collection newCollection = Collection(
      id: 'xy1',
      name: 'XY',
      series: 'XY',
      printedTotal: 134,
      total: 140,
      ptcgoCode: 'XY',
      releaseDate: '2014/02/05',
      symbolImg: 'https://images.pokemontcg.io/xy1/symbol.png',
      logoImg: 'https://images.pokemontcg.io/xy1/logo.png',
    );
    try {
      await PokemonDatabaseHelper.instance.insertCollection(newCollection);
      fetchData(); // Atualiza a lista após adicionar uma nova coleção
    } catch (e) {
      print('Error adding collection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao adicionar a coleção. Tente novamente.'),
        ),
      );
    }
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
        title: 'Séries',
      ),
      drawer: const DrawerWidget(),
      body: pokemonCollections.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma coleção disponível.',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: pokemonCollections.length,
              itemBuilder: (context, index) {
                return SetsCardWidget(
                  collection: pokemonCollections[index],
                );
              },
            ),
      
    );
  }
}
