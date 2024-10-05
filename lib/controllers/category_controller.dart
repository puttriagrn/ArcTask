import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var categories = [
    {'name': 'Grocery', 'icon': Icons.local_grocery_store, 'color': 0xFF4CAF50},
    {'name': 'Work', 'icon': Icons.work, 'color': 0xFFF44336},
    {'name': 'Sport', 'icon': Icons.sports, 'color': 0xFF00BCD4},
    {'name': 'Design', 'icon': Icons.design_services, 'color': 0xFF00E676},
    {'name': 'University', 'icon': Icons.school, 'color': 0xFF3F51B5},
    {'name': 'Social', 'icon': Icons.people, 'color': 0xFFFF4081},
    {'name': 'Music', 'icon': Icons.music_note, 'color': 0xFFFFC107},
    {'name': 'Health', 'icon': Icons.health_and_safety, 'color': 0xFF4DD0E1},
    {'name': 'Movie', 'icon': Icons.movie, 'color': 0xFF2196F3},
    {'name': 'Home', 'icon': Icons.home, 'color': 0xFFFF9800},
  ].obs;

  // Fungsi untuk menambah kategori baru dengan ikon dari material
  void addCategory(String name, IconData icon, int color) {
    categories.add({'name': name, 'icon': icon, 'color': color});
  }
}
