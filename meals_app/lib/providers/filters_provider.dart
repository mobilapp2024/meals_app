import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

/// Enum representing different dietary filters.
enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

/// Manages the state of dietary filters using StateNotifier.
class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  /// Sets all filters at once by replacing the state with the provided map.
  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  /// Sets the status of a single filter (on or off).
  /// 
  /// [filter]: The filter being updated.
  /// [isActive]: The new status of the filter (true for active, false for inactive).
  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

/// Provides access to the current state of dietary filters.
final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

/// Provides a filtered list of meals based on the active dietary filters.
final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  
  /// Filters the meals based on the active dietary preferences.
  return meals.where((meal) {
      if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (activeFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
});
