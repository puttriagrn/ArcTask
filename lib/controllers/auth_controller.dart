import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan image_picker

class AuthController extends GetxController {
  var userData = {}.obs;
  var isLoading = false.obs;
  var profileImage = Rx<File?>(null); // Menyimpan gambar profil yang dipilih

  @override
  void onInit() {
    super.onInit();
    loadUserData(); // Memuat data pengguna saat controller diinisialisasi
  }

  // Mendapatkan direktori file untuk menyimpan users.json
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/pengguna.json';
  }

  // Membaca dan memuat data dari users.json
  Future<void> loadUserData() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      if (await file.exists()) {
        String jsonString = await file.readAsString();
        userData.value = jsonDecode(jsonString);
        if (userData['username'] != null &&
            userData[userData['username']]['profileImage'] != null) {
          profileImage.value =
              File(userData[userData['username']]['profileImage']);
        }
      } else {
        await file.writeAsString(jsonEncode({}));
        userData.value = {};
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load user data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Menyimpan data pengguna baru ke dalam file users.json
  Future<void> _saveUserData() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      await file.writeAsString(jsonEncode(userData));
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save user data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk mendaftarkan pengguna baru
  Future<void> register(String username, String password) async {
    if (userData.containsKey(username)) {
      Get.snackbar(
        "Error",
        "Username already exists",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      userData[username] = {
        'password': password,
        'profileImage': null, // Gambar profil default null
      };
      await _saveUserData(); // Simpan data pengguna baru ke file JSON
      Get.snackbar(
        "Success",
        "Registration successful",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.toNamed('/login');
    }
  }

  // Fungsi untuk login
  Future<void> login(String username, String password) async {
    if (userData.containsKey(username) &&
        userData[username]['password'] == password) {
      // Pastikan mengakses map
      Get.snackbar(
        "Success",
        "Login successful",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      userData['username'] = username; // Simpan username yang sedang login
      Get.toNamed('/home');
    } else {
      Get.snackbar(
        "Error",
        "Invalid username or password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk mengganti username
  Future<void> changeUsername(String newUsername) async {
    String currentUsername = userData['username'];
    if (newUsername.isEmpty) {
      Get.snackbar(
        "Error",
        "Username cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (userData.containsKey(newUsername)) {
      Get.snackbar(
        "Error",
        "Username already exists",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      // Update username
      var currentData = userData[currentUsername];
      userData[newUsername] = currentData;
      userData.remove(currentUsername); // Hapus username lama
      userData['username'] = newUsername;
      await _saveUserData();
      Get.snackbar(
        "Success",
        "Username successfully changed",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk mengganti password
  Future<void> changePassword(String oldPassword, String newPassword) async {
    String username = userData['username'];
    if (userData[username]['password'] != oldPassword) {
      Get.snackbar(
        "Error",
        "Old password is incorrect",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (newPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "New password cannot be empty",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      userData[username]['password'] = newPassword;
      await _saveUserData();
      Get.snackbar(
        "Success",
        "Password successfully changed",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi untuk mengganti gambar profil
  Future<void> changeProfileImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        String username = userData['username'];
        File imageFile = File(pickedFile.path);
        userData[username]['profileImage'] =
            imageFile.path; // Simpan path gambar
        profileImage.value = imageFile; // Set gambar profil
        await _saveUserData(); // Simpan perubahan
        Get.snackbar(
          'Success',
          'Profile image updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'No image selected',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
