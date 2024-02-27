import 'package:flutter/material.dart';

// These are the keys for the map in the pop method
enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, required this.currentFilters});

  final Map<Filter, bool> currentFilters;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  var _glutenFreeFilterSet = false;
  var _lactoseFreeFilterSet = false;
  var _vegetarianFreeFilterSet = false;
  var _veganFreeFilterSet = false;

  // You cannot assign currentFIlters to _glutenFreeFilterSet above using widget.[property], so you need to do workaround
  // initState is called once before the build method, so this basically overrides the values of _glutenFreeFilterSet, _lactoseFreeFilterSet etc. By doing this, it prevents the filters the user toggled from being reset
  @override
  void initState() {
    super.initState();
    _glutenFreeFilterSet = widget.currentFilters[Filter.glutenFree]!;
    _lactoseFreeFilterSet = widget.currentFilters[Filter.lactoseFree]!;
    _vegetarianFreeFilterSet = widget.currentFilters[Filter.vegetarian]!;
    _veganFreeFilterSet = widget.currentFilters[Filter.vegan]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your filters'),
      ),
      body: PopScope(
        // PopScope: This widget is used to monitor if a route is about to be popped off the navigator stack. It allows you to intercept the pop event and handle it accordingly
        canPop:
            false, // the canPop property is set to false, which means the route cannot be popped manually.
        onPopInvoked: (bool didPop) {
          // onPopInvoked: This callback is invoked when the route is about to be popped off the navigator stack. The didPop parameter indicates whether the route actually popped or not. If the route popped successfully (didPop is true), the callback returns. Otherwise, it pops the current route off the navigator stack with a map containing filter options as the result.
          if (didPop) {
            return;
          } // if didPop is true, the callback simply returns, indicating that no further action is needed.
          Navigator.of(context).pop({
            // pop method can return any kinds of value (i.e., T)
            // If didPop is false, it means the route couldn't be popped manually. In this case, the callback uses Navigator.of(context).pop(...) to pop the current route off the navigator stack with a map containing filter options as the result.
            // This is called when the back button is pressed. FiltersScreen came from TabsScreen so when the back button is pressed, the screen will go back to TabsScreen
            Filter.glutenFree: _glutenFreeFilterSet,
            Filter.lactoseFree: _lactoseFreeFilterSet,
            Filter.vegetarian: _vegetarianFreeFilterSet,
            Filter.vegan: _veganFreeFilterSet,
          });
        },
        child: Column(
          children: [
            SwitchListTile(
              activeColor: Theme.of(context).colorScheme.tertiary,
              title: Text(
                'Gluten Free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text('Only include gluten-free meals',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
              contentPadding: const EdgeInsets.only(left: 34, right: 22),

              value:
                  _glutenFreeFilterSet, // whether the switch is checked. This variable is intially false, but isChecked, which is new boolean value will be assigned to it
              onChanged: (isChecked) {
                // isChecked is boolean, and it is a new value
                setState(() {
                  // Called when the user toggles the switch on or off. This callback function should update the state of the parent [StatefulWidget] using the [State.setState] method, so that the parent gets rebuilt
                  _glutenFreeFilterSet = isChecked;
                });
              },
            ),
            SwitchListTile(
              activeColor: Theme.of(context).colorScheme.tertiary,
              title: Text(
                'Lactose Free',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text('Only include lactose-free meals',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
              contentPadding: const EdgeInsets.only(left: 34, right: 22),

              value: _lactoseFreeFilterSet, // whether the switch is checked
              onChanged: (isChecked) {
                // isChecked is boolean, and it is a new value
                setState(() {
                  // Called when the user toggles the switch on or off. This callback function should update the state of the parent [StatefulWidget] using the [State.setState] method, so that the parent gets rebuilt
                  _lactoseFreeFilterSet = isChecked;
                });
              },
            ),
            SwitchListTile(
              activeColor: Theme.of(context).colorScheme.tertiary,
              title: Text(
                'Vegitarian',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text('Only include vegetarian meals',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
              contentPadding: const EdgeInsets.only(left: 34, right: 22),

              value: _vegetarianFreeFilterSet, // whether the switch is checked
              onChanged: (isChecked) {
                // isChecked is boolean, and it is a new value
                setState(() {
                  // Called when the user toggles the switch on or off. This callback function should update the state of the parent [StatefulWidget] using the [State.setState] method, so that the parent gets rebuilt
                  _vegetarianFreeFilterSet = isChecked;
                });
              },
            ),
            SwitchListTile(
              activeColor: Theme.of(context).colorScheme.tertiary,
              title: Text(
                'Vegan',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              subtitle: Text('Only include vegan meals',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground)),
              contentPadding: const EdgeInsets.only(left: 34, right: 22),

              value: _veganFreeFilterSet, // whether the switch is checked
              onChanged: (isChecked) {
                // isChecked is boolean, and it is a new value
                setState(() {
                  // Called when the user toggles the switch on or off. This callback function should update the state of the parent [StatefulWidget] using the [State.setState] method, so that the parent gets rebuilt
                  _veganFreeFilterSet = isChecked;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
