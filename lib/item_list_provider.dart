import 'package:flutter/material.dart';
import 'package:task/details_model.dart';

class StateProvider with ChangeNotifier {
  List<Details> items = List<Details>.empty(growable: true);

  void addTask(String email, String phone) {
    if (email != null && email != '' && phone != null && phone != '') {
      items.add(Details(email, phone));
      notifyListeners();
    }
  }
}
