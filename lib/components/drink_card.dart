import 'package:flutter/material.dart';
import '../models/cocktail.dart';
import '../pages/cocktail_detail_page.dart';

class DrinkCard extends StatelessWidget {
  final Cocktail cocktail;

  const DrinkCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CocktailDetailPage(
              cocktailId: cocktail.id,
              cocktailName: cocktail.name,
            ),
          ),
        );
      },
      child: Hero(
        tag: 'cocktail-${cocktail.id}',
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.hardEdge,
          elevation: 6,
          child: Stack(
            children: [
              Image.network(
                cocktail.imgUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.70),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.75),
                      ],
                      stops: const [0, 0.5, 1],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Text(
                  cocktail.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        blurRadius: 12,
                        color: Colors.black38,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      // child: Hero(
      //   tag: 'cocktail-${cocktail.id}',
      //   child: Material(
      //     child: Container(
      //       margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      //       decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(16),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.black.withValues(alpha: 0.15),
      //             blurRadius: 18,
      //             offset: const Offset(0, 6),
      //           ),
      //         ],
      //         image: DecorationImage(
      //           image: NetworkImage(cocktail.imgUrl),
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //       child: Stack(
      //         children: [
      //           Positioned.fill(
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(16),
      //                 gradient: LinearGradient(
      //                   colors: [
      //                     Colors.black.withValues(alpha: 0.70),
      //                     Colors.transparent,
      //                     Colors.black.withValues(alpha: 0.75),
      //                   ],
      //                   stops: const [0, 0.5, 1],
      //                   begin: Alignment.bottomCenter,
      //                   end: Alignment.topCenter,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Positioned(
      //             left: 16,
      //             right: 16,
      //             bottom: 16,
      //             child: Text(
      //               cocktail.name,
      //               style: const TextStyle(
      //                 fontSize: 16,
      //                 color: Colors.white,
      //                 fontWeight: FontWeight.w600,
      //                 shadows: [
      //                   Shadow(
      //                     blurRadius: 12,
      //                     color: Colors.black38,
      //                     offset: Offset(0, 2),
      //                   ),
      //                 ],
      //               ),
      //               maxLines: 2,
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
