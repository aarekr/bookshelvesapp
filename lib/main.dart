import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:ui';

import '/src/appbar.dart';
import '/src/settings.dart';
import '/src/bookstatistics.dart';

getNavigationButtons(currentScreen) {
  List<Widget> buttons = [];
  if (currentScreen != 'HomeScreen') {
    buttons.add(OutlinedButton(child: Text("Home"), onPressed: () => Get.to(() => HomeScreen())));
  }
  if (currentScreen != 'AddBookScreen') {
    buttons.add(OutlinedButton(child: Text("Add Book"), onPressed: () => Get.to(() => AddBookScreen())));
  }
  if (currentScreen != 'NotStartedScreen') {
    buttons.add(OutlinedButton(child: Text("Not Started"), onPressed: () => Get.to(() => NotStartedScreen())));
  }
  if (currentScreen != 'ReadingScreen') {
    buttons.add(OutlinedButton(child: Text("Reading"), onPressed: () => Get.to(() => ReadingScreen())));
  }
  if (currentScreen != 'CompletedScreen') {
    buttons.add(OutlinedButton(child: Text("Completed"), onPressed: () => Get.to(() => CompletedScreen())));
  }
  return Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons,
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
        GetPage(name: "/language/:language", page: () => LanguageScreen()),
      ],
    ),
  );
}

class HomeScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Bookshelves"),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < Breakpoints.mobile) {  // mobile layout
            return getBookStatistics('mobile', controller);
          }
          else if (constraints.maxWidth < Breakpoints.tablet) {  // tablet layout
            return getBookStatistics('tablet', controller);
          }
          else {  // large screen layout
            return getBookStatistics('large', controller);
          }
        }
      ),
      bottomNavigationBar: getNavigationButtons('HomeScreen'),
    );
  }
}

class AddBookScreen extends StatelessWidget {
  //static final _formKey = GlobalKey<FormBuilderState>();  // original, causes duplicate key error
  var _formKey = GlobalKey<FormBuilderState>();             // replacement, works fine
  final controller = Get.find<BookListController>();

  _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      controller.add(_formKey.currentState?.value["title"],
                      _formKey.currentState?.value["author"],
                      _formKey.currentState?.value["language"]);
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Add Book"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(children: [
            Text("Add a new book to your reading list", style: TextStyle(height: 3, fontSize: 20)),
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'title',
                    decoration: InputDecoration(
                      hintText: 'title',
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  ),
                  FormBuilderTextField(
                    name: 'author',
                    decoration: InputDecoration(
                      hintText: 'author',
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                  ),
                  FormBuilderRadioGroup(
                    decoration: InputDecoration(labelText: 'Book language'),
                    name: 'language',
                    validator: FormBuilderValidators.required(),
                    options: ['Finnish', 'Swedish', 'English', 'Norwegian', 'German']
                      .map((lang) => FormBuilderFieldOption(value: lang))
                      .toList(growable: false),
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text("Save"),
                  ),
                ]
              )
            ),
          ])
        )
      ),
      bottomNavigationBar: getNavigationButtons('AddBookScreen'),
    );
  }
}

class NotStartedScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Books on reading list (not started)"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(children: [
            Column(children: controller.bookList.map((book) => 
              book['status'] == 'not started' 
                ? Card(child: ListTile(
                    leading: ElevatedButton(
                      onPressed: () => controller.start(book),
                      child: Text("Start"),
                    ),
                    title: Text(book["title"]), 
                    subtitle: Text(book["author"] + "\n(" + book["language"] + ")"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.delete(book),
                    ),
                  ))
                : Text("")).toList()
            ),
          ]),
        )
      ),
      bottomNavigationBar: getNavigationButtons('NotStartedScreen'),
    );
  }
}

class ReadingScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("You are currently reading"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(children: [
            Column(children: controller.bookList.map((book) => 
              book['status'] == 'reading' 
                ? Card(child: ListTile(
                    leading: ElevatedButton(
                      onPressed: () => controller.complete(book),
                      child: Text("Complete"),
                    ),
                    title: Text(book["title"]),
                    subtitle: Text(book["author"] + "\n(" + book["language"] + ")"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.delete(book),
                    ),
                  ))
                : Text("")).toList()
            ),
          ]),
        )
      ),
      bottomNavigationBar: getNavigationButtons('ReadingScreen'),
    );
  }
}

class CompletedScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Completed books"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(children: [
            Column(children: controller.bookList.map((book) => 
              book['status'] == 'completed' 
                ? Card(child: ListTile(
                    leading: ElevatedButton(
                      onPressed: () => controller.start(book),
                      child: Text("Reset"),
                    ),
                    title: Text(book["title"]),
                    subtitle: Text(book["author"] + "\n(" + book["language"] + ")"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.delete(book),
                    ),
                  ))
                : Text("")).toList()
            ),
          ])
        )
      ),
      bottomNavigationBar: getNavigationButtons('CompletedScreen'),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();

  @override
  Widget build(BuildContext context) {
    var language = Get.parameters["language"] != null ? Get.parameters["language"]! : "all";

    return Scaffold(
      appBar: getAppBar("Books in $language"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Column(children: controller.bookList.map((book) => 
                book['language'] == language 
                  ? Card(child: ListTile(
                      title: Text(book["title"]),
                      subtitle: Text(book["author"] + "\n(" + book["status"] + ")"),
                    ))
                  : Text("")).toList()
              ),
              Text("Total books in $language: ${controller.bookList.where((book) => book['language'] == language).length}", 
                style: TextStyle(height: 3, fontSize: 20)
              ),
              OutlinedButton(
                onPressed: () => Get.back(),
                child: Text("Go back"),
              ),
            ],
          )
        )
      ),  // this screen doesn't have a bottom navigation bar, as it is accessed from the statistics section of the home screen
    );
  }
}
