import 'package:flutter/material.dart';

class InfoTextWidget extends StatelessWidget {
  final String title;
  final String text;

  const InfoTextWidget({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 22.0, // Ajuste o tamanho da fonte conforme necessário
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0, // Ajuste o tamanho da fonte conforme necessário
            ),
          ),
        ],
      ),
    );
  }
}
