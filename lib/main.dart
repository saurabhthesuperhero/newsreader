import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main()=>runApp(new MaterialApp(
  home: HomePage(),
));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final String url="https://newsapi.org/v2/top-headlines?country=in&apiKey=a623caffeac64ef480c975e30bcca20b";
  List data;
 
  @override
  void initState()
  {
    super.initState();
    this.getJsonData();
  }

  Future<String>getJsonData()async{
    var response=await http.get(
      Uri.encodeFull(url),
      headers: {"Accept":"application/json"}
    );
    
    setState(() {
      var convertDataToJson=json.decode(response.body);
      data=convertDataToJson['articles'];
      print(data);
    });
    return "Success";
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My app"),
      ),
      body: new ListView.builder(
        
       
        itemCount: data==null?0:data.length,
        itemBuilder: (BuildContext context,int index)
        { 
          
          return new ListTile(
            title: new Card(
              elevation: 5.0,
              child: new Container(
                decoration: BoxDecoration(border: Border.all(color:Colors.orange)),
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                        child:  Image.network(data[index]["urlToImage"]),
                        padding:EdgeInsets.only(bottom:8.0),

                    ),

                    Row(
                      children: <Widget>[
                        
                      Flexible(child: Text(data[index]['title'],))   
                       , 
                        
                      ],
                    )
                    
                  ],
                ),


              ),
            ),
            onTap: ()
            { 
              var url=data[index]["url"];
              Navigator.push(context, new MaterialPageRoute(builder:(context)=>FullNews(url) ),);
            },
          );
        },
        
      )
      
    );
  }
}


class FullNews extends StatelessWidget {
  FullNews(this.newsurl);
  final String newsurl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full News"),

      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[MaterialApp(
            routes: 
            {
              "/":(_)=>new WebviewScaffold(
                url: newsurl,
                appBar: AppBar(title: Text(""),),
              )
            },
          )],
        ),
      ),
    );
  }
}