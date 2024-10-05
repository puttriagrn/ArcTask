import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  final TodoController todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Mengikuti tema
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // Mengikuti tema
        automaticallyImplyLeading: false,
        title: Text('To Do List',
            style: Theme.of(context).textTheme.headline6), // Mengikuti tema
      ),
      body: Obx(() {
        return todoController.todos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/empty_tasks.png', height: 200),
                    SizedBox(height: 20),
                    Text(
                      "What do you want to do today?",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1, // Mengikuti tema
                    ),
                    SizedBox(height: 10),
                    Text("Tap + to add your tasks",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2), // Mengikuti tema
                  ],
                ),
              )
            : ListView.builder(
                itemCount: todoController.todos.length,
                itemBuilder: (context, index) {
                  final todo = todoController.todos[index];
                  DateTime? dateTime;
                  if (todo['dateTime'] != null) {
                    dateTime = DateTime.parse(todo['dateTime']);
                  }

                  return ListTile(
                    title: Text(todo['title'],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1), // Mengikuti tema
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo['description'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: Colors.grey), // Mengikuti tema
                        ),
                        if (todo['category'] != null) // Jika ada kategori
                          Row(
                            children: [
                              Icon(
                                todo['category']['icon'] is int
                                    ? IconData(todo['category']['icon'],
                                        fontFamily: 'MaterialIcons')
                                    : todo['category']['icon'],
                                color: todo['category']['color'] is int
                                    ? Color(todo['category']['color'])
                                    : todo['category']['color'],
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(todo['category']['name'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1), // Mengikuti tema
                            ],
                          ),
                        if (dateTime != null) // Jika ada waktu yang dipilih
                          Text(
                            'Reminder: ${DateFormat('E, d MMM yyyy HH:mm').format(dateTime)}',
                            style: TextStyle(color: Colors.purpleAccent),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.purple),
                          onPressed: () {
                            _editTaskBottomSheet(context, index, todo);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, index);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _editTaskBottomSheet(context, index, todo);
                    },
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            AddTodoBottomSheet(),
            backgroundColor:
                Theme.of(context).scaffoldBackgroundColor, // Mengikuti tema
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
          );
        },
        child: Icon(Icons.add, size: 36, color: Colors.white),
        backgroundColor: Colors.purple,
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.purple.shade700 // Warna ungu gelap untuk dark mode
            : Colors.purple.shade200, // Warna ungu terang untuk light mode
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white // Ikon putih untuk dark mode
                    : const Color.fromARGB(
                        255, 33, 9, 63), // Ikon ungu gelap untuk light mode
                size: 36,
              ),
              onPressed: () {
                Get.toNamed('/home');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white // Ikon putih untuk dark mode
                    : const Color.fromARGB(
                        255, 33, 9, 63), // Ikon ungu gelap untuk light mode
                size: 36,
              ),
              onPressed: () {
                Get.toNamed('/profile');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    final TodoController todoController = Get.find<TodoController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor, // Mengikuti tema
          title: Text(
            'Delete Task',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete this task?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Tutup dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                todoController.removeTodo(index); // Hapus task
                Get.back(); // Tutup dialog
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editTaskBottomSheet(
      BuildContext context, int index, Map<String, dynamic> todo) {
    final TodoController todoController = Get.find<TodoController>();
    TextEditingController titleController =
        TextEditingController(text: todo['title']);
    TextEditingController descriptionController =
        TextEditingController(text: todo['description']);
    DateTime? selectedDateTime =
        todo['dateTime'] != null ? DateTime.parse(todo['dateTime']) : null;
    Rx<Map<String, dynamic>?> selectedCategory =
        Rx<Map<String, dynamic>?>(todo['category']);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor, // Mengikuti tema
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Edit Task Title',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Edit Task Description',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Pilih tanggal dan waktu
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDateTime ?? DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Colors.purple,
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor: Colors.black,
                      ),
                      child: child!,
                    );
                  },
                );

                if (selectedDate != null) {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                        selectedDateTime ?? DateTime.now()),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Colors.purple,
                            onPrimary: Colors.white,
                            surface: Colors.black,
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: Colors.black,
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (selectedTime != null) {
                    selectedDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child:
                  Text('Edit Task Time', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            Obx(() {
              return ElevatedButton(
                onPressed: () async {
                  // Navigasi ke ChooseCategoryScreen untuk memilih kategori
                  final category = await Get.toNamed('/choose-category');
                  if (category != null) {
                    selectedCategory.value = category;
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.purple),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (selectedCategory.value != null) ...[
                      Icon(
                        selectedCategory.value!['icon'] is IconData
                            ? selectedCategory.value!['icon']
                            : IconData(selectedCategory.value!['icon'],
                                fontFamily: 'MaterialIcons'),
                        color: selectedCategory.value!['color'] is Color
                            ? selectedCategory.value!['color']
                            : Color(selectedCategory.value!['color']),
                      ),
                      SizedBox(width: 8),
                    ],
                    Text('Edit Category',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              );
            }),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                todoController.todos[index] = {
                  'title': titleController.text.trim(),
                  'description': descriptionController.text.trim(),
                  'category': selectedCategory.value,
                  'completed': todo['completed'],
                  'dateTime': selectedDateTime?.toIso8601String(),
                };
                todoController.saveTodos();
                Get.back();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text('Save Task', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTodoBottomSheet extends StatelessWidget {
  final TodoController todoController = Get.find<TodoController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Rx<Map<String, dynamic>?> selectedCategory =
      Rx<Map<String, dynamic>?>(null);
  final Rx<DateTime?> selectedDateTime = Rx<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Add Task',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Obx(() {
                  return Icon(
                    Icons.alarm,
                    color: selectedDateTime.value == null
                        ? Colors.white
                        : Colors.purple,
                  );
                }),
                onPressed: () async {
                  // Tampilkan Date Picker terlebih dahulu
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2030),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Colors.purple,
                            onPrimary: Colors.white,
                            surface: Colors.black,
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: Colors.black,
                        ),
                        child: child!,
                      );
                    },
                  );

                  if (selectedDate != null) {
                    // Setelah memilih tanggal, tampilkan Time Picker
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.purple,
                              onPrimary: Colors.white,
                              surface: Colors.black,
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: Colors.black,
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (selectedTime != null) {
                      // Gabungkan tanggal dan waktu yang dipilih menjadi satu DateTime
                      DateTime fullDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      // Simpan hasil ke Rx untuk dipakai di UI
                      selectedDateTime.value = fullDateTime;
                    }
                  }
                },
              ),
              IconButton(
                icon: Obx(() {
                  return Icon(
                    selectedCategory.value == null
                        ? Icons.category
                        : selectedCategory.value!['icon'],
                    color: selectedCategory.value == null
                        ? Colors.white
                        : Color(selectedCategory.value!['color']),
                  );
                }),
                onPressed: () async {
                  final category = await Get.toNamed('/choose-category');
                  if (category != null) {
                    selectedCategory.value = category;
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          Obx(() {
            if (selectedDateTime.value != null) {
              String formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                  .format(selectedDateTime.value!);
              return Text(
                'Selected Time: $formattedDate',
                style: TextStyle(color: Colors.white),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              todoController.addTodo(
                titleController.text.trim(),
                descriptionController.text.trim(),
                selectedCategory.value,
                selectedDateTime
                    .value, // Kirim waktu yang dipilih ke controller
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
