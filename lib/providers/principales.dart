import 'package:flutter/material.dart';
import 'package:itec/widgets/lista_avisos.dart';
import 'package:itec/widgets/lista_convocatorias.dart';
import 'package:itec/widgets/Oficiales.dart';
class Principal with ChangeNotifier{
     final _clase=[PageOne(),PageTwo(),PageThree()];
     int _current=0;
     get clase{
       return _clase;
     }
     get current{
       return _current;
     }
     set current(final int valor){
       this._current=valor;
       notifyListeners();
     }


}