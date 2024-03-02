import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool isSearchExpanded;
  final ValueChanged<bool> onSearchToggled;
  final ValueChanged<String> onSearchChanged;
  final String title;
  final FocusNode searchFocusNode;

  const CustomAppBar({
    super.key,
    required this.searchController,
    required this.isSearchExpanded,
    required this.onSearchToggled,
    required this.onSearchChanged,
    required this.title,
    required this.searchFocusNode,
  });

  @override
  CustomAppBarState get createState => CustomAppBarState();

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
          focusNode: widget.searchFocusNode,
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
      actions: [
        // Botão de pesquisa
        IconButton(
          icon: Icon(widget.isSearchExpanded ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              widget.onSearchToggled(!widget.isSearchExpanded);
              if (!widget.isSearchExpanded) {
                widget.searchController.clear();
                widget.searchFocusNode.unfocus(); // Remover o foco ao limpar
              }
              widget.onSearchChanged('');
            });
          },
        ),
        // Botão para abrir a tab de filtros
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // Isso abrirá a gaveta de filtros
          },
        ),
      ],
    );
  }
}
