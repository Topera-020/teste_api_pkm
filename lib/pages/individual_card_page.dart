import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/data/extensions/database_tags.dart';
import 'package:pokelens/models/collections_models.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:pokelens/widgets/card_action_widget.dart';
import 'package:pokelens/widgets/collections_widget.dart';
import 'package:pokelens/widgets/info_text_widget.dart';

class IndividualCardPage extends StatefulWidget {
  final PokemonCard pokemonCard;
  final Future<Collection?> collectionFuture;

  const IndividualCardPage({
    super.key,
    required this.pokemonCard,
    required this.collectionFuture,
  });

  @override
  IndividualCardPageState get createState => IndividualCardPageState();
}

class IndividualCardPageState extends State<IndividualCardPage> {
  late List<bool> isSelected;
  late List<String> tags = []; // Adiciona uma lista para armazenar as tags

  @override
  void initState() {
    super.initState();
    isSelected = [widget.pokemonCard.tenho, widget.pokemonCard.preciso];
  }
                       
                        
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonCard.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // imagem da carta
              Container(
                width: double.infinity,
                height: 530,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Image.network(
                  widget.pokemonCard.large,
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
                        Icons.image_not_supported,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(minWidth: 150), // Defina um tamanho mínimo adequado
                    child: buildRoundIconButton(
                      selectedText: 'Tenho',
                      unselectedText: 'Não tenho',
                      icon: Icons.check,
                      isSelected: widget.pokemonCard.tenho,
                      onPressed: () {
                        //print('${widget.pokemonCard.tenho} ${widget.pokemonCard.id} 1');
                        PokemonDatabaseHelper.instance.cardTagAssociate(
                          associated: widget.pokemonCard.tenho,
                          cardId: widget.pokemonCard.id,
                          tagId: '1'
                          );

                      

                        setState(() {
                          widget.pokemonCard.tenho = !widget.pokemonCard.tenho;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16), // Adicione um espaço entre os botões se necessário
                  Container(
                    constraints: const BoxConstraints(minWidth: 150), // Defina um tamanho mínimo adequado
                    child: buildRoundIconButton(
                      selectedText: 'Preciso',
                      unselectedText: 'Não preciso',
                      icon: Icons.remove_red_eye,
                      isSelected: widget.pokemonCard.preciso,
                      onPressed: () {
                        //print('${widget.pokemonCard.preciso} ${widget.pokemonCard.id} 2');
                        PokemonDatabaseHelper.instance.cardTagAssociate(
                          associated: widget.pokemonCard.preciso,
                          cardId: widget.pokemonCard.id,
                          tagId: '2'
                          );

                        

                        setState(() {
                          widget.pokemonCard.preciso = !widget.pokemonCard.preciso;
                        });
                      },
                    ),
                  ),
                ],
              ),

              InfoTextWidget(
                title: 'número:',
                text: widget.pokemonCard.numberINT.toString(),
              ),
              // informações
              InfoTextWidget(
                title: 'Nome:',
                text: widget.pokemonCard.name,
              ),
              InfoTextWidget(
                title: 'Classe:',
                text: widget.pokemonCard.supertype,
              ),
              InfoTextWidget(
                title: 'Sub-classe:',
                text: widget.pokemonCard.subtypes.join(', '),
              ),
              InfoTextWidget(
                title: 'Tipo:',
                text: widget.pokemonCard.types.join(', '),
              ),
              if (widget.pokemonCard.hp.isNotEmpty)
                InfoTextWidget(
                  title: 'HP:',
                  text: widget.pokemonCard.hp,
                ),
              InfoTextWidget(
                title: 'Número na Pokédex:',
                text: widget.pokemonCard.nationalPokedexNumbers.join(', '),
              ),
              InfoTextWidget(title: 'Artista:', text: widget.pokemonCard.artist),
              InfoTextWidget(
                title: 'Número na coleção:',
                text: widget.pokemonCard.number,
              ),
              InfoTextWidget(
                title: 'Custo de recuo:',
                text: widget.pokemonCard.convertedRetreatCost.toString(),
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: FutureBuilder<Collection?>(
                  future: widget.collectionFuture,
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
            ],
          ),
        ),
      ),
    );
  }
}
