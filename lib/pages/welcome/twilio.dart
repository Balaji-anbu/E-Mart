import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class TwilioVerification {
  static final instance = TwilioVerification();

  final TwilioPhoneVerify _twilioPhoneVerify = TwilioPhoneVerify(

      accountSid: 'AC8ca400d4750308a0582436ccf0603227', // replace with Account SID
      authToken: 'e88acd1143e7a7474687232c5d367206',  // replace with Auth Token
      serviceSid: 'VAe0946db3a7adc954f04c639e04865b90' // replace with Service SID
  );

  Future<String> sendCode(phoneNumberController) async {
    TwilioResponse twilioResponse =
    await _twilioPhoneVerify.sendSmsCode(phoneNumberController);

    if (twilioResponse.successful!) {
      return 'Successful';
    } else {
      print(twilioResponse.errorMessage.toString());
      return twilioResponse.errorMessage.toString();
    }
  }

  Future<String> verifyCode(phoneNumber, otp) async {

    TwilioResponse twilioResponse = await _twilioPhoneVerify.verifySmsCode(
        phone: phoneNumber, code: otp);
    if (twilioResponse.successful!) {
      if (twilioResponse.verification!.status == VerificationStatus.approved) {
        return "Successful";
      } else {
        return 'Invalid code';
      }
    } else {
      return twilioResponse.errorMessage.toString();
    }

  }
}