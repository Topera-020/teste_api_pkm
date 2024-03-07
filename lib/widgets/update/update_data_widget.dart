
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pokelens/data/database_helper.dart';
import 'package:pokelens/services/update_services.dart';
import 'package:pokelens/widgets/update/snack_bar_widget.dart';
import 'package:pokelens/widgets/update/delete_confirmation_widget.dart';

class UpdateDataWidget extends StatefulWidget {
  const UpdateDataWidget({super.key});

  @override
  UpdateDataWidgetState get createState => UpdateDataWidgetState();
}

class UpdateDataWidgetState extends State<UpdateDataWidget> {
  int countPokemonDB = 0;
  int countPokemonAPI = 0;
  int countCollectionsDB = 0;
  int countCollectionsAPI = 0;
  int progress = 0;
  bool isUpdating = false;
  int progressGoal = 1;  

  @override
  void initState() {
    super.initState();
    cauntData();
  }

  Future<void> updateDB() async {
    progress = 0;
    print('update collections');
    if (mounted) {setState(() {isUpdating = true;});}
    
    await updateCollections(() => setState(() {}));
    
    await cauntData();
    if (mounted) {setState(() {});}
    
    await updatePokemonCards(() => setState(() {}));

    await cauntData();
    if (mounted) {setState(() {isUpdating = false;});}
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        Text(
          'Quantidade de Sets baixados: $countCollectionsDB de $countCollectionsAPI',
          style: const TextStyle(fontSize: 18.0),
        ),
        Text(
          'Quantidade de Cartas baixadas: $countPokemonDB de $countPokemonAPI',
          style: const TextStyle(fontSize: 18.0),
        ),
        const SizedBox(height: 20),
        IgnorePointer(
          ignoring: isUpdating,
          child: ElevatedButton(
            onPressed: isUpdating ? null : updateDB,
            child: const Text('Atualizar dados'),
          ),
        ),
        if (isUpdating)
          Column(
            children: [
              LinearProgressIndicator(
                value: (progress /progressGoal),
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Progresso: ${(progress / progressGoal * 100).toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
        ElevatedButton(
          onPressed: (countPokemonDB == 0 && countCollectionsDB == 0 || isUpdating)
              ? null // Botão desativado se countPokemonDB ou countCollectionsDB for 0
              : () async {
                  bool? confirmDelete = await showDeleteConfirmationDialog(context);

                  if (confirmDelete!) {
                    // Executar exclusão
                    await PokemonDatabaseHelper.instance.removeAllCollections();
                    await PokemonDatabaseHelper.instance.removeAllPokemonCards();
                    //await PokemonDatabaseHelper.instance.removeAllUserData();
                    await cauntData();

                    if (mounted) {setState(() {});}

                    showSnackBar('Dados excluídos com sucesso!', context);
                  }
                },
          child: const Text('Excluir dados gerais'),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text('Exportar dados'),
        ),
        const ElevatedButton(
          onPressed: null,
          child: Text('Importar dados'),
        ),
      ],
    );
  }
}