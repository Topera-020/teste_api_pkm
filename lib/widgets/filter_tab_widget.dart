// FiltersTab.dart

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FiltersTab extends StatefulWidget {
  final ValueChanged<String> onSortingChanged;
  final ValueChanged<int> onOrderChanged;
  final String sortingOption;
  final int selectedOrderIndex;

  const FiltersTab({
    super.key, // Adicione esta linha
    required this.sortingOption,
    required this.selectedOrderIndex,
    required this.onSortingChanged,
    required this.onOrderChanged,
  }); // Adicione esta linha

  @override
  FiltersTabState get createState => FiltersTabState();
}

class FiltersTabState extends State<FiltersTab> {
  late String selectedSorting;
  late int selectedOrderIndex;

  @override
  void initState() {
    super.initState();
    // Inicialize os valores no initState para garantir que sejam definidos corretamente
    selectedSorting = widget.sortingOption;
    selectedOrderIndex = widget.selectedOrderIndex;
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        widget.onSortingChanged(selectedSorting);
                      });
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
                      widget.onOrderChanged(selectedOrderIndex);
                    }
                  });
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
    );
  }
}
