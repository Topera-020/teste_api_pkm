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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
            'Tamanho dos Cards',
            style: TextStyle(
              fontSize: 16, // Adjust font size based on your design
              fontWeight: FontWeight.bold,)
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
