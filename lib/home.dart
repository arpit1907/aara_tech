import 'dart:convert';

import 'package:aara_tech/main.dart';
import 'package:aara_tech/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obserText = true;

class _MyHomePageState extends State<MyHomePage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  ScaffoldMessengerState scaffoldMessenger;

  TextEditingController _typeController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  // bool validation() {
  //   final FormState _form = _formKey.currentState;
  //   if (_form.validate()) {
  //     _form.save();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  bool isLoading = false;
  bool _isLoading = false;
  var errorMsg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldkey,
      body:  SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children:[ Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 180,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 40,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Seeker',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Recruiter',
                          style: TextStyle(fontSize: 28, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 300,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Your type',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextFormField(
                          controller: _typeController,
                          decoration: InputDecoration(
                              hintText: "", border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == "")
                              return "Please enter your type";
                            return "";
                          },
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Your email',
                          style: TextStyle(fontSize: 18),
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: "", border: OutlineInputBorder()),
                          validator: (value) {
                            if (value == "")
                              return "Please enter your email";
                            else if (!regExp.hasMatch(value))
                              return "Please enter a valid email";
                            return "";
                          },
                        ),
                        SizedBox(height: 20),
                        Text('Password', style: TextStyle(fontSize: 18)),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: obserText,
                          decoration: InputDecoration(
                            hintText: "",
                            border: OutlineInputBorder(),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // Focus.of(context).unfocus();
                                setState(() {
                                  obserText = !obserText;
                                });
                              },
                              child: Icon(
                                  obserText == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value.length < 8)
                              return "Password is too short";
                            else if (value == "")
                              return "Please enter a valid password";

                            return "";
                          },
                        ),
                      ],
                    ),
                  ),
                  FlatButton(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    color: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        scaffoldMessenger.showSnackBar(
                            SnackBar(content: Text("Please Fill all fileds")));
                        return;
                      }
                      login(_typeController.text, _emailController.text,
                        _passwordController.text,);
                      setState(() {
                        _isLoading = true;
                      });
                      _scaffoldkey.currentState.showSnackBar(new SnackBar(duration: new Duration(seconds: 4),
                          content: new Row(
                            children: <Widget>[
                              new CircularProgressIndicator(),
                              new Text("  Logging-In...")
                            ],
                          )));
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don\'t have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => SignUp()), (
                              Route<dynamic> route) => false);
                        },
                        child: Text(
                          ' Register',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
        ]),
      ))
    ;
  }

  login(type, email, ps) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'type': type,
      'email': email,
      'ps': ps
    };
    var jsonResponse = null;
    print(data.toString());
    final response = await http.post(
        Uri.parse('https://career-finder.aaratechnologies.in/job/api/login'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8")
    );

    if (response.statusCode == 200) {
      print(response.statusCode);
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(response.body);
      Map<String, dynamic>resposne = jsonDecode(response.body);

      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['data']['token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MyApp()), (
            Route<dynamic> route) => false);
      }
    }
    else{
      setState(() {
        _isLoading = false;
      });
      errorMsg = response.body;
      print("The error message is: ${response.body}");
    }

  }
}