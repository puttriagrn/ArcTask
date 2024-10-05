import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor, // Mengikuti tema
      appBar: AppBar(
        title: Text('Profile',
            style: Theme.of(context).textTheme.titleLarge), // Mengikuti tema
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor, // Mengikuti tema
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return CircleAvatar(
                radius: 50,
                backgroundImage: authController.profileImage.value != null
                    ? FileImage(authController.profileImage.value!)
                    : const AssetImage('assets/default_profile.jpeg')
                        as ImageProvider,
              );
            }),
            SizedBox(height: 10),
            Obx(() {
              return Text(
                authController.userData['username'] ?? 'Guest',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 24), // Menggunakan bodyText1 dengan ukuran besar
              );
            }),
            SizedBox(height: 10),

            // Switch untuk mengganti tema
            Obx(() {
              return SwitchListTile(
                title: Text('Dark Mode',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge), // Mengikuti tema
                value: themeController.isDarkMode.value,
                onChanged: (value) {
                  themeController.toggleTheme(); // Ganti tema
                },
                activeColor: Colors.purple,
              );
            }),

            Divider(color: Colors.grey),

            // Menggunakan ThemeController untuk warna teks
            _buildProfileOption(
              context,
              'Change username',
              Icons.person,
              () {
                _showEditUsernameDialog(context);
              },
              isLogout: false,
            ),
            _buildProfileOption(
              context,
              'Change account password',
              Icons.lock,
              () {
                _showEditPasswordDialog(context);
              },
              isLogout: false,
            ),
            _buildProfileOption(
              context,
              'Change account Image',
              Icons.image,
              () {
                _showChangeImageDialog(context);
              },
              isLogout: false,
            ),

            Spacer(),

            // Logout tetap dengan warna merah
            _buildProfileOption(
              context,
              'Log out',
              Icons.logout,
              () {
                Get.offNamed('/start');
              },
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String label, IconData icon, VoidCallback onTap,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon,
          color: isLogout ? Colors.red : Theme.of(context).iconTheme.color),
      title: Text(
        label,
        style: isLogout
            ? Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.red)
            : Theme.of(context)
                .textTheme
                .bodyText1, // Mengikuti tema dari ThemeController
      ),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
    );
  }

  void _showEditUsernameDialog(BuildContext context) {
    nameController.text = authController.userData['username'] ?? '';

    Get.defaultDialog(
      title: "Change username",
      backgroundColor: Colors.black,
      titleStyle: TextStyle(color: Colors.white),
      content: Column(
        children: [
          TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'New username',
              labelStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              authController.changeUsername(nameController.text.trim());
              Get.back();
            },
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showEditPasswordDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Change account Password",
      backgroundColor: Colors.black,
      titleStyle: TextStyle(color: Colors.white),
      content: Column(
        children: [
          TextField(
            controller: oldPasswordController,
            style: TextStyle(color: Colors.white),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Enter old password',
              labelStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: newPasswordController,
            style: TextStyle(color: Colors.white),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Enter new password',
              labelStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              authController.changePassword(
                oldPasswordController.text.trim(),
                newPasswordController.text.trim(),
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child: Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showChangeImageDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera, color: Colors.white),
              title:
                  Text('Take picture', style: TextStyle(color: Colors.white)),
              onTap: () {
                authController.changeProfileImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo, color: Colors.white),
              title: Text('Import from gallery',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                authController.changeProfileImage(ImageSource.gallery);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
