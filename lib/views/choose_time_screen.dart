import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseTimeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Mengikuti tema
      appBar: AppBar(
        title: Text('Choose Time',
            style: Theme.of(context).textTheme.titleLarge), // Mengikuti tema
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // Mengikuti tema
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
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
                  DateTime fullDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  Get.back(result: fullDateTime);
                }
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: Text('Choose Date & Time',
                style: Theme.of(context).textTheme.button), // Mengikuti tema
          ),
        ],
      ),
    );
  }
}
