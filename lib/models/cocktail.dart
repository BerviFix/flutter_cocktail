class Cocktail {
  final String id;
  final String name;
  final String imgUrl;
  final String? category;
  final String? alcoholic;
  final String? glass;
  final String? instructions;
  final String? instructionsIT;
  final List<Ingredient> ingredients;

  const Cocktail({
    required this.id,
    required this.name,
    required this.imgUrl,
    this.category,
    this.alcoholic,
    this.glass,
    this.instructions,
    this.instructionsIT,
    this.ingredients = const [],
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    // Estrai gli ingredienti
    List<Ingredient> ingredients = [];
    for (int i = 1; i <= 15; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: ingredient.toString(),
            measure: measure?.toString().trim() ?? '',
          ),
        );
      }
    }

    return Cocktail(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? 'Unknown',
      imgUrl: json['strDrinkThumb'] ?? '',
      category: json['strCategory'],
      alcoholic: json['strAlcoholic'],
      glass: json['strGlass'],
      instructions: json['strInstructions'],
      instructionsIT: json['strInstructionsIT'],
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDrink': id,
      'strDrink': name,
      'strDrinkThumb': imgUrl,
      'strCategory': category,
      'strAlcoholic': alcoholic,
      'strGlass': glass,
      'strInstructions': instructions,
      'strInstructionsIT': instructionsIT,
    };
  }
}

class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});
}
