import 'package:flutter/material.dart';
import 'package:studiochateau/screens/home.dart';
import 'package:studiochateau/screens/catalog.dart';
import 'package:studiochateau/screens/login.dart';

final routes = {
  '/login': (BuildContext context) => new Login(),  
  '/' : (BuildContext context) => new Login(),
  '/home' : (BuildContext context) => new Home(),
  '/catalog': (BuildContext context) => new Catalog(),  
};