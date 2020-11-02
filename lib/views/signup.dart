import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizmaker/helper/functions.dart';
import 'package:quizmaker/services/auth.dart';
import 'package:quizmaker/views/signin.dart';
import 'package:quizmaker/widgets/widgets.dart';
import 'package:random_string/random_string.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String userName, email, password, userId;
  bool _toggleVisibility = true;
  AuthService authService = new AuthService();

  signUp() async {
    if (_formKey.currentState.validate()) {
      authService.signUpWithEmailAndPass(email, password).then((value) {
        if (value.substring(0, 5) != 'Error') {
          HelperFunctions.saveUserLoggedInDetails(
              isLoggedIn: true, userId: value);
          print("User ID: $value");
          setUserDataa(value, email, userName);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        userId: value,
                      )));
        } else {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
              content: Text(value),
            ),
          );
        }
      });

      // FirebaseFirestore.instance
      //     .collection("User")
      //     .snapshots()
      //     .listen((snapshot) {
      //   snapshot.docs.forEach((doc)  {debugPrint(doc.data()["userEmail"]);});
      // });
    }
  }

  Future<void> setUserDataa(
      String userId, String userEmail, String userName) async {
    Map<String, String> userData = {
      "userId": userId,
      "userName": userName,
      "userEmail": userEmail,
    };
    if (userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection("User")
            .doc(userId)
            .set(userData)
            .catchError((e) {
          print(e.toString());
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Flexible(
                  flex: 5,
                  child: Image(image: AssetImage('assets/quizbg.png'))),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Flexible(
                flex: 2,
                child: TextFormField(
                  validator: (value) {
                    return value.isEmpty ? "Enter your name" : null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'Name',
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide()),
                  ),
                  onChanged: (value) {
                    userName = value;
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              Flexible(
                flex: 2,
                child: TextFormField(
                  validator: (value) {
                    return value.isEmpty ? "Enter your email" : null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide()),
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 60),
              Flexible(
                flex: 2,
                child: TextFormField(
                  validator: (value) {
                    return value.isEmpty ? "Enter your password" : null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: _toggleVisibility
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _toggleVisibility = !_toggleVisibility;
                          });
                        }),
                    labelText: 'Password',
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide()),
                  ),
                  obscureText: _toggleVisibility,
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Flexible(
                flex: 2,
                child: GestureDetector(
                  onTap: () {
                    signUp();
                  },
                  child: submitButton(context: context, text: "Sign Up"),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
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
