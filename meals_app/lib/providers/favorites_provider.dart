import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

/// Manages the list of favorite meals using StateNotifier.
class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier() : super([]);

  /// Toggles the favorite status of a meal.
  /// 
  /// If the meal is already in the list of favorites, it removes it.
  /// If the meal is not in the list, it adds it to the favorites.
  /// 
  /// Returns true if the meal is added to favorites, and false if removed.
  bool toggleMealFavoriteStatus(Meal meal) {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

/// Provides access to the list of favorite meals.
final favoriteMealsProvider = StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  return FavoriteMealsNotifier();
});
