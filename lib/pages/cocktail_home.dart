import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cocktail/components/cocktail_grid.dart';
import 'package:flutter_cocktail/components/ordinary_drink_carousel.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:http/http.dart' as http;

class CocktailHome extends StatefulWidget {
  const CocktailHome({super.key});
  @override
  State<CocktailHome> createState() => _CocktailHomeState();
}

class _CocktailHomeState extends State<CocktailHome> {
  late Future<void> _loadFuture;
  List<Cocktail> ordinaryDrinks = [];
  List<Cocktail> cocktails = [];

  @override
  void initState() {
    super.initState();
    _loadFuture = _loadData();
  }

  Future<void> _loadData() async {
    final resOrdinary = await http.get(
      Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Ordinary_Drink',
      ),
    );
    final resCocktail = await http.get(
      Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail',
      ),
    );
    setState(() {
      final ordinaryData = json.decode(resOrdinary.body)['drinks'] as List?;

      ordinaryDrinks =
          ordinaryData
              ?.take(6)
              .map((drink) => Cocktail.fromJson(drink))
              .toList() ??
          [];

      final cocktailData = json.decode(resCocktail.body)['drinks'] as List?;

      cocktails =
          cocktailData
              ?.take(6)
              .map((drink) => Cocktail.fromJson(drink))
              .toList() ??
          [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (context, snapshot) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 6),
              child: Text(
                "Ordinary Drink",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ordinaryDrinks.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : OrdinaryDrinkCarousel(drinks: ordinaryDrinks),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 26, 18, 6),
              child: Text(
                "Cocktail",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: cocktails.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CocktailGrid(drinks: cocktails),
            ),
            const SizedBox(height: 48),
          ],
        );
      },
    );
  }
}
