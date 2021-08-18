import 'dart:convert';

import 'package:aara_tech/model/data_model.dart';
import 'package:aara_tech/signup.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aara_tech/home.dart';
import 'package:http/http.dart' as http;

void main() => runApp(AaraTech());


class AaraTech extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,);
  }
}


class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sharedPreferences;
  Map mapResponse;
  List listOfFacts;

  Future fetchData() async {
    http.Response response;
    response = await http.get(Uri.parse('https://career-finder.aaratechnologies.in/job/api/all_job'));
    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        listOfFacts = mapResponse['data'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
    loginStatus();
  }

  loginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (
          Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: Column(
              children: [ Container(
                height: 100,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Colors.blueAccent,
                child: Row(
                    children: [
                      Column(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 45,),
                          IconButton(icon: Icon(
                            Icons.menu, color: Colors.white, size: 30,),),

                        ],),
                      SizedBox(width: 216,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () {},
                              icon: Icon(
                                Icons.search, size: 30, color: Colors.white,)),
                          SizedBox(height: 6,)
                        ],

                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () {},
                              icon: Icon(Icons.filter_alt_outlined, size: 30,
                                color: Colors.white,)),
                          SizedBox(height: 6,)
                        ],

                      ),
                    ]),
              ),

                Column(
                  children:[ ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 150,
                         margin: EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Align(alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    listOfFacts[index]['designation'].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                              Align(alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    listOfFacts[index]['author'].toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Align(alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:10.0),
                                  child: Row(
                                    children:[ Container(height: 30,
                                    width:100,
                                      decoration: BoxDecoration(color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 5,),
                                          Icon(Icons.work_outline_rounded,size: 15,),
                                          SizedBox(width: 5,),
                                          Text(listOfFacts[index]['exp'].toString()),
                                        ],
                                      ),
                                    ),
                                      SizedBox(width: 10,),
                                      Container(height: 30,
                                        width:100,
                                        decoration: BoxDecoration(color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          children: [
                                            SizedBox(width: 5,),
                                            Icon(Icons.location_on,size: 15,),
                                            SizedBox(width: 5,),
                                            Text(listOfFacts[index]['job_location'].toString())
                                          ],
                                        ),
                                      ),
                                  ]),
                                ),
                              ),
                               SizedBox(height: 5,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(Icons.info_outline),
                                  Text(listOfFacts[index]['technology'].toString())
                                ],),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: listOfFacts == null ? 0 : listOfFacts.length,
                  ),
                    IconButton(onPressed: (){
                      sharedPreferences.clear();
                      sharedPreferences.commit();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (Route<dynamic> route) => false);
                    }, icon: Icon(Icons.logout,size: 30,))
                ]),
              ],
          ),
        ),

    );
  }
}