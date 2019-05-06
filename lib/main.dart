import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
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
      backgroundColor: Color.fromRGBO(0,0,0, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(67, 67, 67,1),
        centerTitle: true,
        title: Text("My News"),
      ),
      body: new ListView.builder(

        
       
        itemCount: data==null?0:data.length,
        itemBuilder: (BuildContext context,int index)
        { 
          
          return new ListTile(
            title: new Card(
              color: Color.fromRGBO(67,67,67,1),
              elevation: 5.0,
              child: new Container(
                decoration:BoxDecoration(gradient: LinearGradient(colors: [Color.fromRGBO(0,0,0, 1),Color.fromRGBO(67, 67, 67,1)])) ,
                
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
                        
                      Flexible(child: Text(data[index]['title'],style: TextStyle(color: Colors.white),))   
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
              
              Navigator.push(context, new MaterialPageRoute(builder:(context)=>Mysimpleview(data[index]["title"],data[index]["urlToImage"],data[index]["content"],url) ),);
            },
          );
        },
        
      )
      
    );
  }
}

class Mysimpleview extends StatelessWidget {
  Mysimpleview(this.title,this.image,this.data,this.link);
  final String title,image,data,link;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: new Stack(
      fit: StackFit.expand,
      children: [
         new Image.network(image,fit: BoxFit.cover),
        new BackdropFilter(
    filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
    child: new Container(
      color: Colors.black.withOpacity(0.5),
    ),),

     new SingleChildScrollView(
    child: new Container(
      margin: const EdgeInsets.all(20.0),
      child: new Column(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            child: new Container(width: 400.0,height: 400.0,),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10.0),
              image: new DecorationImage(image: new NetworkImage(image),fit: BoxFit.cover),
              boxShadow: [
                new BoxShadow(
                  color: Colors.black,
                  blurRadius: 20.0,
                  offset: new Offset(0.0, 10.0)
                )
              ]
            ),
            
          ),

             new Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 0.0),
      child: new Row(

        children: <Widget>[
          new Expanded(child: new Text(title,style: new TextStyle(color: Colors.white,fontSize: 30.0,fontFamily: 'Arvo'),)),
        ],
      ),
    ),
    new GestureDetector(
       onTap: () { 
                       Navigator.push(context, new MaterialPageRoute(builder:(context)=>FullNews(link) ),);

       },
       child: new Text(data,style: new TextStyle(color: Colors.white,fontFamily: 'Arvo'),)
        )
    ,
    
    new Padding(padding: const EdgeInsets.all(10.0)),

        ]
      ),
    ),
   ),

    
      ]
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