import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/services/remote_services.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  LoadingPageState get createState => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  int countPokemonDB = 0;
  int countPokemonAPI = 0;
  int countCollectionsDB = 0;
  int countCollectionsAPI = 0;

  @override
  void initState() {
    super.initState();
    quantidadeDados();
  }

  Future<void> quantidadeDados() async {
    countPokemonAPI = await RemoteService().getQuantidadeDeCartas();
    countCollectionsAPI = await RemoteService().getQuantidadeDeSets();
    countPokemonDB = await PokemonDatabaseHelper.instance.countPokemon();
    countCollectionsDB = await PokemonDatabaseHelper.instance.countCollections();
    setState(() {});
  }

  Future<void> atualizarDB() async {
    // Adicione aqui a lógica para atualizar o banco de dados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Carregamento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox( height: 20.0, ),
            Text('Quantidade de Sets baixados: $countCollectionsDB de $countCollectionsAPI', 
            style: TextStyle(fontSize: 18.0, ),),
            Text('Quantidade de Cartas baixadas: $countPokemonDB de $countPokemonAPI',
            style: TextStyle(fontSize: 18.0,),),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: atualizarDB,
              child: const Text('Atualizar dados'),
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
