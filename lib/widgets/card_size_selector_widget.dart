import 'package:flutter/material.dart';

class CardSizeSelector extends StatelessWidget {
  final int? selectedCardSize;
  final ValueChanged<int?>? onChanged;

  const CardSizeSelector({
    super.key,
    this.selectedCardSize,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
              'Tamanho dos Cards',
              style: Theme.of(context).textTheme.titleMedium,
            ),
        ),
          
        DropdownButton<int>(
          value: selectedCardSize ?? 3,
          onChanged: onChanged,
          items: const [
            DropdownMenuItem<int>(
              value: 1,
              child: Text('Gigante'),
            ),
            DropdownMenuItem<int>(
              value: 2,
              child: Text('Grande'),
            ),
            DropdownMenuItem<int>(
              value: 3,
              child: Text('Médio'),
            ),
            DropdownMenuItem<int>(
              value: 4,
              child: Text('Pequeno'),
            ),
            DropdownMenuItem<int>(
              value: 5,
              child: Text('Minusculo'),
            ),
          ],
        ),
      ],
    );
  }
}
