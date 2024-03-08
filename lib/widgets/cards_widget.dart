
import 'package:flutter/material.dart';
import 'package:pokelens/data/extensions/database_collections.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/models/pokemon_card_model.dart';
import 'package:pokelens/pages/individual_card_page.dart';

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
            ThemeData theme = Theme.of(context); // Obtenha o ThemeData do contexto

            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0), // Ajuste o valor conforme necessário
                  child: Image.network(
                    widget.pokemonCard.small,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        // A imagem foi carregada com sucesso
                        return child;
                      } else {
                        // A imagem ainda está sendo carregada, você pode mostrar um indicador de carregamento aqui
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Center(child: Icon(Icons.broken_image_outlined, color: Theme.of(context).iconTheme.color));
                    },
                  ),
                ),

                buildCardName(constraints, theme),
                buildTags(constraints, theme),
                buildInkWell(context),
              ],
            );
          },
        ),
      ),
    );
  }

  InkWell buildInkWell(BuildContext context) {
    return InkWell(
      onTap: () async {
        final collections = await PokemonDatabaseHelper.instance.getCollections(
          collectionId: [widget.pokemonCard.collectionId],
        );

        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => IndividualCardPage(
                pokemonCard: widget.pokemonCard,
                collectionFuture: Future.value(collections.isNotEmpty ? collections.first : null),
              ),
            ),
          );
        });
      },
      splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      highlightColor: Colors.transparent,
    );
  }

  


  Widget buildCardName(BoxConstraints constraints, ThemeData theme) {
    return Positioned(
      top: constraints.maxHeight * 0.72,
      left: 0,
      right: 0,
      child: Container(
        color: theme.brightness == Brightness.light
            ? Colors.white.withOpacity(0.8)
            : Colors.black.withOpacity(0.8),
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


  Widget buildTags(BoxConstraints constraints, ThemeData theme) {
    return Positioned(
      right: constraints.maxWidth * 0.01,
      top: constraints.maxHeight * 0.03,
      child: Column(
        children: [

          (widget.pokemonCard.tenho)
              ? CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 20, 142, 24),
                  radius: constraints.maxWidth * 0.1, // Ajuste conforme necessário
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: constraints.maxWidth * 0.2, // Ajuste conforme necessário
                  ),
                )
              : Container(),
          (widget.pokemonCard.preciso)
              ? CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: constraints.maxWidth * 0.1, // Ajuste conforme necessário
                  child: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                    size: constraints.maxWidth * 0.15, // Ajuste conforme necessário
                  ),
                )
              : Container(),
          
        ],
      ),
    );
  }


}
