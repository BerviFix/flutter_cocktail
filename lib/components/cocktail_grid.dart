import 'package:flutter/material.dart';
import 'package:flutter_cocktail/components/drink_card.dart';

class CocktailGrid extends StatelessWidget {
  final List<dynamic> drinks;

  const CocktailGrid({super.key, required this.drinks});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisSpacing = 18.0;
    final itemWidth = (screenWidth - crossAxisSpacing * 3) / 2;
    final itemHeight = 215.0;

    return GridView.builder(
      itemCount: drinks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 18,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: itemWidth / itemHeight,
      ),
      itemBuilder: (context, idx) {
        final drink = drinks[idx];
        return DrinkCard(cocktail: drink);
      },
    );
  }
}
