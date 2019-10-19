/*[
    {
        "kind": "video",
        "id": "9vzd289Eedk",
        "channelTitle": "Java",
        "title": "WEBINAR - Programmatic Trading in Indian Markets using Python with Kite Connect API",
         "description": "For traders today, Python is the most preferred programming language for trading, as it provides great flexibility in terms of building and executing strategies.",
        "publishedAt":"2016-10-18T14:41:14.000Z",
        "channelId": "UC8kXgHG13XdgsigIPRmrIyA",
        "thumbnails": {
             "default": {
              "url": "https://i.ytimg.com/vi/9vzd289Eedk/default.jpg",
              "width": 120,
              "height": 90
             },
             "medium": {
              "url": "https://i.ytimg.com/vi/9vzd289Eedk/mqdefault.jpg",
              "width": 320,
              "height": 180
             },
             "high": {
              "url": "https://i.ytimg.com/vi/9vzd289Eedk/hqdefault.jpg",
              "width": 480,
              "height": 360
             }
        },
        "channelurl":"https://www.youtube.com/channel/UC8kXgHG13XdgsigIPRmrIyA",
        "url":"https://www.youtube.com/watch?v=9vzd289Eedk"
    },
    {
      "kind": "video"
       // Here will you next result
    },
    {
       // Here will you next result
    },
    {
       // Here will you next result
        "url":"https://www.youtube.com/watch?v=9vzd289Eedk"
    }
 ]
 */


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_api/youtube_api.dart';

class YoutubeData {


  String apikey;
  String channelId;
  List<YoutubeDto> allYoutubeVideoList = [];

  List<YoutubeDto> getHomeList() {
    return List<YoutubeDto>.from(allYoutubeVideoList.where((item) => item.kind == "video" && item.id != item.channelId ));
  }

  List<YoutubeDto> allCategory() {
        return List<YoutubeDto>.from(allYoutubeVideoList.where((item) => item.kind == "playlist" && item.id != item.channelId ));
  }
    
  List<YoutubeDto> getCategoryVideoList(String plylistID) {
        return List<YoutubeDto>.from(allYoutubeVideoList.where((item) => item.kind == "video" && item.id != item.channelId && item.playlist == plylistID ));
  }

  YoutubeData (this.apikey, this.channelId);

  checkAndLoad() async
  {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String>  videoIDList =  preferences.getStringList("VideoIdList");     

      if( videoIDList==null || videoIDList.length==0 )
      {
        await loadYtDataAndStoreInSharedPref();
      }
           
      await loadLocalDataAndAddQuestion();
  }

  

  loadYtDataAndStoreInSharedPref() async  {
      YoutubeAPI ytApi = new YoutubeAPI(apikey, maxResults: 50);
       List<YT_API> ytResult = await ytApi.channel( channelId );

      //salviamo il conteggio dei video in shared pref
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setInt("TotVideo", ytResult.length );
      
      //salviamo json youtube video in shared pref e lista video
      YoutubeDto youtubedto = new YoutubeDto();      
      List<String> videoIdList = new List<String>();
      for(var result in ytResult) {
        videoIdList.add( result.id);   
        String json = jsonEncode( youtubedto.yApitoJson(result) );
        preferences.setString( result.id, json );
      }

      preferences.setStringList("VideoIdList", videoIdList );

  }
    
    


  //aggiungiamo le domande agli oggetti youtube precedentemente salvati
  //potremmo anche aggiungere le categorie
  loadLocalDataAndAddQuestion() async  {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String>  videoIDList =  preferences.getStringList("VideoIdList");

      allYoutubeVideoList = new  List<YoutubeDto>();

      for(String videoID in videoIDList)
      {
        String jsonYoutube =  preferences.getString(videoID);

          Map userMap = jsonDecode(jsonYoutube);
          YoutubeDto youtubeDao  = new YoutubeDto.fromJson(userMap);      
          allYoutubeVideoList.add(youtubeDao);
      }

  }





}


class YoutubeDto {

  YoutubeDto();

 dynamic thumbnail;
  String kind,
      id,
      publishedAt,
      channelId,
      channelurl,
      title,
      description,
      channelTitle,
      url,
      image,
      questionJson,
      playlist; 

  YoutubeDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        kind = json['kind'],
        channelId = json['channelId'],
        channelurl = json['channelurl'],
        description = json['description'],
        channelTitle = json['channelTitle'],
        url = json['url'],       
        title = json['title'],
        image = json['image'];


 Map<String, dynamic> yApitoJson(YT_API yapi) =>
    {
      'kind': yapi.kind,
      'id': yapi.id,
      'channelId': yapi.channelId,
      'channelurl': yapi.channelurl,
      'description': yapi.description,
      'channelTitle': yapi.channelTitle,
      'url': yapi.url,
      'title': yapi.title,
      'image' : yapi.thumbnail['default']['url'],
    };

}
