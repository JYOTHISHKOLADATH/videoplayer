import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

import '../utils/anotherflushbar.dart';
import 'otp.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _preventScreenShotsOn();
    super.initState();
  }

  void _preventScreenShotsOn() async => await ScreenProtector.preventScreenshotOn();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
                child: Image(image: AssetImage("assets/images/png-transparent-computer-icons-youtube-icon-design-youtube-video-player-icon-text-trademark-logo-thumbnail.png"))),
            SizedBox(height: 100,),
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Enter Your Phone Number For Login",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "PhoneNumber",
                  prefix: Text("+91"),
                  border: OutlineInputBorder(borderRadius:BorderRadius.circular(10))),
            ),
            SizedBox(height: 50,),
            isLoading? CircularProgressIndicator(color: Color(0XFFEB9079) ,) : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFFEB9079),
                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10))
              ),
                onPressed: (){
                  if(phoneNumberController.text.isEmpty){
                    showFlushbar(context,"Enter a Valid PhoneNumber");
                  }else {
                        setState(() {
                          isLoading = true;
                        });
                        FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+91${phoneNumberController.text}',
                            verificationCompleted: (PhoneAuthCredential) {},
                            verificationFailed: (e) {
                              setState(() {
                                isLoading = false;
                              });
                              showFlushbar(context, e.message!);
                            },
                            codeSent: (verificationId, forceResendingTocken) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpScreen(
                                          verificationID: verificationId,
                                          phoneNumber:
                                              '+91${phoneNumberController.text}',
                                        )),
                              );
                            },
                            codeAutoRetrievalTimeout: (verificatioId) {
                              // showFlushbar(context, "Auto retrival timeOut");
                            });
                      }
                    }, child: Text("Login",style: TextStyle(color: Colors.black),))
          ],
        ),
      ),
    );
  }
}
