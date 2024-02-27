import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/views/categories_screen.dart';
import 'package:meals_app/views/filters_screen.dart';
import 'package:meals_app/views/meals_screen.dart';
import 'package:meals_app/widgets/main_drawer.dart';

// naming global variables with intial k
Map<Filter, bool> kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

// this class needs to be StatefulWidget because it changes UI display depending on the user's tap
class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // The first selected page is set to 0, which is the first BottomNavigationBarItem
  int _selectedPageIndex = 0;
  // To store the map the user selected in FiltersScreen. Initial values are all false, but they will be updated after the user interacted with FiltersScreen
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _favoriteNotification(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(message),
      ),
    );
  }

  final List<Meal> _favoriteMeals = [];
  // You want to pass this function to MealDetailsScreen, but TabsScreen does not have access to it, even though it has access to CategoriesScreen and MealsScreen as below
  // So, you need to pass the function to MealDetailsScreen through MealsScreen. First, make the same function in MealDetailScreen, second, make the same on in MealsScreen and lastly, pass this function inside MealsScreen as below. As a result, MealsDetailsScreen triggers the function and the value is passed to this function in TabsScreen
  void _toggleMealFavoriteStatus(Meal meal) {
    // Whether Meal meal this function takes is contained in _favoriteMeals
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals
            .remove(meal); // if meal is contained in the list, remove it
        _favoriteNotification('Deleted from your favorites');
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _favoriteNotification('Added to your favorites');
      });
    }
  }

  void _selectpage(int index) {
    setState(() {
      // Every time a tab of BottomNavigationBarItem is tapped, this method will be executed
      // index is used for switching screens
      _selectedPageIndex = index;
    });
  }

  // add async to use Future
  void _showScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // The user interact with the screen pushed. So the push method is Future. The pop method in FiltersScreen passes back the map(i.e., Filter.glutenFree: _glutenFreeFilterSet.. etc. result variable stores that data
      // push method is a generic method, so specify the kind of data will be returned
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      // Need to rebuild the UI based on the user's filters
      setState(() {
        // assign result variable to _selectedFilters. result variable could be null and if so, take kInitialFilters
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      // _selectedFilters[Filter.glutenFree] is true (the user toggled it) and isGlutenFree is FALSE (!meal.isGlutenFre, the meal is NOT gluten-free) -> return false (do NOT keep the filtered list)
      if (_selectedFilters[Filter.glutenFree]! &&
          !meal
              .isGlutenFree) // _selectedFilters[Filter.glutenFree] cannot be null because it is initially set to false
      {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }

      return true;
      // Return true because otherwise you end up not keeping the filtered list
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggledMealFavoriteStatus: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activepageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      // meals show a list of the user's fav meals
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggledMealFavoriteStatus: _toggleMealFavoriteStatus,
      );
      activepageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activepageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _showScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectpage,
        // This controls which tab will be highlighted
        currentIndex: _selectedPageIndex,
        // list of tabs
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites')
        ],
      ),
    );
  }
}
