import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/profile_view.dart';
import 'views/intro_view.dart';
import 'views/onboarding_view.dart';
import 'views/start_screen.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_screen.dart';
import 'views/choose_category_screen.dart';
import 'views/create_category_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'views/choose_time_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    // Custom ThemeData untuk Light Mode
    ThemeData lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor:
            Colors.purple, // Sesuaikan dengan warna yang diinginkan
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.black), // Text untuk light mode
        bodyText2: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.black), // Ikon pada Light Mode
    );

    // Custom ThemeData untuk Dark Mode
    ThemeData darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor:
          Color(0xFF111011), // Custom warna background Dark Mode
      appBarTheme: AppBarTheme(
        backgroundColor:
            Color(0xFF111011), // Sesuaikan dengan warna yang diinginkan
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      textTheme: TextTheme(
        bodyText1: TextStyle(color: Colors.white), // Text untuk dark mode
        bodyText2: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(color: Colors.white), // Ikon pada Dark Mode
    );

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme, // Custom light theme
        darkTheme: darkTheme, // Custom dark theme
        themeMode: themeController.isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light, // Ganti tema secara dinamis
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => IntroView()),
          GetPage(name: '/onboarding', page: () => OnboardingView()),
          GetPage(name: '/start', page: () => StartScreen()),
          GetPage(name: '/login', page: () => LoginView()),
          GetPage(name: '/register', page: () => RegisterView()),
          GetPage(name: '/home', page: () => HomeScreen()),
          GetPage(name: '/choose-category', page: () => ChooseCategoryScreen()),
          GetPage(name: '/create-category', page: () => CreateCategoryScreen()),
          GetPage(name: '/choose-time', page: () => ChooseTimeScreen()),
          GetPage(name: '/profile', page: () => ProfileScreen()),
        ],
      );
    });
  }
}
