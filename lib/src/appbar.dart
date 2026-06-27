import 'package:flutter/material.dart';
import 'package:get/get.dart';

getAppBar(title) {
  return AppBar(
    backgroundColor: Theme.of(Get.context!).colorScheme.inversePrimary,
    title: Center(child: Text(title)),
  );
}
