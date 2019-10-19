import 'package:flutter/material.dart';
import 'package:youtubeapichannel/Model/YoutubeData.dart';
import 'package:youtubeapichannel/UI/YoutubeVideoList.dart';

List<YoutubeDto> categoryList;
YoutubeData youtubeData;

class Category extends StatefulWidget {

  Category(YoutubeData inyoutubeData)
  {
    youtubeData = inyoutubeData;
  }

  @override
  _CategoryState createState() => new _CategoryState();
}



class _CategoryState extends State<Category> {

  String _currentPlaylistID;
  
  @override
  void initState() {    
    super.initState();
    categoryList = youtubeData.allCategory();
     /*setState(() {
      print('UI Updated');
    });*/
  }

  @override
  Widget build(BuildContext context) {
    
    if(_currentPlaylistID == null || _currentPlaylistID.isEmpty) {
          return new Container(
           child: ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (_, int index) => listItem(index)                
            )
          );
        }
    else{
         return WillPopScope(
          onWillPop: () async {
              Future.value(false);
              setState(() { _currentPlaylistID = null; });
          },           
          child:  YoutubeVideoList(youtubeData.getCategoryVideoList(_currentPlaylistID) ),
         );
    }
    
  }
  
  Widget listItem(index){
    return  new GestureDetector(
        onTap: (){
          setState(() {_currentPlaylistID = categoryList[index].id; });         
        },  
        child: new Card(               
      child: new Container(        
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child:new Row(
          children: <Widget>[
            new Image.network(categoryList[index].image,),
            new Padding(padding: EdgeInsets.only(right: 20.0)),
            new Expanded(child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  categoryList[index].title,
                  softWrap: true,
                  style: TextStyle(fontSize:18.0),
                ),
                new Padding(padding: EdgeInsets.only(bottom: 1.5)),
              ]
            ))
          ],
        ),
      ),
    ));

  }
  
  }




