import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';

class CreateCategoryScreen extends StatefulWidget {
  @override
  _CreateCategoryScreenState createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final CategoryController categoryController = Get.find<CategoryController>();
  final TextEditingController categoryNameController = TextEditingController();
  IconData? selectedIcon;
  int? selectedColor;

  final List<IconData> availableIcons = [
    Icons.local_grocery_store,
    Icons.work,
    Icons.sports,
    Icons.design_services,
    Icons.school,
    Icons.people,
    Icons.music_note,
    Icons.health_and_safety,
    Icons.movie,
    Icons.home,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:
            Text('Create new category', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category name',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Text('Category icon:', style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                for (var icon in availableIcons)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIcon = icon;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIcon == icon
                            ? Colors.purple
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, color: Colors.white),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text('Category color:', style: TextStyle(color: Colors.white)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                for (int color in [
                  0xFF4CAF50,
                  0xFFF44336,
                  0xFF00BCD4,
                  0xFF00E676,
                  0xFF3F51B5,
                  0xFFFF4081,
                  0xFFFFC107,
                  0xFF4DD0E1,
                  0xFF2196F3
                ])
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(color),
                        shape: BoxShape.circle,
                        border: selectedColor == color
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (categoryNameController.text.isNotEmpty &&
                        selectedIcon != null &&
                        selectedColor != null) {
                      categoryController.addCategory(
                        categoryNameController.text.trim(),
                        selectedIcon!,
                        selectedColor!,
                      );
                      Get.back();
                    } else {
                      Get.snackbar(
                        'Error',
                        'Please fill all the fields',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                  child: Text('Create Category',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
