import 'package:flutter/material.dart';



class Network with ChangeNotifier{
     bool _conexion =false;


      get conexion{
        return _conexion;
      }
      set conexion(final bool value){
        this._conexion=value;
        notifyListeners();
      }

}