import 'package:flutter/material.dart';
import 'package:mobile/screens/HomeScreen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/home': (_) => const HomeScreen()
};
