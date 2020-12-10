// Import the test package and API class
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_drupal/api.dart';

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized();
  test('User should get logged in', () async {
    final api = Api();
    LoginResponse loggedIn;
    await api.createLoginState('axe', 'admin').then((val) => {loggedIn = val});
    expect(loggedIn.userNicename, 'axe');
  });
}
