// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:teste_api/models/collections_models.dart';
import 'package:teste_api/views/card_page.dart';

class SetsCardWidget extends StatelessWidget {
  final Collection collection;

  const SetsCardWidget({
    Key? key,
    required this.collection,
  }) : super(key: key);

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
                        buildLogoImage(constraints),
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

  Widget buildLogoImage(BoxConstraints constraints) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(constraints.maxWidth / 10),
        child: Image.network(
          collection.logo,
          height: constraints.maxHeight * 0.4,
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
        collection.symbol,
        width: constraints.maxWidth / 5,
        height: constraints.maxHeight / 5,
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
          fontSize: constraints.maxWidth * 0.07,
        ),
      ),
    );
  }

Widget buildInkWell(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CardPage(setId: collection.id),
        ),
      );

    },
    splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
    highlightColor: Colors.transparent,
  );
}

}