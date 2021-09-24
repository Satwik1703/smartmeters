import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';
import 'package:smart_meter/screens/homescreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _verificationId;
  var firebaseOtp;

  @override
  void initState() {
    super.initState();
  }

  void verifyPhoneNumber() async{
    PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
        // await _auth.signInWithCredential(phoneAuthCredential);
        // print("Phone number automatically verified and user signed in: ${_auth.currentUser.uid}");
      };

    PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
        print("Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${authException.code}. ${authException.message}'), duration: const Duration(seconds: 5),));
      };

    PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
        print('Please check your phone for the verification code.');
        setState(() {
          _verificationId = verificationId;
        });
      };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
        print("verification code: " + verificationId);
        setState(() {
          _verificationId = verificationId;
        });
      };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${Provider.of<Data>(context, listen: false).mobile_number}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }
    catch (e) {
      print("Failed to Verify Phone Number: $e");
    }
  }

  var otp_sent = false;
  var user = "Get OTP";
  var verifyOtp = "Verify";
  var otp = '';
  var verifying = false;

  validateOtp() async {
    if(verifying){
      return;
    }
    setState(() {
      verifyOtp = "Verifying...";
      verifying = true;
    });
    //Firebase Auth---
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: '$firebaseOtp',
      );

      final User user = (await _auth.signInWithCredential(credential)).user;
      print("Successfully signed in UID: ${user.uid}");
    }
    catch (e) {
      if(e.toString().contains('expired')){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP has expired. Please try again'), duration: const Duration(seconds: 3),));
      }
      else if(e.toString().contains('too-many')){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Received Too many requests from this number. Please try later'), duration: const Duration(seconds: 3),));
      }
      print("Failed to sign in: " + e.toString());
      setState(() {
        verifyOtp = "Wrong OTP";
        verifying = false;
      });
      return;
    }
    //-----

    var res = await Provider.of<Data>(context, listen: false).validateOtp();
    if(res == "Error"){
      setState(() {
        verifyOtp = "Wrong OTP";
        verifying = false;
      });
      return;
    }
    if(res == "Success"){
      await  Provider.of<Data>(context, listen: false).getDashboardData();
      setState(() {
        verifying = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
      print('OTP verified');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Stack(
                  children: [
                    Positioned(
                        bottom: 0,
                        left: -10,
                        child: RawMaterialButton(
                          onPressed: () {
                            if(otp_sent) {
                              Provider.of<Data>(context, listen: false).changeMobileNumber('');
                              setState(() {
                                otp_sent = false;
                              });
                            }
                            else {
                              Navigator.pop(context);
                            }
                          },
                          child: Stack(
                            children: [
                              Hero(tag: 'img', child: Image.asset('assets/icons/triangle_right.png')),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 10,
                                child: Image.asset('assets/icons/arrow_left.png'),
                              )
                            ],
                          ),
                        )
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: AnimatedSwitcher(
                  duration: const Duration(seconds: 2),
                  child: !otp_sent ? MobileNumber() : OTP(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget OTP() {
    var txt = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "OTP sent to",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.12
          ),
        ),
        Text(
          "+91 ${Provider.of<Data>(context).mobile_number}",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width * 0.12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0,),
        PinCodeTextField(
          controller: txt,
          appContext: context,
          pastedTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          length: 6,
          animationType: AnimationType.fade,

          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            activeColor: const Color(0xFFB6B6B6),
            activeFillColor: const Color(0xFFB6B6B6),
            inactiveColor: const Color(0xFFB6B6B6),
            selectedColor: const Color(0xFFB6B6B6),
            borderRadius: BorderRadius.circular(50),
            fieldHeight: 50,
            fieldWidth: 40,
          ),
          cursorColor: Colors.white,
          animationDuration: Duration(milliseconds: 100),
          enableActiveFill: false,
          enablePinAutofill: true,
          keyboardType: TextInputType.number,
          autoFocus: true,
          onCompleted: (v) => validateOtp(),
          onSubmitted: (v) => validateOtp(),
          onChanged: (value) {
            // Provider.of<Data>(context, listen: false).changeOtp(value);
            setState(() {
              firebaseOtp = value;
              verifyOtp = "Verify";
              verifying = false;
            });
          },
          onTap: () async{
            ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
            txt.value = TextEditingValue(
              text: data.text,
              selection: TextSelection.fromPosition(
                TextPosition(offset: data.text.length),
              ),
            );
          },
          beforeTextPaste: (text) {
            return false;
          },
        ),
        SizedBox(height: 20.0,),
        Container(
          height: MediaQuery.of(context).size.width * 0.15,
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xFFF77C25),
              borderRadius: BorderRadius.all(Radius.circular(9.0))
          ),
          child: RawMaterialButton(
            onPressed: () => validateOtp(),
            child: Text(
              "$verifyOtp",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        )
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget MobileNumber() {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What's your",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.12
                ),
              ),
              Text(
                "Mobile Number?",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.width * 0.12,
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                keyboardAppearance: Brightness.light,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Enter mobile Number',
                  labelStyle: new TextStyle(fontSize: MediaQuery.of(context).size.width*0.05, height: 0.5),
                  focusColor: const Color(0xFFF77C25),
                  prefixText: '+91 ',
                  counterText: '',
                ),
                onChanged: (value) {
                  Provider.of<Data>(context, listen: false).changeMobileNumber(value);
                  setState(() {
                    user = "Get OTP";
                  });
                },
              ),
              SizedBox(height: 20.0,),
              Container(
                height: MediaQuery.of(context).size.width * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF77C25),
                  borderRadius: BorderRadius.all(Radius.circular(9.0))
                ),
                child: RawMaterialButton(
                  onPressed: () async{
                    if(Provider.of<Data>(context, listen: false).mobile_number.length == 10){
                      setState(() {
                        user = "Getting OTP...";
                      });
                      var res = await Provider.of<Data>(context, listen: false).getOtp();
                      if (res == "Error"){
                        setState(() {
                          user = "No User Found";
                        });
                        return;
                      }

                      verifyPhoneNumber();

                      setState(() {
                        otp_sent = true;
                      });
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP is $res'), duration: const Duration(seconds: 5),));
                      // setState(() {
                      //   otp = res;
                      // });
                    }
                    else{
                      setState(() {
                        user = "Check Mobile Number";
                      });
                    }
                  },
                  child: Text(
                    "$user",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                    ),
                  ),
                ),
              )
            ],
          );
  }
}
