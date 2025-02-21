import 'package:e_mart/pages/welcome/login_page.dart';
import 'package:e_mart/pages/welcome/twilio_register.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatelessWidget {
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
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Text('Register',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
              LottieBuilder.asset(
                'asset/json_files/register.json',
                height: 290,
              ),
              Column(
                children: <Widget>[
                  inputFile(label: "Username",),
                  inputFile(label: "Email"),
                  inputFile(label: "Password", obscureText: true),
                  inputFile(label: "Confirm Password", obscureText: true),
                ],
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () async {
                  // Simulate signup process (e.g., API call)
                  bool signupSuccess = await performSignup();

                  if (signupSuccess) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TwilioRegister()),
                    );
                  } else {
                    // Handle signup failure
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Signup failed. Please try again.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    elevation: 5,
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white
                ),
                child: Text(
                  "Sign up",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    Text(
                      " Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget inputFile({label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(height: 5),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: TextStyle(color: Colors.green),
        ),
        cursorColor: Colors.green,
      ),
    ],
  );
}

Future<bool> performSignup() async {
  // Simulate a delay and return success
  await Future.delayed(Duration(seconds: 1));
  return true; // Simulate signup success
}
