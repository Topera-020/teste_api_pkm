import 'package:flutter/material.dart';
import 'package:pokelens/widgets/card_size_selector_widget.dart';

// ignore: must_be_immutable
class FiltersTab extends StatefulWidget {
  final ValueChanged<String> onSortingChanged;
  final ValueChanged<int> onOrderChanged;
  final ValueChanged<int> onCardSizeChanged;
  final List<String> sortingList;
  int selectedCardSize;
  String sortingOption;
  int selectedOrderIndex;


  FiltersTab({
    super.key,
    required this.sortingList,
    required this.onSortingChanged,
    required this.onOrderChanged,
    required this.selectedCardSize,
    required this.onCardSizeChanged,
    this.sortingOption = 'Name',
    this.selectedOrderIndex = 0,
  });

  @override
  FiltersTabState get createState => FiltersTabState();
}

class FiltersTabState extends State<FiltersTab> {  

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
                selectedCardSize: widget.selectedCardSize,
                onChanged: (int? newSize) {
                  setState(() {
                    widget.selectedCardSize = newSize ?? widget.selectedCardSize;
                  });
                  widget.onCardSizeChanged(widget.selectedCardSize);
                },
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
                    child: Text(
                      'Critério de Ordenação:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                    child: DropdownButton<String>(
                      value: widget.sortingOption,
                      items: widget.sortingList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? selectedValue) {
                        if (selectedValue != null) {
                          setState(() {
                            widget.sortingOption = selectedValue;
                          });
                          widget.onSortingChanged(widget.sortingOption);
                        }
                      },
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
                    isSelected: [widget.selectedOrderIndex == 0, widget.selectedOrderIndex == 1],
                    onPressed: (int index) {
                      setState(() {
                        if (widget.selectedOrderIndex != index) {
                          widget.selectedOrderIndex = index;
                        }
                      });
                      widget.onOrderChanged(widget.selectedOrderIndex);
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
