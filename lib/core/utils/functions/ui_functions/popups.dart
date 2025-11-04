import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showCustomDialog(BuildContext context, Widget child) {
  showDialog<void>(
    context: context,
    builder: (context) => child,
  );
}

void showCustomBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    backgroundColor: Colors.transparent,
    builder: (context) => child,
  );
}

void closeDialog(BuildContext context) {
  if (context.canPop()) {
    context.pop();
  }
}
