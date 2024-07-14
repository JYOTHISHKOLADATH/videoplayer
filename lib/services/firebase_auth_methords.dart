// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import '../utils/anotherflushbar.dart';
//
// class FireBaseAuthMethods{
//   final FirebaseAuth _auth;
//   FireBaseAuthMethods(this._auth);
//
//   //phone Signin
//  Future<void> phoneSignIn(BuildContext context,String phonenumber) async{
//    await _auth.verifyPhoneNumber(
//      phoneNumber: phonenumber,
//        verificationCompleted: (PhoneAuthCredential credential)async{
//        _auth.signInWithCredential(credential);
//        },
//        verificationFailed: (e){
//          showFlushbar(context,e.message!);
//        },
//        codeSent: ((String verificationId,int? resendToken) async{
//
//        }),
//        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
//    );
//  }
// }