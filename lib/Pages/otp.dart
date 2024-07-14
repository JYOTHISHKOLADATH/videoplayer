import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:screen_protector/screen_protector.dart';

import '../utils/anotherflushbar.dart';
import 'home.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen(
      {super.key, required this.verificationID, required this.phoneNumber});
  final String verificationID;
  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _preventScreenShotsOn();
    super.initState();
  }

  void _preventScreenShotsOn() async =>
      await ScreenProtector.preventScreenshotOn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "OTP havebeen Shared to \n ${widget.phoneNumber}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )),
            const SizedBox(
              height: 10,
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: otpController,
              decoration: InputDecoration(
                  hintText: "OTP",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(
              height: 10,
            ),
            isLoading
                ? const CircularProgressIndicator(
                    color: Color(0XFFEB9079),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFEB9079),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      if (otpController.text.isEmpty) {
                        showFlushbar(context, "Enter a Valid OTP");
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          final cred = PhoneAuthProvider.credential(
                              verificationId: widget.verificationID,
                              smsCode: otpController.text);
                          await FirebaseAuth.instance
                              .signInWithCredential(cred);
                          setState(() {
                            isLoading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Home()),
                          );
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          showFlushbar(context, e.toString());
                        }
                      }
                    },
                    child: const Text(
                      "Verify",
                      style: TextStyle(color: Colors.black),
                    ))
          ],
        ),
      ),
    );
  }
}
