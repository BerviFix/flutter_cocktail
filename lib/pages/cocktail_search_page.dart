import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cocktail/components/drink_card.dart';
import 'package:flutter_cocktail/components/searchbar.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:http/http.dart' as http;

class CocktailSearchPage extends StatefulWidget {
  const CocktailSearchPage({super.key});
  @override
  State<CocktailSearchPage> createState() => _CocktailSearchPageState();
}

class _CocktailSearchPageState extends State<CocktailSearchPage> {
  final TextEditingController _controller = TextEditingController();

  List<Cocktail>? _results;

  bool _isLoading = false;

  String? _error;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _results = null;
    });

    final res = await http.get(
      Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query',
      ),
    );

    final decoded = json.decode(res.body);

    setState(() {
      final drinks = decoded['drinks'] as List?;
      _results =
          drinks?.map((drink) => Cocktail.fromJson(drink)).toList() ?? [];

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 12),
            child: SearchBarStateful(
              controller: _controller,
              onSearch: () => _search(_controller.text),
              loading: _isLoading,
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (_results == null) {
      return const Center(child: Text('Cerca un cocktail inserendo il nome!'));
    }

    if (_results!.isEmpty) {
      return const Center(child: Text('Nessun cocktail trovato.'));
    }

    return GridView.builder(
      itemCount: _results!.length,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: 18,
        childAspectRatio: 0.76,
      ),
      itemBuilder: (context, idx) {
        final cocktail = _results![idx];
        return DrinkCard(cocktail: cocktail);
      },
    );
  }
}
