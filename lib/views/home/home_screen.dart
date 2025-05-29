import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/controllers/theme_controller.dart';

class HomeScreen extends StatelessWidget {
  final ThemeController themeController = Get.find();

  HomeScreen({super.key}); // Find the instance of ThemeController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Theme Switcher'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Theme:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium, // Use the custom text style from the theme
            ),
            Obx(() {
              // Display the current theme name based on the index.
              return Text(themeController.currentThemeIndex.value == 0
                  ? 'Light Theme'
                  : 'Dark Theme');
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Toggle the theme when the button is pressed.
                themeController.toggleTheme();
              },
              child: Text('Toggle Theme'),
            ),
          ],
        ),
      ),
    );
  }
}
