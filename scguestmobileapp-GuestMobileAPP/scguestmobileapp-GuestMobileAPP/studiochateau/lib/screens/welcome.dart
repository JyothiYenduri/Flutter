import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:studiochateau/utils/common.dart';
import 'package:studiochateau/utils/network.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/models/authtoken.dart';
import 'package:studiochateau/models/welcomeInfo.dart';

class Tabs{
  String title;
  String content;
  String id;
  Tabs({this.title, this.content, this.id});
}

class Welcome extends StatefulWidget{
  final GuestUser guestUser;
  final AuthToken authToken;
  final int planId;
  Welcome({Key key, this.guestUser, this.authToken, this.planId}) : super(key: key);
  @override
  WelcomeState createState() => new WelcomeState();
}


class WelcomeState extends State<Welcome> with WidgetsBindingObserver, TickerProviderStateMixin  {
  final webView = new FlutterWebviewPlugin();
  StreamSubscription _onDestroy;
  bool _isLoading = false; 
  WelcomeInfo welcomeInfo = new WelcomeInfo();
  List<Tabs> items = List<Tabs>();
  String htmlContent = '';
  bool flag = true, flag1 = true;

  @override
  void initState(){
    super.initState();
    webView.close();
    setState(() => _isLoading = true);
    WidgetsBinding.instance.addObserver(this);
    getWelcomeinfo(widget.guestUser.communityId, widget.guestUser.builderId, widget.authToken.token_type, widget.authToken.access_token);   

    _onDestroy = webView.onDestroy.listen((_){
      Navigator.pop(context);    
    });
  }

  @override
  void dispose() {
    webView.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _onDestroy.cancel();
    super.dispose();
  }

  void getWelcomeinfo(int communityId, int builderId, String tokenType, String accessToken){
    NetworkUtil _netUtil = new NetworkUtil();
    Map<String, String> headers = {"Authorization":"$tokenType $accessToken","Content-Type":"application/json"};
    _netUtil.get(Utilities.WelcomeInfoURL + 'builderId=$builderId&communityId=$communityId',
      headers: headers).then((res) {  
        res.forEach((info){
          welcomeInfo.title =info['Title'];
          welcomeInfo.content = info['Content'];
          welcomeInfo.id = info['Id'];     
          Tabs tabs = new Tabs();
          tabs.title = welcomeInfo.title;
          tabs.content = welcomeInfo.content;  
          tabs.id = welcomeInfo.id;
          items.add(tabs);  
        });
        getTabs();  
    });
  }

  getTabs() {
    setState(() {
      htmlContent = '<!DOCTYPE html>'
                    '<html lang="en">'
                    '<head>'
                      '<meta charset="utf-8">'
                      '<meta name="viewport" content="width=device-width, initial-scale=1">'                     
                      '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">'
                      '<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>'
                      '<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>'
                      '<style>' 
                      '.tabbable-line > .list-inline > li.active { border-bottom: 4px solid #5bc0de;position:relative},'
                      '</style>'
                    '</head>'
                    '<body>'
                      '<br />' 
                      '<div class="tabbable-panel">'
                      '<div class="tabbable-line">'
                      '<ul class="list-inline">';

      items.forEach((Tabs tab){
        if(flag == true){        
          htmlContent += '<li class="active" style="margin:10px;margin-bottom:10px;"><a style="text-decoration:none;padding:15px;background:none;border-left:hidden;border-top:hidden;border-right:hidden" data-toggle="tab"  href="#${tab.id}">${tab.title}</a></li>';
          setState(() {
            flag = false;
          });
        }
        else{
          htmlContent += '<li style="margin:10px;margin-bottom:10px;";><a style="text-decoration:none;padding:15px;background:none;border-top:none;border-left:hidden;border-right:hidden;" data-toggle="tab" href="#${tab.id}">${tab.title}</a></li>';
        }   
      });

      htmlContent += '</ul><p style="border-bottom: 1px solid grey;" /><div class="tab-content">';

      items.forEach((Tabs tab){   
        if(flag1 == true){           
          htmlContent += '<div id="${tab.id}" class="tab-pane active">'
         '<h4>${tab.content}</h4>'  
          '</div>';
          setState(() {
            flag1 = false;
          });
        }
        else{
          htmlContent +=                
          '<div id="${tab.id}" class="tab-pane">'
          '<h4>${tab.content}</h4>'  
          '</div>';
        }  
      });
      htmlContent += '</div></div></body></html>'; 
    }); 
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context){
   
    WebviewScaffold webviewscaffold = new WebviewScaffold(
        appBar: new AppBar(
          iconTheme: new IconThemeData(
          color: Colors.black,
          size: 120.0,
        ),
        backgroundColor: Colors.white,      
        centerTitle: true,
          title: new Container(
            padding: EdgeInsets.only(top:9.0),
            child:new Column(        
              children: <Widget>[
                new  Text(widget.guestUser.communityName,  style: new  TextStyle(color: Colors.black), ), 
                new  Text('by ' + widget.guestUser.builderName, style: new  TextStyle(color: Colors.black, fontSize: 14.0,), ), 
              ]
            ), 
          ),
          bottom: new PreferredSize(            
            preferredSize: new Size.fromHeight(2.0),
              child: new Container(
                color:Colors.lightBlue.shade300,
                height: 2.0,
                alignment: Alignment.center,                              
            ),
          ),
        ),
        url: items.length == 0 ?  Uri.dataFromString('<h4 Style="font-weight:500;text-align:center;padding-top:50%;padding-bottom:50%;">No Welcome page exists</h4>', mimeType: 'text/html').toString()
        : Uri.dataFromString(htmlContent, mimeType: 'text/html').toString(),
        withJavascript: true,
        withLocalUrl: true,
        clearCache: true,
        withLocalStorage: true,
      );

    return new Scaffold(
      body: _isLoading ? Utilities.bodyProgress() : webviewscaffold    
    );   
  }
}
