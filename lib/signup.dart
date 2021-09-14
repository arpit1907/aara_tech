import 'dart:convert';

import 'package:aara_tech/home.dart';
import 'package:aara_tech/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
final _scaffoldkey = GlobalKey<ScaffoldState>();

class _SignUpState extends State<SignUp> {
  bool validation() {
    final FormState _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();

      return true;
    } else {
      return false;
    }
  }


  bool _isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  ScaffoldMessengerState scaffoldMessenger;
  TextEditingController _typeController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: MediaQuery.of(context).size.height,
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
                            'Signup',
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
                  Padding(padding: EdgeInsets.only(left:20,right: 20),
                    child: TextFormField(
                      controller: _typeController,
                      decoration: InputDecoration(hintText: "Seeker/Recruiter"),
                      autofocus: false,
                      validator: (value){
                        if(value.isEmpty)
                          return "Please enter a value";
                        return "";
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left:20,right: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "Your email"),
                      autofocus: false,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your email";

                        }
                        return "";
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left:20, right:20),
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      decoration: InputDecoration(hintText: "Your name"),
                      autofocus: false,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter your name";
                        }
                        return " ";
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left:20, right: 20),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _mobileController,
                      decoration: InputDecoration(hintText: "Your number"),
                      autofocus: false,
                      validator: (value){
                        if(value.isEmpty){
                          return "Please enter a valid mobile number";
                        }
                        return "";
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left:20, right: 20),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: "Password"),
                      autofocus: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter a valid password";
                        }
                        return " ";
                      }
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  FlatButton(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      color: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                       setState(() {
                         _isLoading = true;
                       });
                        signup(_typeController.text,_emailController.text,_nameController.text,_mobileController.text,
                            _passwordController.text,);
                       Toast.show("SignUp successful please login", context, duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);

                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Sign up',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            )),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.blueAccent),
                      ),),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (Route<dynamic> route) => false);
                        },
                        child: Text(
                          ' Login',
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> signup(type,email, name, mno,ps) async{
    print("Calling");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'type':type,
                'email': email,
                'name': name,
                'mno': mno,
                'ps': ps, };
     print(data.toString());
     var jsonResponse = null;
     final response = await http.post(
        Uri.parse('https://career-finder.aaratechnologies.in/job/api/signUp'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));
     if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      print(response.body);
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (!resposne['error']) {
        Map<String, dynamic> user = resposne['data'];
        print(" User name ${user['data']}");
        savePref(1,user['type'],user['email'], user['name'], user['mobile'], user['password']);
        sharedPreferences.setString("token", jsonResponse['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);
       // Navigator.pushReplacementNamed(context, "/home");
      } else {
        print(" ${resposne['message']}");
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("${resposne['message']}")));
    } else {
       _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Try again")));
    }
  }

  savePref(int value,String type,String email,String name, int mno, String ps ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt("value", value);
    preferences.setString("type", type);
    preferences.setString("email", email);
    preferences.setString("name", name);
    preferences.setInt("mno", mno);
    preferences.setString("ps", ps);
    preferences.commit();
  }
}
