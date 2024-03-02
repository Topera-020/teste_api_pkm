// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:pokelens/models/collections_models.dart';

class SetsCardWidget extends StatelessWidget {
  final Collection collection;

  const SetsCardWidget({
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
          collection.logoImg,
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
        collection.symbolImg,
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
          fontSize: constraints.maxWidth * 0.09,
        ),
      ),
    );
  }

Widget buildInkWell(BuildContext context) {
  return InkWell(
    onTap: () {
      print(collection.toMap());
    },
    splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
    highlightColor: Colors.transparent,
  );
}

}