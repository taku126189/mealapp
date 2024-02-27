import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal, required this.onSelectMeal});

  final Meal meal;
  final void Function(Meal meal) onSelectMeal;

  String get complexityText {
    // name[0] is the first character of complexity enum
    // + operator is for concatenating Strings
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String get affordabilityText {
    return meal.affordability.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      // Stack() ignores the shape of Card()
      // Clip.hardEdge removes spaces of children that go out of Card()
      clipBehavior: Clip.hardEdge,
      // add some shadow to make it like 3D
      elevation: 2,
      child: InkWell(
          // onTap does not provide meal but onSelectMeal wants meal, so you need to use () {} to manually pass meal
          onTap: () {
            onSelectMeal(meal);
          },
          child: Stack(
            children: [
              // FadeInImage is for smoothly fading the image in
              // kTransparentImage global variable is from import 'package:transparent_image/transparent_image.dart';
              FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                // to make sure the image is never distorted
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
              Positioned(
                // there is no distance between the left boarder and right boarder and this container
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  // black54 has a bit of transparency
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 44,
                  ),
                  child: Column(
                    children: [
                      Text(
                        meal.title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis, // very long text ...
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // In meal_item_trait.dart, the build method returns Row(), so usually Expanded() is needed
                          // But, it is not needed here because Positioned(bottom...) defines the space the child widget can take and it passes down to this Row()
                          // So, even though Row() in meal_item_trait.dart is unconstrained in space, Expanded is not needed
                          MealItemTrait(
                            icon: Icons.schedule,
                            label: '${meal.duration} min',
                          ),
                          const SizedBox(width: 12),
                          MealItemTrait(
                            icon: Icons.work,
                            label: complexityText,
                          ),
                          const SizedBox(width: 12),
                          MealItemTrait(
                            icon: Icons.attach_money,
                            label: affordabilityText,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
