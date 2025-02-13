import 'package:flutter/material.dart';
import 'package:lingua/screens_mobile/login_screens/accounts/model/accounts_model.dart';

class AccountsProv extends ChangeNotifier {
  AccountsModel model = AccountsModel();

  void clear() {
    model = AccountsModel();
  }

  void notify() {
    notifyListeners();
  }
}
