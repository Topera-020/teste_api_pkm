import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool isSearchExpanded;
  final ValueChanged<bool> onSearchToggled;
  final ValueChanged<String> onSearchChanged;
  final String title;

  const CustomAppBar({
    Key? key,
    required this.searchController,
    required this.isSearchExpanded,
    required this.onSearchToggled,
    required this.onSearchChanged,
    required this.title,
  }) : super(key: key);

  @override
  CustomAppBarState createState() => CustomAppBarState();
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedCrossFade(
        firstChild: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        secondChild: TextField(
          controller: widget.searchController,
          onChanged: (value) {
            widget.onSearchChanged(value);
          },
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Pesquisar',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        crossFadeState: widget.isSearchExpanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
      backgroundColor: Colors.red[700],
      actions: [
        IconButton(
          icon: Icon(widget.isSearchExpanded ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              widget.onSearchToggled(!widget.isSearchExpanded);
              if (!widget.isSearchExpanded) {
                widget.searchController.clear();
              }
            });
          },
        ),
      ],
    );
  }
}
