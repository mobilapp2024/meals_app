import 'package:flutter/material.dart';

/// A widget that displays an icon and a label in a horizontal row,
/// typically used to represent traits of a meal.
class MealItemTrait extends StatelessWidget {
  const MealItemTrait({super.key, required this.icon, required this.label});

  final IconData icon;

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon representing the trait.
        Icon(
          icon,
          size: 17,
          color: Colors.white,
        ),
        const SizedBox(
          width: 6,
        ),
        // Text label for the trait.
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
