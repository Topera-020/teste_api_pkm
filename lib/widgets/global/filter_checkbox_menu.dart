import 'package:flutter/material.dart';

class ExpandableListView extends StatefulWidget {
  final List<Item> items;

  const ExpandableListView({super.key, required this.items});

  @override
  _ExpandableListViewState get createState => _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
        elevation: 1,
        expandedHeaderPadding: const EdgeInsets.all(0),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.items[index].isExpanded = !isExpanded;
          });
        },
        children: widget.items.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(item.headerValue),
              );
            },
            body: ListTile(
              title: Text(item.expandedValue),
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}
