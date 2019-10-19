import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:youtubeapichannel/Model/YoutubeData.dart';


YoutubeDto _ytResult;
SharedPreferences preferences;

class PlayVideoRoute extends StatefulWidget {

     PlayVideoRoute(YoutubeDto ytResult)
     {
        _ytResult = ytResult;        
     }

    @override
    _PlayVideoRouteState createState() => new _PlayVideoRouteState();
}


class _PlayVideoRouteState extends State<PlayVideoRoute> {

  var unescape = new HtmlUnescape();

  loadShared() async{preferences = await SharedPreferences.getInstance();}
 
  @override
  void initState() {
    super.initState();
   loadShared();     
  }

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }
     
  YoutubePlayerController _controller = YoutubePlayerController();

   void listener() {
    if (_controller.value.playerState == PlayerState.ENDED) {         
        preferences.setBool("video"+_ytResult.id, true);
        _showThankYouDialog();
    }
    /*setState(() {
      _playerStatus = _controller.value.playerState.toString();
      _errorCode = _controller.value.errorCode.toString();
      print(_controller.value.toString());
    });*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("video"),
      ),
      body: 
      Column(
  children: [

  YoutubePlayer(
      context: context,
      videoId: _ytResult.id,
      flags: YoutubePlayerFlags(
          autoPlay: false,
          showVideoProgressIndicator: true,
      ),
      videoProgressIndicatorColor: Colors.amber,
      progressColors: ProgressColors(
        playedColor: Colors.amber,
        handleColor: Colors.amberAccent,
      ),
      onPlayerInitialized: (controller) {
        _controller = controller;
        _controller.addListener(listener);
      },
  ),
    
  Padding(
    padding: EdgeInsets.all(5.0),
    child:  Card(child: Text( unescape.convert(_ytResult.title),
                                  style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold)  
                                 )),
  ),
    
  Padding(
    padding: EdgeInsets.all(5.0),
    child:  Card(child: Text( unescape.convert(_ytResult.description),
                                 style: TextStyle(color: Colors.black, fontSize: 16.0) 
                                 )),
  ),
    
  Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[ 

        MaterialButton(
          elevation: 5.0,
          color: Colors.grey,
          padding: EdgeInsets.all(15.0),
          child: Text("Go back!"),
          onPressed: () {Navigator.pop(context);},
        ),
        
       
      ],
    ),
  )
    
    ]    
        
      ),
    );
  }
     
     
  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Video Ended"),
          content: Text("thanks for watching the video. Hope it was helpful. Now test yourself with a quiz!"),
        );
      },
    );
  }
     
}


