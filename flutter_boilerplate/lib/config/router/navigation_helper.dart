import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/config/router/app_navigator.dart';

extension NavigationHelper on BuildContext {
  AppNavigator get navigator => AppNavigatorImpl(this);
}

