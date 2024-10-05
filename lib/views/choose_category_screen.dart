import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';

class ChooseCategoryScreen extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Mengikuti tema
      appBar: AppBar(
        title: Text('Choose Category',
            style: Theme.of(context).textTheme.titleLarge), // Mengikuti tema
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // Mengikuti tema
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            itemCount: categoryController.categories.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              if (index < categoryController.categories.length) {
                final category = categoryController.categories[index];
                return GestureDetector(
                  onTap: () {
                    Get.back(result: category);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(category['color'] as int),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(category['icon'] as IconData,
                            size: 40, color: Colors.white),
                        SizedBox(height: 8),
                        Text(
                          category['name'] as String,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/create-category');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Create New',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
