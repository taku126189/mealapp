import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/views/meal_details_screen.dart';
import 'package:meals_app/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(
      {super.key,
      this.title,
      required this.meals,
      required this.onToggledMealFavoriteStatus});

// BottomNavigationBarItem's label and Scaffold AppBar's title are both displayed on the screen
// So Scaffold AppBar's title should be optional and required should be removed
  final String? title;
  final List<Meal> meals;
  // You created the function for favorites in TabsScreen and MealDetailsScreen. In MealsScreen, not yet, so you need one to pass it in MealDetailsScreen(meal: meal, onToggledMealFavoriteStatus: onToggledMealFavoriteStatus,),
  final void Function(Meal meal) onToggledMealFavoriteStatus;

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MealDetailsScreen(
        meal: meal,
        onToggledMealFavoriteStatus: onToggledMealFavoriteStatus,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) => MealItem(
        meal: meals[index],
        onSelectMeal: (meal) {
          selectMeal(context, meal);
        },
      ),
    );
    // To show a fallback message if there is nothing to be displayed
    if (meals.isEmpty) {
      content = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nothing is here',
              // In Flutter, onBackground refers to the color that should be used for text when it is displayed on the background color of the UI. This is typically used to ensure that text remains readable and visually accessible against different background colors.
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Try selecting a different category',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ],
        ),
      );
    }

    // In order for title variable to be optional, add some logic. If title is null, it will return content and the code below will not be excuted
    // If you use title ?? content, the code below will be executed
    if (title == null) {
      return content;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        body: content);
  }
}
