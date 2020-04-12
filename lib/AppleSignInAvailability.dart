import 'package:apple_sign_in/apple_sign_in.dart';

class AppleSignInAvailability {
  final bool isAvailable;

  AppleSignInAvailability(this.isAvailable);

  static Future<AppleSignInAvailability> check() async {
    return AppleSignInAvailability(await AppleSignIn.isAvailable());
  }
}
