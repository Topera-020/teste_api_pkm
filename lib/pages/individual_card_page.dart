import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:pokelens/widgets/collections_widget.dart';

class IndividualCardPage extends StatelessWidget {
  final PokemonCard pokemonCard;

  const IndividualCardPage({Key? key, required this.pokemonCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonCard.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 530,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Image.network(
                  pokemonCard.large,
                  width: double.infinity,
                  height: 530,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text('Id único: ${pokemonCard.id}'),
              Text('nationalPokedexNumbers: ${pokemonCard.nationalPokedexNumbers.join(', ')}'),
              Text('Classe: ${pokemonCard.supertype} - ${pokemonCard.subtypes.join(', ')}'),
              Text('Tipo: ${pokemonCard.types.join(', ')}'),
              Text('HP: ${pokemonCard.hp}'),
              Text('Artista: ${pokemonCard.artist}'),
              Text('Número na coleção: ${pokemonCard.number}'),
              Text('Nome da coleção: ${pokemonCard.collectionName}'),
              Text('Custo de recuo: ${pokemonCard.convertedRetreatCost}'),
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  child: FutureBuilder<Collection?>(
                    future: PokemonDatabaseHelper.instance.getCollectionById(pokemonCard.collectionId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Erro ao carregar a coleção: ${snapshot.error}');
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return CollectionsCardWidget(collection: snapshot.data!);
                      } else {
                        return const Text('Coleção não encontrada.');
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
