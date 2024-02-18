import 'package:flutter/material.dart';
import 'package:pokelens/data/repositories/colections_repository.dart';
import 'package:pokelens/data/repositories/pokemon_cards_repository.dart';
import 'package:pokelens/services/remote_services.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  LoadingPageState get createState => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  int qntCartasDB = 0;
  int qntCartasAPI = 0;
  int qntSetsDB = 0;
  int qntSetsAPI = 0;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    qntCartasDB = await PokemonRepository().getQuantidadeDeCartas();
    qntSetsDB = await CollectionsRepository().getQuantidadeDeSets();
    qntCartasAPI = await RemoteService().getQuantidadeDeCartas();
    qntSetsAPI = await RemoteService().getQuantidadeDeSets();

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
            Text('Quantidade de Sets baixados: $qntSetsDB de $qntSetsAPI'),
            Text('Quantidade de Cartas baixadas: $qntCartasDB de $qntCartasAPI'),
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
