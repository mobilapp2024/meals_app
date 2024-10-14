import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/database/favorites_database.dart';  // Adjust the path as necessary

class FavoriteMealsNotifier extends StateNotifier<List<Meal>> {
  FavoriteMealsNotifier(this._allMeals) : super([]) {
    _loadFavorites();
  }

  final List<Meal> _allMeals;

  Future<void> _loadFavorites() async {
    final favoriteIds = await FavoritesDatabase.instance.getFavorites();

    // Create a set for fast lookup
    final favoriteIdsSet = Set.from(favoriteIds);

    // Filter the meals based on favorite IDs
    state = _allMeals.where((meal) => favoriteIdsSet.contains(meal.id)).toList();
  }

  Future<bool> toggleMealFavoriteStatus(Meal meal) async {
    final mealIsFavorite = state.contains(meal);

    if (mealIsFavorite) {
      state = state.where((m) => m.id != meal.id).toList(); // Remove from state
      await FavoritesDatabase.instance.removeFavorite(meal.id); // Remove from database
      return false; // Return false if the meal was removed
    } else {
      state = [...state, meal]; // Add to state
      await FavoritesDatabase.instance.insertFavorite(meal.id); // Add to database
      return true; // Return true if the meal was added
    }
  }
}

final mealsProvider = Provider<List<Meal>>((ref) {
  return dummyMeals;
});

// Provider for the FavoriteMealsNotifier
final favoriteMealsProvider = StateNotifierProvider<FavoriteMealsNotifier, List<Meal>>((ref) {
  final allMeals = ref.watch(mealsProvider); // Get the list of all meals from another provider
  return FavoriteMealsNotifier(allMeals); // Pass the list to the notifier
});
