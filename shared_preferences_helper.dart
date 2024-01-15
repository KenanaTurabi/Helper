import 'package:shared_preferences/shared_preferences.dart';
Future<int?> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('userId');
}
 Future<String?> getUserType() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userType');
}
