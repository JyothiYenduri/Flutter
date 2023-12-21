import 'package:flutter/material.dart';
import 'package:studiochateau/utils/common.dart';
import 'package:studiochateau/models/category.dart';
import 'package:studiochateau/models/option.dart';
import 'package:studiochateau/models/guestuser.dart';
import 'package:studiochateau/models/authtoken.dart';
import 'package:photo_view/photo_view.dart';

class OptionImage extends StatefulWidget{
  final GuestUser guestUser;
  final AuthToken authToken;
  final Option option;
  final String optionImage;
  final Category category;
  final String choiceName;
  final int planId;
  OptionImage({Key key, this.optionImage, this.category, this.choiceName, this.guestUser, this.authToken, this.option, this.planId}) : super(key: key);
  @override
  _OptionImageState createState() => _OptionImageState();
}

class _OptionImageState extends State<OptionImage> {

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: Utilities.getAppBar(context, widget.guestUser, widget.authToken, widget.planId), 
      backgroundColor: Colors.white,
      body: new Container(    
        padding: new EdgeInsets.all(30.0),       
        child: new PhotoViewInline(
          imageProvider: new NetworkImage(Utilities.OptionImagesURL + widget.optionImage.trim(),),
          maxScale: 4.0,
          minScale: PhotoViewScaleBoundary.contained,
          backgroundColor: Colors.white, 
          loadingChild: new Container(),
        ),
      ),                                                                                                                                          
      drawer: Utilities.getDrawer(context, widget.guestUser, widget.authToken, widget.planId),
      bottomNavigationBar: Utilities.getBottomBar(context, widget.guestUser, widget.planId, widget.authToken),
    );
  }
}

