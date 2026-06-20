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
  Get.lazyPut<BookListController>(() => BookListController());
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

class BookListController {
  final storage = Hive.box("storage");
  RxList bookList;

  BookListController() : bookList = [].obs {
    bookList.value = storage.get('bookList') ?? [];
  }

  void add(String title, String author, String language) {
    var newBook = {'title': title, 'author': author, 'language': language, 'status': 'not started'};
    print("newBook: ${newBook}");
    bookList.add(newBook);
    storage.put('bookList', bookList);
    Get.to(() => NotStartedScreen());
  }

  void _save() {
    storage.put('bookList', bookList.map((book) => book).toList());
    bookList.refresh();
  }

  void start(book) {
    for (var i=0; i<bookList.length; i++) {
      if (bookList[i] == book) {
        bookList[i]["status"] = "reading";
        break;
      }
    }
    bookList.refresh();
    _save();
    Get.to(() => ReadingScreen());
  }

  void complete(book) {
    for (var i=0; i<bookList.length; i++) {
      if (bookList[i] == book) {
        bookList[i]["status"] = "completed";
        break;
      }
    }
    bookList.refresh();
    _save();
    Get.to(() => CompletedScreen());
  }

  void delete(book) {
    bookList.remove(book);
    bookList.refresh();
    _save();
    Get.to(() => HomeScreen());
  }
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
