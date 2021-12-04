import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_meter/data.dart';
import 'package:smart_meter/screens/homescreen.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  var emailPassword = '';
  var verifying = false;
  var buttonText = 'Login';
  var passwordVisible = false;

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
                            Navigator.pop(context);
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
                child: Email(),
              )
            ],
          )
        ],
      ),
    );
  }

  void validateEmail() async{
    if(verifying){
      return;
    }
    setState(() {
      buttonText = "Verifying...";
      verifying = true;
    });
    var res = await Provider.of<Data>(context, listen: false).validateEmail(emailPassword);
    if(res == "Error"){
      setState(() {
        buttonText = "Incorrect Details";
        verifying = false;
      });
      return;
    }
    if(res == "Success") {
      await Provider.of<Data>(context, listen: false).getDashboardData();
      setState(() {
        verifying = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  // ignore: non_constant_identifier_names
  Widget Email() {
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
          "Email?",
          style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.12,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 20.0,),
        TextFormField(
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
          keyboardAppearance: Brightness.light,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Enter Email',
            labelStyle: new TextStyle(fontSize: MediaQuery.of(context).size.width*0.05, height: 0.5),
            focusColor: const Color(0xFFF77C25),
            counterText: '',
          ),
          onChanged: (value) {
            Provider.of<Data>(context, listen: false).changeLoginEmail(value);
            setState(() {
              buttonText = 'Login';
            });
          },
        ),
        SizedBox(height: 20.0,),
        TextFormField(
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
          keyboardAppearance: Brightness.light,
          autofocus: true,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            labelText: 'Enter Password',
            labelStyle: new TextStyle(fontSize: MediaQuery.of(context).size.width*0.05, height: 0.5),
            focusColor: const Color(0xFFF77C25),
            counterText: '',
            suffixIcon: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: IconButton(
                icon: Icon(
                   passwordVisible
                   ? Icons.visibility
                   : Icons.visibility_off,
                   color: Colors.black,
                 ),
                onPressed: () {
                   setState(() {
                     passwordVisible = !passwordVisible;
                   });
                 },
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              emailPassword = value;
              buttonText = 'Login';
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
            onPressed: validateEmail,
            child: Text(
              "$buttonText",
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.06,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0,),
      ],
    );
  }


}
