// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/data/extensions/database_pokemon_card.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:pokelens/widgets/drawer_widget.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  TestPageState get createState => TestPageState();
}

class TestPageState extends State<TestPage> {
  List<PokemonCard> cardList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    cardList = await PokemonDatabaseHelper.instance.getPokemonCards() ?? [];
    setState(() {}); // Atualiza o estado para reconstruir o widget com os novos dados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      drawer: const DrawerWidget(),
      body: ListView.builder(
        itemCount: cardList.length,
        itemBuilder: (context, index) {
          final PokemonCard card = cardList[index];
          return ListTile(
            title: Text(card.name),
            subtitle: Text('id: ${card.id}'), 
          );
        },
      ),
    );
  }
}
