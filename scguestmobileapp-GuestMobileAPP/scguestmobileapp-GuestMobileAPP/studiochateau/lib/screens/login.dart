import 'package:flutter/material.dart';
import 'package:studiochateau/utils/auth.dart';
import 'package:studiochateau/utils/network.dart';
import 'package:studiochateau/utils/common.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/models/plan.dart';
import 'package:studiochateau/models/authtoken.dart';
import 'package:studiochateau/screens/home.dart';

abstract class LoginScreenContract {
  void onLoginSuccess();  
  void onLoginError();  
}

class Login extends StatefulWidget {
  @override
  LoginState createState() => new  LoginState(); 
}

class LoginState extends State<Login> implements LoginScreenContract, AuthStateListener {  
  final GuestUser guestUser = new GuestUser();
  final AuthToken authToken = new AuthToken();
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String _username, _password;
  String errorMsg = '';
 
  LoginState(){ 
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  
  void doLogin(String username, String password) {       
    NetworkUtil _netUtil = new NetworkUtil();
    List data, plans;
    Map<String, String> headers = {"Content-Type":"application/x-www-form-urlencoded", "Accept":"application/json"};
    _netUtil.post(Utilities.TokenURL, body: {"username":username, "password":password,"grant_type":"password"},
      headers: headers).then((response){
        setState(() {
          authToken.token_type = response['token_type'];
          authToken.access_token = response['access_token'];
        });
      });

    headers = {"ContentType":"application/json","Accept": "application/json"};
    _netUtil.post(Utilities.LoginURL, body: {"sLogin": username, "sPassword":password, "sRemoteIP":"55.23.56.85"},
    headers: headers).then((res){       
      if(res.length==0){onLoginError();}
      else{onLoginSuccess();}
      setState(() {  
        data = res;   
        guestUser.builderId = data[0]['GuestUser'][0]['builder_id'];
        guestUser.builderName = data[0]['GuestUser'][0]['builder_name'];
        guestUser.communityId = data[0]['GuestUser'][0]['CommunityID'];
        guestUser.communityName = data[0]['GuestUser'][0]['CommunityName'];
        guestUser.communityImage = data[0]['GuestUser'][0]['community_image'];
        guestUser.userAccountId = data[0]['GuestUser'][0]['UserAccountID'];
        guestUser.fullName = data[0]['GuestUser'][0]['FullName'];
        plans = data[0]['GuestUserPlans'];
        plans.forEach((f){
          Plan plan = new Plan();
          plan.plan_id = f['plan_id'];
          plan.plan_image = f['plan_image'];
          plan.plan_name = f['plan_name'];
          guestUser.guestUserPlans.add(plan);
        });
      });         
    });
  }


  void submit() {
    final form = formKey.currentState;  
    if (form.validate()) {     
      setState(() => _isLoading = true);
      form.save();
      guestUser.guestUserPlans.clear();
      doLogin(_username, _password);   
    }
  }

  @override
  onAuthStateChanged(AuthState state) {
    if(state == AuthState.LOGGED_IN){
       Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) =>
        new Home(guestUser:guestUser, authToken: authToken,planId: guestUser.guestUserPlans[0].plan_id,)
        )
      );
    }
  }

  String _validateUsername(String value){
    if(value.trim().length == 0){   
      return 'Username is required';
    }
    setState(() {
          errorMsg = ' ';
        });
    return null; 
  }

  String _validatePassword(String value){
    if(value.trim().length == 0){
      return 'Password is required';
    }
    setState(() {
          errorMsg = ' ';
        });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var loginBtn = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 16.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(5.0),
        shadowColor: Colors.green.shade300,
        elevation: 5.0,
        child: new MaterialButton(
          minWidth: 250.0,
          height: 60.0,
          onPressed: submit,          
          color: Colors.green,
          child: new Text('Log In', style: new TextStyle(color: Colors.white)),
        ),
      ),
    );

    var loginForm = new Column(
      children: <Widget>[          
        new Form(
          key: formKey,
          child: new Column(            
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child:  new TextFormField(
                  initialValue: 'trainingguest',                 
                  onSaved: (val) => _username = val,  
                  validator: _validateUsername,                                                         
                  decoration: new  InputDecoration(
                    icon: new Icon(Icons.account_circle),
                    hintText: 'Username',
                    contentPadding: new  EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    border: new  OutlineInputBorder(),
                  ),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new  TextFormField(
                  initialValue: 'trainingguest',
                  onSaved: (val) => _password = val,  
                  validator: _validatePassword,                               
                  obscureText: true,
                  decoration:  new InputDecoration(
                    icon: new Icon(Icons.lock),
                    hintText: 'Password',
                    contentPadding:  new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
                    border:  new OutlineInputBorder(),
                  ),
                ),
              ),
              new Container(        
                child:  new Container(
                  child: new Text(errorMsg, style: new TextStyle(color: Colors.red),)
                ),
              ),           
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child:  new FlatButton(
                  child: new  Text(
                    'Forgot password?',
                    style:  new TextStyle(color: Colors.black),
                  ),
                  onPressed: () {},
                )
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  
    final logo =  new Hero(
      tag: 'hero',
      child: new  CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: new  Image.asset('assets/logo.png'),
      ),
    );

    return  new Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body:  new Center(                   
        child: new ListView(         
        shrinkWrap: true,
        padding: new  EdgeInsets.only(left: 24.0, right: 24.0),
        children: <Widget>[
          logo,
          loginForm,        
        ],
      ),
      ), 
    );
  } 

  @override
  void onLoginSuccess() async {  
    setState(() { _isLoading = false;}); 
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }

  @override 
  void onLoginError() {
    setState(() {
      errorMsg = 'Invalid Login Credentials.';
      _isLoading = false;
    }); 
  }
}