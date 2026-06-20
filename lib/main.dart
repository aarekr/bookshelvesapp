import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

getHomeButton() { return OutlinedButton(child: Text("Home"), onPressed: () => Get.to(() => HomeScreen())); }
getAddBookButton() { return OutlinedButton(child: Text("Add Book"), onPressed: () => Get.to(() => AddBookScreen())); }
getNotStartedButton() { return OutlinedButton(child: Text("Not Started"), onPressed: () => Get.to(() => NotStartedScreen())); }
getReadingButton() { return OutlinedButton(child: Text("Reading"), onPressed: () => Get.to(() => ReadingScreen())); }
getCompletedButton() { return OutlinedButton(child: Text("Completed"), onPressed: () => Get.to(() => CompletedScreen())); }

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
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
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getAddBookButton(), getNotStartedButton(), getReadingButton(), getCompletedButton()],
        ),
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
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getAddBookButton(), getNotStartedButton(), getReadingButton(), getCompletedButton()],
        ),
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
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getAddBookButton(), getNotStartedButton(), getReadingButton(), getCompletedButton()],
        ),
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
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getAddBookButton(), getNotStartedButton(), getReadingButton(), getCompletedButton()],
        ),
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
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [getAddBookButton(), getNotStartedButton(), getReadingButton(), getCompletedButton()],
        ),
      ),
    );
  }
}
