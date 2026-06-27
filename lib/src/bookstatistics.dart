import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        Row(children: [Text("Total books  : ", style: TextStyle(height: 1.2, fontSize: textFontSize)),
          Text("${controller.bookList.length}", style: TextStyle(height: 1.2, fontSize: textFontSize))
        ]),
        Column(children: [
          Text("Show books by language:", style: TextStyle(height: 3, fontSize: textFontSize + 5)),
          TextButton(child: Text("Finnish"), onPressed: () => Get.toNamed("/language/${"Finnish"}")),
          TextButton(child: Text("Swedish"), onPressed: () => Get.toNamed("/language/${"Swedish"}")),
          TextButton(child: Text("English"), onPressed: () => Get.toNamed("/language/${"English"}")),
          TextButton(child: Text("Norwegian"), onPressed: () => Get.toNamed("/language/${"Norwegian"}")),
          TextButton(child: Text("German"), onPressed: () => Get.toNamed("/language/${"German"}")),
        ]),
      ]
    ),
  );
}
