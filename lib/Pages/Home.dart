import 'package:flutter/material.dart';
import 'package:youtubeapichannel/Model/YoutubeData.dart';
import 'package:youtubeapichannel/UI/YoutubeVideoList.dart';


  YoutubeData youtubeData;

  class Home extends StatefulWidget {

      Home(YoutubeData inyoutubeData)
      {
        youtubeData = inyoutubeData;
      }

    @override
    _HomeState createState() => new _HomeState();
  }


  class _HomeState extends State<Home> {

    callAPI() async {
      setState(() {print('UI Updated'); });      
    }

    @override
    void initState() {    
      super.initState();
      //callAPI();
    }

    @override
    Widget build(BuildContext context) {
      if(youtubeData!=null)
        return new YoutubeVideoList(youtubeData.getHomeList());
      else
        return new Container(child:new Text("problem loading data from youtube!"));
    }
  }
