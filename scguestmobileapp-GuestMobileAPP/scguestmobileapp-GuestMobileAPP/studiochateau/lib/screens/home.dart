import 'package:flutter/material.dart';
import 'package:studiochateau/utils/auth.dart';
import 'package:studiochateau/utils/common.dart';
import 'package:studiochateau/screens/catalog.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/models/authtoken.dart';

class Home extends StatefulWidget {   
  final GuestUser guestUser;
  final AuthToken authToken;
  final int planId;
  Home({Key key, this.guestUser, this.authToken, this.planId}) : super(key : key);
  @override
  HomeState createState() =>  new HomeState(); 
}


class HomeState extends State<Home> with WidgetsBindingObserver  {
  AppLifecycleState _applifecycle;
  DateTime _pausedTime;
  DateTime _resumedTime;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) { 
    setState(() {
      _applifecycle = state;   
    });
    if(_applifecycle == AppLifecycleState.paused){ 
      setState(() {
        _pausedTime = DateTime.now();
      });
    }
    else if(_applifecycle == AppLifecycleState.resumed){
      _resumedTime = DateTime.now();
      int sessionTime = _resumedTime.difference(_pausedTime).inMinutes;
      if(sessionTime >= 20){
        new AuthStateProvider().notify(AuthState.LOGGED_OUT);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    GuestUser guestUser = widget.guestUser;
    final body =  new ListView.builder(
      shrinkWrap: true,
      scrollDirection:Axis.vertical,
      padding: new EdgeInsets.all(20.0),                  
      itemCount: guestUser.guestUserPlans.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(                    
          child: new Container(
            margin: new EdgeInsets.all(10.0),
            padding: new EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[                               
                new Container(
                  child:GestureDetector(
                    onTap: () {  
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new Catalog(guestUser:guestUser, planId: guestUser.guestUserPlans[index].plan_id, authToken:widget.authToken),
                        )
                      );
                    },                                      
                    child: new Text('PLAN: ' + guestUser.guestUserPlans[index].plan_name , style:  new TextStyle(color: Colors.blue,fontSize: 20.0),),
                  ),
                ),
                new Container(
                  child:GestureDetector(
                    onTap: () {                  
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new Catalog(guestUser:guestUser, planId: guestUser.guestUserPlans[index].plan_id,authToken: widget.authToken)
                        )
                      );
                     },
                    child: new Image.network(Utilities.PlanImagesURL +  guestUser.guestUserPlans[index].plan_image , fit: BoxFit.fill,),
                  ),
                ),
              ],
            ) 
          )
        );
      },
    );

    return new Scaffold(
      appBar: Utilities.getAppBar(context, guestUser, widget.authToken, 0),
      body: body,
      drawer: Utilities.getDrawer(context, guestUser, widget.authToken, 0),
      bottomNavigationBar: Utilities.getBottomBar(context, guestUser, guestUser.guestUserPlans[0].plan_id, widget.authToken),
    );
  }
}