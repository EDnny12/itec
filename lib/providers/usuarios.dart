import 'package:flutter/material.dart';

class Usuarios with ChangeNotifier{

  String _email=null;

  get email{
    return _email;
  }
  set email(final String ema){
      this._email=ema;
      notifyListeners();
  }
}