import 'package:flutter/widgets.dart';
import 'package:insta_clone/models/user.dart';
import 'package:insta_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await AuthMethods()  //User from user.dart in models
    
        .getUserDetails(); // Ensure getUserDetails fetches 'photoUrl'
    _user = user;
    notifyListeners(); // Notify UI about the changes
  }
}
