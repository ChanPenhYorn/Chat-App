import 'package:chatapp/views/home/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/controllers/theme_controller.dart';

class HomeScreen extends StatelessWidget {
  final ThemeController themeController = Get.find();

  HomeScreen({super.key}); // Find the instance of ThemeController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text('Chat'),
        // ),

        //! how to
        body: ChatScreen());
  }
}
