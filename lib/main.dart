import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() {
  runApp(
    GetMaterialApp(
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => HomeScreen()),
        GetPage(name: "/addbook", page: () => AddBookScreen()),
        GetPage(name: "/notstarted", page: () => NotStartedScreen()),
        GetPage(name: "/reading", page: () => ReadingScreen()),
        GetPage(name: "/completed", page: () => CompletedScreen()),
      ],
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

class AddBookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Add Book Screen'),
      ),
    );
  }
}

class NotStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Not Started Screen'),
      ),
    );
  }
}

class ReadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Reading Screen'),
      ),
    );
  }
}

class CompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Completed Screen'),
      ),
    );
  }
}
