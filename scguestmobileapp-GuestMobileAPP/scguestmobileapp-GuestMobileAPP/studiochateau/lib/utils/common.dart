import 'package:flutter/material.dart';
import 'package:studiochateau/utils/auth.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/models/plan.dart';
import 'package:studiochateau/screens/catalog.dart';
import 'package:studiochateau/screens/welcome.dart';
import 'package:studiochateau/models/authtoken.dart';

class Utilities {

  static const String PlanImagesURL = 'http://192.168.200.32/WWWImages/Images/Plans/';
  static const String CommunityImagesURL = 'http://192.168.200.32/WWWImages/Images/Communities/';
  static const String CategoryImagesURL = 'http://192.168.200.32/WWWImages/Images/Categories/';
  static const String OptionImagesURL = 'http://192.168.200.32/WWWImages/Images/Options/';
  static const String LegendImageURL = 'http://192.168.200.32/WWWImages/Images/Legends/';

  static const String TokenURL = 'http://192.168.200.32/SCPMobileAPI/Token';
  static const String LoginURL = 'http://192.168.200.32/SCPMobileAPI/api/Account/ValidateUserCredentials';

  static const String CategoriesURL = 'http://192.168.200.32/SCPMobileAPI/api/Categories/GetCategories?';
  static const String ChoicesURL = 'http://192.168.200.32/SCPMobileAPI/api/Choice/GetChoices?roleId=17&';
  static const String OptionsURL = 'http://192.168.200.32/SCPMobileAPI/api/Options/GetOptions?roleId=17&';
  static const String WelcomeInfoURL = 'http://192.168.200.32/SCPMobileAPI/api/Categories/GetwelcomeInfo?';

  static const String PlanImagesURL1 = 'http://uat.proqlogic.com/WWWImages/Images/Plans/';
  static const String CommunityImagesURL1 = 'http://uat.proqlogic.com/WWWImages/Images/Communities/';
  static const String CategoryImagesURL1 = 'http://uat.proqlogic.com/WWWImages/Images/Categories/';
  static const String OptionImagesURL1 = 'http://uat.proqlogic.com/WWWImages/Images/Options/';

  static const String LoginURL1 = 'http://uat.proqlogic.com/SCMobileAPI/api/Account/ValidateUserCredentials';
  static const String CategoriesURL1 = 'http://uat.proqlogic.com/SCMobileAPI/api/Categories/GetCategories?';
  static const String ChoicesURL1 = 'http://uat.proqlogic.com/SCMobileAPI/api/Choice/GetChoices?roleId=17&';
  static const String OptionsURL1 = 'http://uat.proqlogic.com/SCMobileAPI/api/Options/GetOptions?roleId=17&';


  static Column buildButtonColumn(IconData icon, String label, Color color, String tag, BuildContext context, GuestUser guestUser, int planId, AuthToken authToken) {     
    return  new Column(        
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[                   
        new IconButton(
          icon: new Icon(icon),
          color: color,
          onPressed: ()  {
            if(tag == '/home'){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new Welcome(guestUser:guestUser, authToken: authToken, planId: planId,)
                )
              );
            }
            else if(tag == '/catalog'){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new Catalog(guestUser:guestUser, planId: planId, authToken: authToken)
                )
              );
            }           
            else if(tag == '/back') { 
              Navigator.of(context).pop();                                       
            }                                                   
          },
        ),
        new Text(label, style:TextStyle(color:color)),
      ],
    );
  }

  static AppBar getAppBar(BuildContext context, GuestUser guestUser, AuthToken authToken, int planId){
    return new AppBar(  
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
            new  Text(guestUser.communityName,  style: new  TextStyle(color: Colors.black), ), 
            new  Text('by ' + guestUser.builderName, style: new  TextStyle(color: Colors.black, fontSize: 14.0,), ), 
          ]
        ),      
      ),
      actions:<Widget>[
        new PopupMenuButton<Plan>(  
          onSelected: (Plan result) {      
            Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context) =>
                new Catalog(guestUser:guestUser, planId: result.plan_id, authToken: authToken)
              )
            );
          },                     
          itemBuilder: (BuildContext context) {         
            return guestUser.guestUserPlans.map((Plan plan) {                                  
              return new PopupMenuItem<Plan>(
                value: plan, 
                child: new Row(
                  children: <Widget>[
                    planId == plan.plan_id ? new Icon(Icons.check_circle, color: Colors.green ) : new Container(),           
                    new Text('  Plan: ' +  plan.plan_name),
                  ],
                )
              );
            }).toList();
          },
        ),
      ],
      bottom: new PreferredSize(            
        preferredSize: new Size.fromHeight(2.0),
          child: new Container(
            color:Colors.lightBlue.shade300,
            height: 2.0,
            alignment: Alignment.center,                              
        ),
      ),
    );
  }
  
  static Widget bodyProgress(){    
    return new Container(
      child: new Stack(
        children: <Widget>[                
          new Container(
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              color: Colors.white70,
            ),
            child: new Container(
              decoration: new BoxDecoration(
                color: Colors.blue[200],
                borderRadius: new BorderRadius.circular(10.0)
              ),
              width: 300.0,
              height: 200.0,
              alignment: AlignmentDirectional.center,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Center(
                    child: new SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: new CircularProgressIndicator(
                        value: null,
                        strokeWidth: 7.0,
                      ),
                    ),
                  ),
                  new Container(
                    margin: new EdgeInsets.only(top: 25.0),
                    child: new Center(
                      child: new Text(
                        "loading.....",
                        style: new TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Drawer getDrawer(BuildContext context, GuestUser guestUser, AuthToken authToken, int planId) {
    return new Drawer(      
      child:  new  ListView(        
        children: <Widget> [                      
          new  Container(
            color: Colors.green,
            child: new Column(
              children: <Widget>[
                new ListTile(              
                  leading: new Icon(Icons.menu, color: Colors.white),                  
                  onTap: () {Navigator.pop(context);},
                ),
                new  ListTile(
                  leading: new Icon(Icons.account_circle, color: Colors.white),
                  title: new Text('My Profile', style: new  TextStyle(color:Colors.white),),
                  onTap: () {},
                ),
                new  ListTile(
                  leading: new Icon(Icons.settings, color: Colors.white),
                  title: new Text('Settings', style: new  TextStyle(color:Colors.white),),
                  onTap: () {},
                ),
                new  ListTile(
                  leading: new Icon(Icons.help, color: Colors.white),
                  title: new Text('Help', style: new  TextStyle(color:Colors.white),),
                  onTap: () {},
                ),
                new  ListTile(
                  leading: new Icon(Icons.web, color: Colors.white),
                  title: new Text('Welcome', style: new  TextStyle(color:Colors.white),),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new Welcome(guestUser:guestUser, planId: planId, authToken: authToken)
                      )
                    );
                  },
                ),              
                 new ListTile(              
                  leading: new Icon(Icons.lock, color: Colors.white),
                  title:new Text('Logout', style: new  TextStyle(color:Colors.white),),
                  onTap: () {                 
                    new AuthStateProvider().notify(AuthState.LOGGED_OUT);
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                ),
              ],
            ),
          ),
          new  Container(
            padding: EdgeInsets.all(30.0),            
            child: new Image.network(CommunityImagesURL + guestUser.communityImage , fit: BoxFit.fill,),
          ),
          new ListTile(                
            title: new Text(guestUser.communityName + ' ' + 'by\n' +  guestUser.builderName ,),                     
          ),
          new ListTile(    
            leading: new Icon(Icons.copyright, color: Colors.black),
            title: new Text('Copyright Studio Chateau 2018 ' ,),            
          ),
        ],
      ),
    );
  }
  static BottomAppBar getBottomBar(BuildContext context, GuestUser guestUser, int planId, AuthToken authToken){
    return  new BottomAppBar(
      color: Colors.white,
      child: new Container(
        padding: new  EdgeInsets.fromLTRB(0.0,2.0, 0.0,2.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [   
            buildButtonColumn(Icons.home, 'Home', Colors.green, '/home', context, guestUser, planId, authToken),         
            buildButtonColumn(Icons.dashboard, 'Catalog', Colors.green, '/catalog', context, guestUser, planId, authToken),
            buildButtonColumn(Icons.arrow_back, 'Back', Colors.green, '/back', context, guestUser, planId, authToken),                               
          ],
        ),
      ),
    );
  }
}