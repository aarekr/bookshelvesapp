import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'dart:ui';

getAppBar(title) {
  return AppBar(
    backgroundColor: Theme.of(Get.context!).colorScheme.inversePrimary,
    title: Center(child: Text(title)),
  );
}

getHomeButton() {
  return OutlinedButton(child: Text("Home"), onPressed: () => Get.to(() => HomeScreen()));
}
getAddBookButton() {
  return OutlinedButton(child: Text("Add Book"), onPressed: () => Get.to(() => AddBookScreen()));
}
getNotStartedButton() {
  return OutlinedButton(child: Text("Not Started"), onPressed: () => Get.to(() => NotStartedScreen()));
}
getReadingButton() {
  return OutlinedButton(child: Text("Reading"), onPressed: () => Get.to(() => ReadingScreen()));
}
getCompletedButton() {
  return OutlinedButton(child: Text("Completed"), onPressed: () => Get.to(() => CompletedScreen()));
}

getNavigationButtons(currentScreen) {
  List<Widget> buttons = [];
  if (currentScreen != 'HomeScreen') {
    buttons.add(getHomeButton());
  }
  if (currentScreen != 'AddBookScreen') {
    buttons.add(getAddBookButton());
  }
  if (currentScreen != 'NotStartedScreen') {
    buttons.add(getNotStartedButton());
  }
  if (currentScreen != 'ReadingScreen') {
    buttons.add(getReadingButton());
  }
  if (currentScreen != 'CompletedScreen') {
    buttons.add(getCompletedButton());
  }
  return Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buttons,
          ),
  );
}

getBookStatistics(layoutSize, controller, getNumberOfBooksWithStatus) {
  var marginSize;
  var headerFontSize;
  var textFontSize;
  if (layoutSize == 'mobile') {
    marginSize = 40.0;
    headerFontSize = 30.0;
    textFontSize = 20.0;
  }
  else if (layoutSize == 'tablet') {
    marginSize = 50.0;
    headerFontSize = 35.0;
    textFontSize = 23.0;
  }
  else {
    marginSize = 60.0;
    headerFontSize = 40.0;
    textFontSize = 25.0;
  }
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.all(marginSize),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text("Statistics", style: TextStyle(height: 3, fontSize: headerFontSize))]),
        Row(children: [Text("Books to read: ", style: TextStyle(height: 1.2, fontSize: textFontSize)),
          Text("${getNumberOfBooksWithStatus('not started')}", style: TextStyle(height: 1.2, fontSize: textFontSize))
        ]),
        Row(children: [Text("Reading now  : ", style: TextStyle(height: 1.2, fontSize: textFontSize)),
          Text("${getNumberOfBooksWithStatus('reading')}", style: TextStyle(height: 1.2, fontSize: textFontSize))
        ]),
        Row(children: [Text("You have read: ", style: TextStyle(height: 1.2, fontSize: textFontSize)),
          Text("${getNumberOfBooksWithStatus('completed')}", style: TextStyle(height: 1.2, fontSize: textFontSize))
        ]),
      ]
    ),
  );
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class Breakpoints {
  static const mobile = 600;
  static const tablet = 900;
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
      ],
    ),
  );
}

class HomeScreen extends StatelessWidget {
  final controller = Get.find<BookListController>();

  int getNumberOfBooksWithStatus(String status) {
    int number = 0;
    for (var i=0; i<controller.bookList.length; i++) {
      if(controller.bookList[i]['status'] == status) {
        number++;
      }
    }
    return number;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Bookshelves"),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < Breakpoints.mobile) {  // mobile layout
            return getBookStatistics('mobile', controller, getNumberOfBooksWithStatus);
          }
          else if (constraints.maxWidth < Breakpoints.tablet) {  // tablet layout
            return getBookStatistics('tablet', controller, getNumberOfBooksWithStatus);
          }
          else {  // large screen layout
            return getBookStatistics('large', controller, getNumberOfBooksWithStatus);
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
            Text("New books", style: TextStyle(height: 3, fontSize: 30)),
            Text("Add a new book to reading list", style: TextStyle(height: 3, fontSize: 20)),
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
      appBar: getAppBar("Not Started"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(children: [
            Text("Books on reading list", style: TextStyle(height: 3, fontSize: 30)),
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
      appBar: getAppBar("Reading"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(children: [
            Center(child: Text("You are currently reading", style: TextStyle(height: 3, fontSize: 30))),
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
      appBar: getAppBar("Completed"),
      body: Center(child:
        Container(
          constraints: BoxConstraints(maxWidth: 800),
          child: Column(children: [
            Center(child: Text("Completed books", style: TextStyle(height: 3, fontSize: 30))),
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
