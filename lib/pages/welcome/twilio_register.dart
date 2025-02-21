import 'package:e_mart/pages/welcome/twilio.dart';
import 'package:e_mart/pages/welcome/twilio_verify.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TwilioRegister extends StatefulWidget {
  const TwilioRegister({Key? key}) : super(key: key);

  @override
  State<TwilioRegister> createState() => _TwilioRegisterState();
}

class _TwilioRegisterState extends State<TwilioRegister> {
  TextEditingController controller = TextEditingController();

  String number = '';

  String errorMessage = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        children: [
          LottieBuilder.asset('asset/json_files/mobile_register.json'),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Welcome to our amazing reading community. Please enter your phone number, We will send an OTP for verification.',
            style: TextStyle(fontSize: 17, color: Colors.black),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    style: BorderStyle.solid, color: Colors.grey, width: 0.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.12),
                    blurRadius: 1,
                    offset: Offset(
                      2,
                      2,
                    ),
                  )
                ]),
            child: TextField(
              controller: controller,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              decoration: const InputDecoration(
                //hintText: '+911234567890',
                  labelText: 'Enter your phone number',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  number = value;
                  debugPrint(value);
                });
              },
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
              child: Text(errorMessage,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red))),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });

                String result =
                await TwilioVerification.instance.sendCode('+' + number);

                setState(() {
                  isLoading = true;
                });

                if (result == 'Successful') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TwilioVerify(
                            phoneNumber: number,
                          )));
                } else {
                  setState(() {
                    errorMessage = result;
                  });
                }
              },
              child: appButton(isLoading ? 'Sending code ...' : 'Register')),
        ],
      ),
    );
  }
}

Widget appButton(text) {
  return Container(
    height: 50.0,
    width: double.infinity,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.circular(10.0),
      border:
      Border.all(style: BorderStyle.solid, color: Colors.grey, width: 0.5),
    ),
    child: Text(
      text,
      style: const TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
