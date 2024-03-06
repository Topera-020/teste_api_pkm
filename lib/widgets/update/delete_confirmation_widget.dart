
import 'package:flutter/material.dart';

Future<bool?> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Tem certeza que deseja excluir os dados?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancelar exclusão
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirmar exclusão
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }