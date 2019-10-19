import 'package:flutter/material.dart';
import 'Model/YoutubeData.dart';
import 'Pages/Category.dart';
import 'Pages/Home.dart';

void main() async {
  runApp(MaterialApp(
        home: MainServices()
    ),
  );
}

class MainServices extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _MainServicesState();
  }
}

YoutubeData youtubeData;

class _MainServicesState extends State<MainServices> {

  //remoteConfig.getString('youtubeApiKey')
  static String key = "";// ** ENTER YOUTUBE API KEY HERE **
  static String channelid = "UC_8mNVpafplqHNy85No4O2g";// ** ENTER YOUTUBE CHANNEL ID HERE **

  loadData() async
  {
      

      if(youtubeData==null){
        youtubeData = YoutubeData(key, channelid);
        youtubeData.allYoutubeVideoList = new List<YoutubeDto>();
        await youtubeData.checkAndLoad();
      }
      
      _children = new List<Widget>();
      _children.add(Home(youtubeData));
      _children.add(Category(youtubeData));
    
      setState(() {print("ui rebuild"); });
  }

  @override
  void initState() {    
    super.initState();
    loadData();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;
  List<Widget> _children;


  getbody()
  {
    if (_children !=null)  
      return _children[_currentIndex];
    else return Container();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: "Youtube channel",
      theme:   ThemeData(primarySwatch: Colors.indigo,),
    
      home: new Scaffold(
     
      appBar: new AppBar(     
          backgroundColor: Colors.white,   
            title: Text("Youtube channel") ,
             
      ),

      body: getbody(),
      
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
               onTap: onTabTapped,
       currentIndex: _currentIndex,
       items: [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.category),
           title: new Text('Category'),
         ),
       ],

     ),

      )
    );
  }
  

}


