import 'package:flutter/material.dart';
import 'package:studiochateau/utils/routes.dart';

void main() => runApp( new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Studio Chateau',
      debugShowCheckedModeBanner: false,      
      routes: routes,
    );
  }  
}