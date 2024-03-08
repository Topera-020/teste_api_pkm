import 'package:flutter/material.dart';

class OrderingSelector extends StatelessWidget {
  final String title;

  final List<String> optionsList;
  final String selectedOption;
  final ValueChanged<String> onSortingChanged;
  final bool isAscending;
  final ValueChanged<bool> onAscendingChanged;


  const OrderingSelector({
    super.key,
    required this.onSortingChanged,
    required this.optionsList,
    required this.selectedOption,
    required this.title,

    required this.isAscending, 
    required this.onAscendingChanged,
  });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

         
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width-180,
              child: DropdownButton<String>(
                value: selectedOption,
                
                isExpanded: true,
                items: optionsList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value)),
                  );
                }).toList(),
                onChanged: (String? selectedValue) {
                
                  onSortingChanged(selectedValue!);
                  
                },
              ),
            ),
            IconButton(
              icon: Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              ), onPressed: (){
                onAscendingChanged(!isAscending);
              },
            ),
          ],
        )
      ],
    );
  }
}
