import 'package:flutter/material.dart';
import 'package:studiochateau/utils/common.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:studiochateau/models/option.dart';
import 'package:studiochateau/models/category.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/models/authtoken.dart';
import 'package:studiochateau/screens/optionImage.dart';

class OptionDetails extends StatefulWidget {
  final GuestUser guestUser;
  final AuthToken authToken;
  final Option option;
  final String choiceName;
  final int planId;
  final Category category;
  OptionDetails({Key key, this.guestUser, this.planId, this.choiceName, this.option, this.authToken, this.category}) : super(key: key);
  @override
  OptionDetailsState createState() => new  OptionDetailsState(); 
} 

class OptionDetailsState extends State<OptionDetails> {
 
  @override
  Widget build(BuildContext context){
    String markdown = html2md.convert('${widget.option.optionDisplayDesc}');
    return new Scaffold(
      appBar: Utilities.getAppBar(context, widget.guestUser, widget.authToken, widget.planId),      
      body: new Container( 
        color: Colors.white24,    
        child: new Column(   
          children: <Widget>[
            new Flexible(
              child: new CustomScrollView(              
                shrinkWrap: true,
                slivers: <Widget>[                          
                  new SliverPadding(
                    padding: new EdgeInsets.only(top:0.0, left: 10.0,right: 10.0),
                    sliver: new SliverList(
                      delegate: new SliverChildListDelegate(
                         <Widget>[ 
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new Wrap(                                                         
                              children: <Widget>[
                                new Text(widget.category.categoryName, style: new TextStyle(fontSize: 20.0,)),                                  
                                new Icon(Icons.arrow_forward), 
                                new Text(widget.choiceName, softWrap: true, style: new TextStyle(fontSize: 20.0,))                                 
                              ],
                            ),
                          ),                                                                                                                                                               
                          new Container(                          
                            padding: new EdgeInsets.only(left: 20.0),
                            alignment: Alignment.centerLeft,
                            height: 60.0,
                            color: Colors.green,
                            child: new Text('${widget.choiceName}', style: new TextStyle(color: Colors.white,fontSize: 20.0),),
                          ),                      
                          new Wrap(                                                 
                            children: <Widget>[
                              new Container(    
                                color: Colors.white,                  
                                width: 350.0,
                                height:600.0,
                                alignment: Alignment.center,
                                child: new Card(    
                                  child: new Padding(                 
                                    padding: new EdgeInsets.all(10.0),                                                 
                                      child: new GestureDetector(                                      
                                        child: new Container(
                                          alignment: Alignment.bottomCenter,
                                          decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                              image: new NetworkImage(Utilities.OptionImagesURL + widget.option.optionImage.trim(),)
                                            )
                                          ),                                     
                                          child: new Container(
                                            alignment: Alignment.centerLeft,
                                            padding: new EdgeInsets.only(left: 5.0),
                                            height: 35.0,                     
                                            color: Colors.black45,
                                            child: new Text('${widget.option.optionNo}',style: new TextStyle(color: Colors.white,fontSize: 10.0),),
                                          ),
                                        ),                                                                             
                                        onTap: (){                                                                    
                                          Navigator.push(context, new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                              new OptionImage(planId:widget.planId,optionImage: widget.option.optionImage, guestUser:widget.guestUser, choiceName:widget.choiceName, option:widget.option, authToken: widget.authToken, category: widget.category)
                                            ),
                                         );                                 
                                        },
                                      ), 
                                    )
                                  ),  
                              ),   
                              new Container(
                                width: 350.0,
                                margin: new EdgeInsets.all(20.0),
                                child:new Column(
                                  children: <Widget>[                                      
                                    new Container(                           
                                      margin: new EdgeInsets.only(bottom:10.0),
                                      child:new Text('${widget.option.optionNo}'),   
                                    ),
                                    new Container(
                                      padding: new EdgeInsets.only(bottom:5.0),
                                      child: widget.option.legendImage == null ? new Container() :
                                      new Row(
                                        children: <Widget>[
                                          new Image.network(Utilities.LegendImageURL + widget.option.legendImage),
                                          new Text('  - placement icon'),
                                        ]
                                      ), 
                                    ),
                                    new MarkdownBody(
                                      data: markdown,
                                    ),
                                    new Row(
                                      children: <Widget>[
                                        new Icon(Icons.attach_money, size: 20.0,),
                                        new Text('${widget.option.price}'),
                                      ],
                                    )
                                  ],
                                )
                               ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
      drawer: Utilities.getDrawer(context, widget.guestUser, widget.authToken, widget.planId),
      bottomNavigationBar: Utilities.getBottomBar(context, widget.guestUser, widget.planId, widget.authToken),
    );
  }
}