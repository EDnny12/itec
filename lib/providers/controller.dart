
import 'package:flutter/material.dart';

class Controlador with ChangeNotifier{

  ScrollController _con = ScrollController();


   get con{
     return this._con;

   }

   dispose(){
    this. _con.dispose();
   }

}