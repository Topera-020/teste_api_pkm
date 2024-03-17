
import 'package:flutter/material.dart';

import 'package:pokelens/widgets/global/card_size_selector_widget.dart';
import 'package:pokelens/widgets/global/filter_checkbox_menu.dart';
import 'package:pokelens/widgets/global/ordering_selector_widget.dart';

class FiltersTab extends StatefulWidget {
  //seletor do tamanho dos cards
  final int selectedCardSize;
  final ValueChanged<int> onCardSizeChanged;
  //Lista com possibilidades de ordenação
  final List<String> sortingList;
  //Ordenação primária
  final String primarySortingOption;
  final ValueChanged<String> onPrimarySortingChanged;
  final bool isAscending1;
  final ValueChanged<bool> onPrimaryAscendingChanged;
  //Ordenação Secundária
  final String secondaryOrderByClause;
  final ValueChanged<String> onsecondarySortingChanged;  
  final bool isAscending2;
  final ValueChanged<bool> onsecondaryAscendingChanged;

  const FiltersTab({
    super.key, 
    required this.selectedCardSize,
    required this.onCardSizeChanged, 
    required this.primarySortingOption, 
    required this.sortingList, 
    required this.onPrimarySortingChanged, 
    required this.isAscending1, 
    required this.onPrimaryAscendingChanged, 
    required this.secondaryOrderByClause, 
    required this.onsecondarySortingChanged, 
    required this.isAscending2, 
    required this.onsecondaryAscendingChanged,
  });

  @override
  FiltersTabState get createState => FiltersTabState();
  
  
}

class FiltersTabState extends State<FiltersTab> {
  @override
  Widget build(BuildContext context) {
    List<String> sortingList2 = List.from(widget.sortingList);
    sortingList2.remove(widget.primarySortingOption);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red, // Use a theme color or a variable here
            ),
            child: Text(
              'Filtros',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),

          //CardSize sellection
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CardSizeSelector(
              selectedCardSize: widget.selectedCardSize,
              onChanged: (int? newSize) {
                setState(() {
                  widget.onCardSizeChanged(newSize!);
                });
              },
            ),
          ),
          
          //ordenação primária
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OrderingSelector(
              title: 'Critério de Ordenação Primária:',
              optionsList: widget.sortingList,
              selectedOption: widget.primarySortingOption,
              onSortingChanged: widget.onPrimarySortingChanged, 
              isAscending: widget.isAscending1, 
              onAscendingChanged: widget.onPrimaryAscendingChanged,
            ),
          ),
        
          //ordenação Secundária
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OrderingSelector(
              title: 'Critério de Ordenação Secundária:',
              optionsList: sortingList2,
              selectedOption: widget.secondaryOrderByClause,
              onSortingChanged: widget.onsecondarySortingChanged, 
              isAscending: widget.isAscending2, 
              onAscendingChanged: widget.onsecondaryAscendingChanged,
            ),
          ),
            
          ExpandableListView(
            items: [Item(expandedValue: 'item 1', headerValue: 'item 1', isExpanded: true), Item(expandedValue: 'item 1', headerValue: 'item 1', isExpanded: false),Item(expandedValue: 'item 1', headerValue: 'item 1', isExpanded: false)],
          ),
        ],
      ),
    );
  }
}
