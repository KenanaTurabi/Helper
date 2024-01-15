import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'changeNotifier.dart';

void selectPage(int index, BuildContext context) {
  final pageControllerProvider = Provider.of<PageControllerProvider>(context, listen: false);
  pageControllerProvider.setPage(index);
}
