import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/cocktail.dart';

class CocktailDetailPage extends StatefulWidget {
  final String cocktailId;
  final String cocktailName;

  const CocktailDetailPage({
    super.key,
    required this.cocktailId,
    required this.cocktailName,
  });

  @override
  State<CocktailDetailPage> createState() => _CocktailDetailPageState();
}

class _CocktailDetailPageState extends State<CocktailDetailPage> {
  Cocktail? _cocktail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCocktailDetail();
  }

  Future<void> _loadCocktailDetail() async {
    final response = await http.get(
      Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${widget.cocktailId}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final drinks = data['drinks'] as List?;

      if (drinks != null && drinks.isNotEmpty) {
        setState(() {
          _cocktail = Cocktail.fromJson(drinks.first);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Cocktail non trovato';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _error = 'Errore nel caricamento del cocktail';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildError()
          : _buildContent(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(_error!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Torna indietro'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_cocktail == null) return const SizedBox();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              _cocktail!.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            background: Hero(
              tag: 'cocktail-${_cocktail!.id}',
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_cocktail!.imgUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCards(),
                const SizedBox(height: 24),
                _buildIngredients(),
                const SizedBox(height: 24),
                _buildInstructions(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        if (_cocktail!.category != null)
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Icon(
                      Icons.category,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _cocktail!.category!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_cocktail!.alcoholic != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Icon(
                      _cocktail!.alcoholic!.toLowerCase().contains('alcoholic')
                          ? Icons.local_bar
                          : Icons.no_drinks,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _cocktail!.alcoholic!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        if (_cocktail!.glass != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Icon(
                      Icons.wine_bar,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _cocktail!.glass!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIngredients() {
    if (_cocktail!.ingredients.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredienti',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: _cocktail!.ingredients.map((ingredient) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          ingredient.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      if (ingredient.measure.isNotEmpty)
                        Text(
                          ingredient.measure,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    // Usa le istruzioni italiane se disponibili, altrimenti quelle inglesi
    final instructions = _cocktail!.instructionsIT?.isNotEmpty == true
        ? _cocktail!.instructionsIT!
        : _cocktail!.instructions;

    if (instructions == null || instructions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preparazione',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              instructions,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ),
        ),
      ],
    );
  }
}
