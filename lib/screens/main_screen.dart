import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import '../controllers/book_controller.dart';

class MainScreen extends StatelessWidget {
  final BookController bookController =
      Get.put(BookController()); 
  final _currentIndex = 0.obs;
  final List<Widget> _screens = [HomeScreen(), FavoriteScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: _screens[_currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex.value,
            onTap: (index) => _currentIndex.value = index,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Favorites'),
            ],
          ),
        ));
  }
}
