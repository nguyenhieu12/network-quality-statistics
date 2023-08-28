import 'package:firebase_auth/firebase_auth.dart';

class OTPSender {
  static void handleSendOTP(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+84${phone}',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}