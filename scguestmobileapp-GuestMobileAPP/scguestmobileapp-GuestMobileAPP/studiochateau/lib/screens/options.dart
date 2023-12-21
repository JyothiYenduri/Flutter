import 'package:flutter/material.dart';
import 'package:studiochateau/utils/common.dart';
import 'package:studiochateau/utils/network.dart';
import 'package:studiochateau/screens/optionDetails.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/models/option.dart';
import 'package:studiochateau/models/category.dart';
import 'package:studiochateau/models/authtoken.dart';


class Options extends StatefulWidget {
  final int categoryId;
  final int planId;  
  final GuestUser guestUser;
  final AuthToken authToken; 
  final Category category;
  Options({Key key, this.guestUser, this.planId, this.categoryId, this.authToken, this.category}) : super(key: key);
  @override
  OptionsState createState() => new  OptionsState(); 
} 

class OptionsState extends State<Options> {
  List<Widget> _choices =  new List<Widget>();
  Map<int, dynamic> options = new Map<int, dynamic>();
  Map<int, dynamic> choices = new Map<int, dynamic>();
  Map<int, dynamic> tempOptions = new Map<int, dynamic>();  
  bool _isLoading = false; 
  
  @override
  void initState(){
    super.initState();
    setState(() => _isLoading = true);
    getChoices(widget.guestUser.communityId, widget.planId, widget.categoryId, widget.authToken.token_type, widget.authToken.access_token);    
  }  

  void getChoices(int communityId, int planId, int categoryId, String tokenType, String accessToken)  {
    NetworkUtil _netUtil = new NetworkUtil();
    Map<String, String> headers = {"Authorization":"$tokenType $accessToken","Content-Type":"application/json"};
    _netUtil.get(Utilities.ChoicesURL + 'planId=$planId&communityId=$communityId&categoryId=$categoryId',
      headers: headers).then((res){     
        res.forEach((choice)  {
        int choiceId = choice['choice_id'];
        choices[choiceId] = choice;  
        loadOptions(planId,communityId,choiceId,tokenType,accessToken);       
      });
    }); 
  }

  loadOptions(int planId, int communityId, int choiceId, String tokenType, String accessToken) {
     
    NetworkUtil _netUtil = new NetworkUtil();
    Map<String, String> headers = {"Authorization":"$tokenType $accessToken","Content-Type":"application/json"};
    _netUtil.get(Utilities.OptionsURL + 'planId=$planId&communityId=$communityId&choiceId=$choiceId',
      headers: headers).then((res1){  
      options[res1[0]['choice_id']] = res1;
      if(options.length == choices.length){ 
        choices.forEach((choiceid,choice){ 
          options.forEach((k,v){                
          if(k== choiceid)
            tempOptions[k] = v; 
          });//options
        });//CHOICES
        if(tempOptions.length == choices.length){ 
          buildBody();
        }
        setState(() => _isLoading = false);
      }                  
    });             
  }

  
  void onOptionSelect(String choiceName, dynamic res ) {
    Option option = new Option();
    option.optionImage =  res['option_image'];
    option.optionId= res['option_id'];
    option.optionDisplayDesc = res['option_display_desc'];
    option.optionNo  = res['option_no'];
    option.price = res['Price'];
    option.legendImage = res['legend_image'];
    option.legendCaption = res['legend_caption'];
    var route = new MaterialPageRoute(
      builder: (BuildContext context) => new  OptionDetails(guestUser:widget.guestUser, planId:widget.planId, choiceName:choiceName, option:option, authToken: widget.authToken, category: widget.category),
    );
    Navigator.of(context).push(route);
  }

  List<Widget> getTiles(String choiceName, dynamic options){
    List<Widget> _options =  new List<Widget>(); 
    options.forEach((option){
      _options.add(
        new GestureDetector(
          onTapDown:(TapDownDetails details) {setState((){});
          },
          onTapUp: (TapUpDetails details) {setState(() {
              onOptionSelect(choiceName, option);
            });
          },
          child: new Container(                      
            width: 250.0,
            child: new Card(               
              child: new Padding(                 
                padding: new EdgeInsets.all(20.0),                 
                child: new Container(                
                  alignment: Alignment.bottomCenter,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage(Utilities.OptionImagesURL + option['option_image'].trim()),
                      fit: BoxFit.contain
                    )
                  ),
                  child: new Container(
                    alignment: Alignment.centerLeft,
                    padding: new EdgeInsets.only(left: 5.0),
                    height: 35.0,                     
                    color: Colors.black45,
                    child: new Text(option['option_no'],style: new TextStyle(color: Colors.white,fontSize: 10.0),),
                  ),
                )
              ),
            )
          )
        )
      );
    });
    return _options;
  }

  void buildBody(){          
    tempOptions.forEach((k,v){     
      _choices.add(
        new Container(
          padding: new EdgeInsets.only(left: 10.0),
          alignment: Alignment.centerLeft,
          height: 60.0,
          color: Colors.green,
          child: new Text(choices[k]['choice_name'], style: new TextStyle(color: Colors.white,fontSize: 20.0),),
        ),
      ); 
      _choices.add(
          new Container(                                          
            width: 250.0,                                         
            height: 375.0,                                               
            child: new ListView.builder(
              padding: new EdgeInsets.all(10.0),
              scrollDirection: Axis.horizontal,
              itemCount: v.length,
              itemBuilder: (BuildContext context, int index) =>  getTiles(choices[k]['choice_name'], v)[index]         
            )
          ),
        ); 
    });
  }

  @override
  Widget build(BuildContext context){  
    final body = new Column(
      children: <Widget>[
        new Flexible(
          child: new CustomScrollView(              
            shrinkWrap: true,
            slivers: <Widget>[                          
              new SliverPadding(
                padding: new EdgeInsets.only(top:0.0, left: 0.0,right: 0.0,bottom:10.0),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate(_choices),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    return new Scaffold(
      appBar: Utilities.getAppBar(context, widget.guestUser, widget.authToken, widget.planId),
      body: _isLoading ?  Utilities.bodyProgress() : body,
      drawer: Utilities.getDrawer(context, widget.guestUser, widget.authToken, widget.planId),
      bottomNavigationBar: Utilities.getBottomBar(context, widget.guestUser, widget.planId, widget.authToken),
    );
  }
}

