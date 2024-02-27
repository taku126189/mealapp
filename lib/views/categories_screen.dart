import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/views/meals_screen.dart';
import 'package:meals_app/widgets/catergory_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.onToggledMealFavoriteStatus,
      required this.availableMeals});
  // To pass available meals in FiltersScreen to CategoriesScreen
  final List<Meal> availableMeals;

// When the user tapped a grid, the UI needs to be updated, updating the state, but StatelessWidget cannot do it
// So instead of updating, navigate
// This method needs to take context for Navigator.of(context) and needs to take category
  void _selectCategory(BuildContext context, Category category) {
    // where method is for filtering a list and returns Iterable that only contains the items that match a certain condition
    // You need to pass a method to where so Dart will automatically execute for every item in the list (i.e., dummyMeals)
    // It returns true if you want to keep the newly created list
    // category.id is Category category passed in  void _selectCategory(BuildContext context, Category category)
    // This logic returns true if the category id selected
    final filteredMeals = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
          onToggledMealFavoriteStatus: onToggledMealFavoriteStatus,
        ),
      ),
    );
  }

  final void Function(Meal meal) onToggledMealFavoriteStatus;

  @override
  Widget build(BuildContext context) {
    return
        // You need GridView.builder if the grids are very long potentially
        GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        // An alternative way is availableCategories.map((category) => CategoryGridItem(category: category)).toList()
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              // category passed below is category in for (final category in availableCategories)
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
