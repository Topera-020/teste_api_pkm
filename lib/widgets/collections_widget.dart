
import 'package:flutter/material.dart';
import 'package:pokelens/models/collections_models.dart';


class CollectionsCardWidget extends StatelessWidget {
  final Collection collection;

  const CollectionsCardWidget({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: Card(
          elevation: 4,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildLogoImage(context, constraints),
                        buildCollectionInfo(context, constraints),
                      ],
                    ),
                  ),
                  buildInkWell(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
  Color getShadowColor(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      // Se o tema atual for escuro (dark), retorne a cor branca
      return Colors.white.withOpacity(0.1);
    } else {
      // Se o tema atual for claro (light), retorne a cor preta (ou qualquer outra cor desejada)
      return Colors.black.withOpacity(0.1);
    }
  }

  Widget buildLogoImage(BuildContext context, BoxConstraints constraints) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: getShadowColor(context),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 3),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          child: Container(
            padding: EdgeInsets.all(constraints.maxWidth / 10),
            child: Image.network(
              collection.logoImg,
              height: constraints.maxHeight * 0.4,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                   return const Center(child: CircularProgressIndicator());
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Icon(Icons.broken_image_outlined, color: Theme.of(context).iconTheme.color);
              },
            ),
          ),
        ),
      ),

    );
  }

  Widget buildCollectionInfo(BuildContext context, BoxConstraints constraints) {
    return Row(
      children: [
        buildSymbolImage(constraints),
        buildCollectionName(constraints),
      ],
    );
  }

  Widget buildSymbolImage(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.all(constraints.maxWidth / 20),
      child: Image.network(
        collection.symbolImg,
        width: constraints.maxWidth / 5,
        height: constraints.maxHeight / 5,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              // A imagem foi carregada com sucesso
              return child;
            } else {
              // A imagem ainda está sendo carregada, você pode mostrar um indicador de carregamento aqui
              return const Center(child: CircularProgressIndicator());
            }
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            // Ocorreu um erro durante o carregamento da imagem, mostra um Container como ícone padrão
            return Icon(Icons.error, color: Theme.of(context).iconTheme.color);
          },
      ),
    );
  }

  Widget buildCollectionName(BoxConstraints constraints) {
    return Expanded(
      child: Text(
        collection.name,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: constraints.maxWidth * 0.09,
        ),
      ),
    );
  }

Widget buildInkWell(BuildContext context) {
  return InkWell(
    onTap: () {
      print('CollectionWidget: collection ${collection.id}'); 
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushNamed(
        context,
        '/cardsPage',
        arguments: {
          'collection': collection,
        },
      );
    },
    splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
    highlightColor: Colors.transparent,
  );
}

}