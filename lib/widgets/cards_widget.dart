// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pokelens/models/card_models.dart';

class CardWidget extends StatefulWidget {
  final PokemonCard pokemonCard;

  const CardWidget({
    Key? key,
    required this.pokemonCard,
  }) : super(key: key);

  @override
  CardWidgetState get createState => CardWidgetState();
}

class CardWidgetState extends State<CardWidget> {
  int checkboxState = 0; // 0 - Branco, 1 - Verde, 2 - Vermelho

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Center(
                  child: Image.network(
                    widget.pokemonCard.smallImg!,
                    fit: BoxFit.cover,
                  ),
                ),
                
                buildCardInfo(context, constraints),
                buildCheckbox(),
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
          checkboxState = (checkboxState + 1) % 3; // Alternar entre 0, 1 e 2
        });
      },
      splashColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
      highlightColor: Colors.transparent,
    );
  }

  Widget buildCardInfo(BuildContext context, BoxConstraints constraints) {
    switch (checkboxState) {
      case 1:
        break;
      case 2:
        break;
      default:
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: Offset(0.0, constraints.maxHeight * 0.7),
          child: buildCardName(constraints),
        ),
      ],
    );
  }


  Widget buildCheckbox() {
    Color checkboxColor;
    switch (checkboxState) {
      case 1:
        checkboxColor = Colors.green;
        break;
      case 2:
        checkboxColor = Colors.red;
        break;
      default:
        checkboxColor = Colors.green[100]!;
    }

    return Positioned(
      bottom: 1.0,
      right: 2.0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            checkboxState = (checkboxState + 1) % 3; // Alternar entre 0, 1 e 2
          });
        },
        child: Container(
          width: 25.0,
          height: 25.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green, width: 2.0),
            color: checkboxColor,
            
          ),
          child: checkboxState == 1
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20.0,
                )
              : null,
        ),
      ),
    );
  }


  Widget buildCardName(BoxConstraints constraints) {
    Color textColor;
    switch (checkboxState) {
      case 1:
        textColor = Colors.green.withOpacity(0.8);
        break;
      case 2:
        textColor = Colors.red.withOpacity(0.8);
        break;
      default:
        textColor = Colors.white.withOpacity(0.8);
    }

    return Container(
      
      width: constraints.maxWidth,
      color: textColor,
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
    );
  }
}
