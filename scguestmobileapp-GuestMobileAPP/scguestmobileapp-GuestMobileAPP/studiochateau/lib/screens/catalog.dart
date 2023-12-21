import 'package:flutter/material.dart';
import 'package:studiochateau/utils/common.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/utils/network.dart';
import 'package:studiochateau/screens/options.dart';
import 'package:studiochateau/models/authtoken.dart';
import 'package:studiochateau/models/category.dart';

class Catalog extends StatefulWidget {
  final int planId;
  final GuestUser guestUser;  
  final AuthToken authToken;
  Catalog({Key key, this.guestUser, this.planId, this.authToken}) :super(key:key);
  @override
  CatalogState createState() =>  new CatalogState(); 
}

class CatalogState extends State<Catalog> {
  BuildContext _ctx;
  List<Widget> _tiles =  new List<Widget>();
  List<StaggeredTile> _staggeredTiles =  new List<StaggeredTile>();
  List categories;
  String imageURL;  
  int categoryId;
  bool _isLoading = false;
  Category category = new Category();
  
 
  @override
  void initState() {
    super.initState();
    setState(() => _isLoading = true);
    getCategories(widget.guestUser.communityId, widget.planId, widget.guestUser.userAccountId, widget.authToken.token_type, widget.authToken.access_token);
  }

  void getCategories(int communityId, int planId,  int userAccountId, String tokenType, String accessToken)  {   
    NetworkUtil _netUtil = new NetworkUtil();
    Map<String, String> headers = {"Authorization":"$tokenType $accessToken","Content-Type":"application/json"};
    _netUtil.get(Utilities.CategoriesURL + 'planId=$planId&communityId=$communityId&userAccountId=$userAccountId',
      headers: headers).then((res){
      categories = res;
      for(int i=0; i<categories.length; i++){                
        imageURL = Utilities.CategoryImagesURL + categories[i]['CategoryImage'];
        category.categoryName = categories[i]['CategoryName'];
        if(imageURL.contains('Horizontal')){                          
          _staggeredTiles.add( new StaggeredTile.extent(2, 135.0));
        }
        else if (imageURL.contains('Vertical')){ 
          _staggeredTiles.add( new StaggeredTile.extent(1, 274.0));              
        }
        else {             
          _staggeredTiles.add( new StaggeredTile.extent(1, 135.0));
        }  
        _tiles.add(              
          new  GestureDetector(
            onTapDown:(TapDownDetails details) { setState((){});
            },
            onTapUp: (TapUpDetails details) {
              setState(() {
                categoryId = categories[i]['CategoryId'];
                category.categoryName = categories[i]['CategoryName'];
                onCategoryClick(widget.guestUser, planId, categoryId, widget.authToken);
              });
            },        
            child:  new Container(                
              alignment: Alignment.bottomCenter,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage(imageURL),
                  fit: BoxFit.fill
                )
              ),
              child: new Container(
                alignment: Alignment.centerLeft,
                padding: new EdgeInsets.only(left: 5.0),
                height: 35.0,                     
                color: Colors.black45,
                child: new Text('${category.categoryName}',style: new TextStyle(color: Colors.white,fontSize: 10.0),),
              ),
            )
          )
        );
      }//For loop
      setState(() => _isLoading = false);
    });   
  }


  void onCategoryClick(GuestUser guestUser, int planId,  int categoryId, AuthToken authToken)  {
    var route = new MaterialPageRoute(
      builder: (BuildContext context) => new Options(guestUser:guestUser, planId:planId, categoryId:categoryId, authToken: widget.authToken, category: category),
    );
    Navigator.of(_ctx).push(route);
  }

  @override
  Widget build(BuildContext context)  {
    _ctx = context;
    final body = _tiles.length == 0 ? 
      new Center(child: new Text('No Catalog exists for selected plan', style: new TextStyle(fontWeight:FontWeight.bold),)) 
      : new StaggeredGridView.extent(
      padding: new EdgeInsets.all(10.0),
      maxCrossAxisExtent: 135.0,                                    
      children: _tiles,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,            
      staggeredTiles: _staggeredTiles,      
    );

    return new Scaffold(
      appBar: Utilities.getAppBar(context, widget.guestUser, widget.authToken, widget.planId),
      body: _isLoading ?  Utilities.bodyProgress() : body,
      drawer: Utilities.getDrawer(context, widget.guestUser, widget.authToken, widget.planId),
      bottomNavigationBar: Utilities.getBottomBar(context, widget.guestUser, widget.planId, widget.authToken),
    );
  }
}