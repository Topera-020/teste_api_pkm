// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pokelens/models/pokemon_card_model.dart';


class CardWidget extends StatefulWidget {
  final PokemonCard pokemonCard;

  const CardWidget({
    super.key,
    required this.pokemonCard,
  });

  @override
  CardWidgetState get createState => CardWidgetState();
}

class CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Image.network(
                  widget.pokemonCard.small,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  fit: BoxFit.cover,
                ),
                buildCardName(constraints),
                buildInkWell(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildInkWell(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          // Adicione a lógica de manipulação do clique, se necessário
        });
      },
      splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      highlightColor: Colors.transparent,
    );
  }

  Widget buildCardName(BoxConstraints constraints) {
    return Positioned(
      top: constraints.maxHeight * 0.75, // Ajuste este valor conforme necessário
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white.withOpacity(0.8),
        padding: const EdgeInsets.fromLTRB(15, 0.6, 2, 0.6),
        child: Text(
          '${widget.pokemonCard.number} - ${widget.pokemonCard.name}',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: constraints.maxWidth * 0.1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


}
