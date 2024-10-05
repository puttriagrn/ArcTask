import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'auth_controller.dart';

class TodoController extends GetxController {
  var todos = [].obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/${authController.userData['username']}_todolist.json';
  }

  // Load todos from JSON file for the current user
  Future<void> loadTodos() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        String jsonString = await file.readAsString();
        List<dynamic> jsonData = jsonDecode(jsonString);

        todos.value = jsonData.map((todo) {
          // Konversi kembali IconData dan Color dari data JSON (int)
          if (todo['category'] != null) {
            if (todo['category']['icon'] != null &&
                todo['category']['icon'] is int) {
              todo['category']['icon'] = IconData(
                todo['category']['icon'],
                fontFamily: 'MaterialIcons',
              );
            }
            if (todo['category']['color'] != null &&
                todo['category']['color'] is int) {
              todo['category']['color'] = Color(todo['category']['color']);
            }
          }
          return todo;
        }).toList();
      } else {
        await file.writeAsString(jsonEncode([]));
      }
    } catch (e) {
      // Tambahkan log untuk melihat detail error
      print("Error loading todos: $e");
      Get.snackbar('Error', 'Failed to load todos');
    }
  }

  // Save todos to JSON file
  Future<void> saveTodos() async {
    final filePath = await _getFilePath();
    final file = File(filePath);

    List<dynamic> jsonData = todos.map((todo) {
      // Konversi IconData dan Color ke int untuk disimpan dalam JSON
      if (todo['category'] != null) {
        // Jika 'icon' masih IconData, konversi ke codePoint
        if (todo['category']['icon'] is IconData) {
          todo['category']['icon'] = todo['category']['icon'].codePoint;
        }

        // Jika 'color' masih Color, konversi ke value
        if (todo['category']['color'] is Color) {
          todo['category']['color'] = todo['category']['color'].value;
        }
      }
      return todo;
    }).toList();

    await file.writeAsString(jsonEncode(jsonData));
  }

  // Add a new todo with optional category
  void addTodo(String title, String description, Map<String, dynamic>? category,
      [DateTime? dateTime]) {
    if (title.isNotEmpty) {
      todos.add({
        'title': title,
        'description': description,
        'category': category,
        'completed': false,
        'dateTime': dateTime
            ?.toIso8601String(), // Simpan waktu dalam bentuk string ISO8601
      });
      saveTodos();
    } else {
      Get.snackbar('Error', 'Title cannot be empty');
    }
  }

  // Toggle completion of a todo
  void toggleCompletion(int index) {
    todos[index]['completed'] = !todos[index]['completed'];
    saveTodos();
  }

  // Remove a todo
  void removeTodo(int index) {
    todos.removeAt(index);
    saveTodos();
  }
}
