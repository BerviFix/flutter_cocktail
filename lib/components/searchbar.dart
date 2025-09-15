import 'package:flutter/material.dart';

class SearchBarStateful extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool loading;

  const SearchBarStateful({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.loading,
  });

  @override
  State<SearchBarStateful> createState() => _SearchBarStatefulState();
}

class _SearchBarStatefulState extends State<SearchBarStateful> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_textChanged);
  }

  void _textChanged() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      controller: widget.controller,
      hintText: 'Cerca un cocktail (es. Margarita)...',
      leading: _hasText
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                widget.controller.clear();
                widget.onSearch();
              },
            )
          : const Icon(Icons.local_bar_outlined),
      trailing: [
        widget.loading
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: widget.onSearch,
              ),
      ],
      onSubmitted: (_) => widget.onSearch(),
      elevation: MaterialStateProperty.all(3),
    );
  }
}
