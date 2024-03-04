import 'package:flutter/material.dart';
import 'package:pokelens/widgets/card_size_selector_widget.dart';

class FiltersTab extends StatefulWidget {
  final ValueChanged<String> onSortingChanged;
  final ValueChanged<int> onOrderChanged;
  final int selectedCardSize;
  final ValueChanged<int> onCardSizeChanged;

  const FiltersTab({
    super.key,
    required this.onSortingChanged,
    required this.onOrderChanged,
    required this.selectedCardSize,
    required this.onCardSizeChanged, required String sortingOption, required int selectedOrderIndex,
  });

  @override
  FiltersTabState get createState => FiltersTabState();
}

class FiltersTabState extends State<FiltersTab> {
  late String selectedSorting;
  late int selectedOrderIndex;
  late int selectedCardSize;

  @override
  void initState() {
    super.initState();
    selectedSorting = 'Nome'; // Defina a opção inicial de ordenação conforme necessário
    selectedOrderIndex = 0; // Defina o índice inicial de ordem conforme necessário
    selectedCardSize = widget.selectedCardSize; // Inicialize com o valor fornecido pelo widget pai
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 45, 45),
            ),
            child: Text(
              'Filtros',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardSizeSelector(
                selectedCardSize: selectedCardSize,
                onChanged: (int? newSize) {
                  setState(() {
                    selectedCardSize = newSize ?? selectedCardSize;
                  });
                  // Chame a função de retorno associada ao parâmetro selectedCardSize
                  widget.onCardSizeChanged(selectedCardSize);
                },
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Critério de Ordenação:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      value: selectedSorting,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSorting = newValue!;
                        });
                        // Chame a função de retorno associada ao parâmetro sortingOption
                        widget.onSortingChanged(selectedSorting);
                      },
                      items: <String>['Data', 'Nome']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ordem:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ToggleButtons(
                    isSelected: [selectedOrderIndex == 0, selectedOrderIndex == 1],
                    onPressed: (int index) {
                      setState(() {
                        if (selectedOrderIndex != index) {
                          selectedOrderIndex = index;
                        }
                      });
                      // Chame a função de retorno associada ao parâmetro selectedOrderIndex
                      widget.onOrderChanged(selectedOrderIndex);
                    },
                    children: const <Widget>[
                      Icon(Icons.arrow_upward),
                      Icon(Icons.arrow_downward),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
