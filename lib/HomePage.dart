import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  final String title;
  HomePage({
    Key key,
    @required
    this.title
  }):super(key:key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = "https://randomuser.me/api/?results=50";
  List usersData;
  bool isLoading = true;

  Future<String> getData() async{
    var responce = await http.get(Uri.encodeFull(url));
    //this time body is also in form of list (like bodyData->List(results) && result[0]->List)
    List convertToJSON = json.decode(responce.body)['results'];    
    setState(() {
      usersData = convertToJSON;
      isLoading = false;
    });
    // print(usersData);
  }

  @override
  void initState(){
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users API"),
      ),
      body: Container(
        color: Colors.grey,
        child: Center(
          child: isLoading
          ?CircularProgressIndicator()
          :ListView.builder(
            itemCount: usersData == null? 0 : usersData.length,
            itemBuilder: (BuildContext context,int index){
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                child:Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Image(
                        width: 70.0,
                        height: 70.0,
                        fit:BoxFit.contain,
                        image: NetworkImage(
                          usersData[index]['picture']['thumbnail'],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(padding:EdgeInsets.all(30.0) ,),
                          Container(
                            margin: EdgeInsets.only(left:20.0),
                            child:Text(usersData[index]['name']['first']+" "+usersData[index]['name']['last'],
                              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,),
                            ),
                          ),
                          Padding(padding:EdgeInsets.all(5.0) ,),
                          Container(
                            margin: EdgeInsets.only(left:20.0),
                            child:Text("Age: ${usersData[index]['dob']['age']}",
                              style: TextStyle(fontSize: 20.0),
                            )
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 10.0, right: 0.0),
                            leading: Icon(Icons.person),
                            title: Align( 
                              alignment: Alignment(-1.2, 0),
                              child:Text(usersData[index]['gender']),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 10.0, right: 0.0),
                            leading: Icon(Icons.phone),
                            title: Align( 
                              alignment: Alignment(-1.3, 0),
                              child:Text(usersData[index]['phone']),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 10.0, right: 0.0),
                            leading: Icon(Icons.email),
                            title: Align( 
                              alignment: Alignment(-1.3, 0),
                              child:Text(usersData[index]['email']),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ),
      ),
    );
  }
}