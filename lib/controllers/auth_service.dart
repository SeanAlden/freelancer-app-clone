import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Function to simulate login and store the logged-in user's email
  Future<void> login(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
  }

  // Function to simulate logout and clear user session
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
  }

  // Function to check if user is logged in
  Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }
}
