import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:pokelens/widgets/drawer_widget.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  TestPageState get createState => TestPageState();
}

class TestPageState extends State<TestPage> {
  List<Collection> pokemonCollections = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final List<Collection> collections = await PokemonDatabaseHelper.instance.getCollections();
    setState(() {
      pokemonCollections = collections;
    });
  }

  Future<void> addPokemonCard() async {
    // Exemplo: Adicionar instância de PokemonCard com dados fictícios
    PokemonCard newCard = PokemonCard(
      id: DateTime.now().toString(), // Pode usar alguma lógica para gerar um ID único
      name: 'New Pokemon',
      small: 'small_image_url',
      large: 'large_image_url',
      supertype: 'supertype',
      subtypes: ['subtype1', 'subtype2'],
      hp: '100',
      types: ['Type1', 'Type2'],
      convertedRetreatCost: 2,
      setId: 'set123',
      number: '123',
      artist: 'Artist Name',
      rarity: 'Rare',
      nationalPokedexNumbers: [1, 2, 3],
    );

    await PokemonDatabaseHelper.instance.insertPokemonCard(newCard);
    fetchData(); // Atualiza a lista após adicionar um novo card
  }

  Future<void> addCollection() async {
    // Exemplo: Adicionar instância de PokemonCard com dados fictícios
    Collection newCollection = Collection(
      id: DateTime.now().toString(), // Pode usar alguma lógica para gerar um ID único
      name: 'collectionzzz',
      series: 'xyz',
      printedTotal: 134,
      total: 140,
      ptcgoCode: '',
      releaseDate: '100',
      symbolImg: 'symbolImg_image_url',
      logoImg: 'symbolImg',
    );

    await PokemonDatabaseHelper.instance.insertCollection(newCollection);
    fetchData(); // Atualiza a lista após adicionar um novo card
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      drawer: const DrawerWidget(),
      body: ListView.builder(
        itemCount: pokemonCollections.length,
        itemBuilder: (context, index) {
          final Collection collection = pokemonCollections[index];
          return ListTile(
            title: Text(collection.name),
            subtitle: Text('Type: ${collection.series}'),
          );
        },
      ),
      
    );
  }

  Future<void> _showAddDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Pokemon Card'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Fill in the details for the new Pokemon Card:'),
                // Add TextFields or other input widgets here to capture user input
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call a function to save the new PokemonCard
                await addCollection();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
