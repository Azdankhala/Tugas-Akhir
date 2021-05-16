import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/Screen/loginScreen.dart';
import 'package:rider_app/Screen/mainscreen.dart';
import 'package:rider_app/main.dart';

class RegisterScreen extends StatelessWidget
{
  static const String idScreen = "register";

  TextEditingController nametextEditingController = TextEditingController();
  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController phoneextEditingController = TextEditingController();
  TextEditingController passwordtextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 1.0,),
              Text(
                "Register",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nametextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordtextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 20.0,),
                    RaisedButton(
                      color: Colors.brown,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Creat Account",
                            style: TextStyle(fontSize: 18.0, fontFamily: "Brand Bold"),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: ()
                      {
                        if(nametextEditingController.text.length < 3)
                          {
                            displayToastMessage("Name must be atleast 3 characters", context);
                          }
                        else if(!emailtextEditingController.text.contains("@"))
                          {
                            displayToastMessage("Email address is not Valid", context);
                          }
                        else if(phoneextEditingController.text.isEmpty)
                        {
                          displayToastMessage("Please fill the phone number", context);
                        }
                        else if(passwordtextEditingController.text.length < 6)
                        {
                          displayToastMessage("Password must be atleast 6 characters", context);
                        }
                        else
                          {
                            registerNewUser(context);
                          }
                      },
                    ),
                  ],
                ),
              ),

              FlatButton(
                onPressed: ()
                {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login Here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registering, please wait...",);
        }
    );

    final User firebaseUser = ( await _firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailtextEditingController.text,
        password: passwordtextEditingController.text
    ).catchError((errMsg){
      Navigator.pop(context);
      displayToastMessage("Error: " + errMsg.toString(), context);
    })).user;

    if(firebaseUser != null)//user created
      {
        //save user info to database
      usersRef.child(firebaseUser.uid);

      Map userDataMap = {
        "name": nametextEditingController.text.trim(),
        "email": emailtextEditingController.text.trim(),
        "phone": phoneextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Your Account has been created", context);

      Navigator.pushNamedAndRemoveUntil(context,MainScreen.idScreen, (route) => false);
      }
    else
      {
        Navigator.pop(context);
        //error occured
        displayToastMessage("New user account has not been Created", context);
      }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
