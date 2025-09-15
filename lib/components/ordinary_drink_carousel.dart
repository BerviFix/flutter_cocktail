import 'package:flutter/material.dart';
import 'package:flutter_cocktail/components/drink_card.dart';
import 'package:flutter_cocktail/models/cocktail.dart';
import 'package:flutter_cocktail/pages/cocktail_detail_page.dart';

class OrdinaryDrinkCarousel extends StatelessWidget {
  final List<Cocktail> drinks;

  const OrdinaryDrinkCarousel({super.key, required this.drinks});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.76;
    final cardHeight = 220.0;

    return SizedBox(
      height: cardHeight,
      child: CarouselView(
        scrollDirection: Axis.horizontal,
        itemExtent: cardWidth,
        onTap: (index) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CocktailDetailPage(
                cocktailId: drinks[index].id,
                cocktailName: drinks[index].name,
              ),
            ),
          );
        },
        children: drinks.map((drink) {
          return DrinkCard(cocktail: drink);
        }).toList(),
      ),
    );
  }
}
