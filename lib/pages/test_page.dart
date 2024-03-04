// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/models/collections_models.dart';
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

}