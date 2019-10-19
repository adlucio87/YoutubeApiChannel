import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:youtubeapichannel/Model/YoutubeData.dart';
import 'package:youtubeapichannel/Pages/PlayVideoPage.dart';


List<YoutubeDto> ytResult = [];


class YoutubeVideoList extends StatefulWidget {

  YoutubeVideoList( List<YoutubeDto> ytResultin )
  {
    ytResult = ytResultin;

  }
  
  @override
  _YoutubeVideoListState createState() => new _YoutubeVideoListState();
}

class _YoutubeVideoListState extends State<YoutubeVideoList> {

  var unescape = new HtmlUnescape();

  load() async
  {

  }

  @override
  void initState() {    
    super.initState();
    load();

    setState(() {
      print('UI Updated');
    });

  }

  @override
  Widget build(BuildContext context) {          
          return new Container(
           child: ListView.builder(
                itemCount: ytResult.length,
                itemBuilder: (_, int index) => listItem(index)                
            )
          );     
  }

  
  Widget listItem(index){
    return  new GestureDetector(
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayVideoRoute( ytResult[index] )),
            );
        },  
        child: new Card(               
      child: new Container(        
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child:new Row(
          children: <Widget>[
            new Image.network(ytResult[index].image,),
            new Padding(padding: EdgeInsets.only(right: 20.0)),
            new Expanded(child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                   unescape.convert(ytResult[index].title),
                  softWrap: true,
                  style: TextStyle(fontSize:18.0),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                new Text(
                   unescape.convert(ytResult[index].channelTitle),                  
                  softWrap: true,
                ),
                //new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                //new Text( ytResult[index].url,softWrap: true,),
              ]
            ))
          ],
        ),
      ),
    ));

  }
  
  }
