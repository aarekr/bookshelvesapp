import 'package:flutter/material.dart';
import 'dart:ui';

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
