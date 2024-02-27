import 'package:flutter/material.dart';

class Category {
  final String id;
  final String title;
  final Color color;

  const Category({
    required this.id,
    required this.title,
    // required paremeter cannot have a default value
    this.color = Colors.orange,
  });
}
