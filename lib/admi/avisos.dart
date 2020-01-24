import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:itec/providers/estilos.dart';
import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:itec/providers/metodos.dart';
import 'package:itec/providers/principales.dart';
import 'package:provider/provider.dart';
class Homa extends StatefulWidget {
  @override
  _HomaState createState() => _HomaState();
}

class _HomaState extends State<Homa> {

  List<File> _images;

 final StorageReference reference =
  FirebaseStorage.instance.ref().child("Image.jpg");
  bool cu = false;
  bool texto = false;
  String dow = "";
  bool subio = false;
  String titulo = "";
  String des = "";
  String videourl="";
  String videoLink;
  bool uno = false, dos = false, tres = false;
  @override

  void _AddData() {
    final String links=Metodos().lins(des);
    Firestore.instance.runTransaction((Transaction transaccion) async {
      CollectionReference reference = Firestore.instance.collection('noticias');
      CollectionReference red=Firestore.instance.collection("lista");
      await reference.add({
        "titulo": titulo.toUpperCase(),
        "descripcion": des,
        "foto": dow.length >=4 ?dow.split(",") :"",
        "link":links.length>=4 ? links.split("|"):"",
        "fecha":DateTime.now(),

      });
      await red.add({
        "titulo":titulo,
        "de":"noticias"
      });
    });

    Navigator.of(context).pop();
  }
  void _AddDataConvocatoria() {
    final String links=Metodos().lins(des);
    Firestore.instance.runTransaction((Transaction transaccion) async {
      CollectionReference referencesx = Firestore.instance.collection('convocatorias');
      CollectionReference red=Firestore.instance.collection("lista");
      await referencesx.add({
        "titulo": titulo.toUpperCase(),
        "descripcion": des,
        "foto": dow.length >=4 ?dow.split(",") :"",
        "link":links.length>=4 ? links.split("|"):"",
        "fecha":DateTime.now(),
      });
      await red.add({
        "titulo":titulo,
        "de":"convocatorias"
      });
    });

    Navigator.of(context).pop();
  }



  Future uploadImage() async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            Metodos().animacionCargando(context, "Aviso",1)
    );

    if (_images != null) {
      for (int x = 0; x < _images.length; x++) {
        StorageReference reference =
            FirebaseStorage.instance.ref().child(titulo + x.toString());

        StorageUploadTask uploadTask = reference.putFile(_images[x]);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        if (x == 0) {
          dow = await reference.getDownloadURL();
        } else {
          dow = dow + "," + await reference.getDownloadURL();
        }
      }
    }

    _AddData();

    setState(() {
      subio = true;
    });
    _snackBarCargaCompleta();
  }


  Future uploadImageConvocatoria() async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            Metodos().animacionCargando(context, "Convocatoria",1)
    );

    if (_images != null) {
      for (int x = 0; x < _images.length; x++) {
        StorageReference reference =
        FirebaseStorage.instance.ref().child(titulo + x.toString());

        StorageUploadTask uploadTask = reference.putFile(_images[x]);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        if (x == 0) {
          dow = await reference.getDownloadURL();
        } else {
          dow = dow + "," + await reference.getDownloadURL();
        }
      }
    }
    _AddDataConvocatoria();

    setState(() {
      subio = true;
    });
    _snackBarCargaCompleta();
  }
  bool subios=false;




  Future<void> getImagesd() async {

    await MultiMediaPicker.pickImages(source: ImageSource.gallery).then((images){
      setState(() {

        if(_images!=null){
          for(int g=0;g<images.length;g++){
            _images.add(images[g]);
          }
        }else{
          _images=images;
        }
      });

    });

  }
   Future<void> getImageCamara() async {
     Metodos().getImagen().then((fil){
       setState(() {
        if(fil!=null){
          if(_images!=null){
            _images.add(fil);
          }else{
            _images=new List<File>();
            _images.add(fil);
          }

        }
       });

     });


   }

  final GlobalKey<ScaffoldState> sca = new GlobalKey<ScaffoldState>();
  void errorTitulo() {
    sca.currentState.showSnackBar(
        const SnackBar(content: const Text("Debe Introducir un Titulo")));
  }

  void _snackBarCargaCompleta() {
    sca.currentState
        .showSnackBar( SnackBar(content: const Text("Carga Completa"),action: SnackBarAction(
      textColor: Theme.of(context).brightness==Brightness.light?Colors.white:Colors.black,

      label: "Ver",onPressed: (){
          if(Provider.of<Principal>(context,listen: false).current != (cu?2:1)){
            Provider.of<Principal>(context,listen: false).current=(cu?2:1);

          }
          Navigator.of(context).pop();
          Navigator.of(context).pop();

    },),));
  }
 confirm(File f){
   showDialog(
     context: context,
     builder: (BuildContext context) {
       // return object of type Dialog
       return AlertDialog(
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10.0)),
         title: const Text("¿Desea eliminar la foto?"),

         actions: <Widget>[
            FlatButton(onPressed: (){
             setState(() {
               setState(() {
                 _images.remove(f);


               });
               Navigator.of(context).pop();
             });
           }, child: const Text("Si"), ),
            FlatButton(
             child: const Text("No"),
             onPressed: () {
               Navigator.of(context).pop();
             },
           ),
         ],
       );
     },
   );
 }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      key: sca,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),
        title: Styles().estilo(context,!cu ? "AVISOS":"CONVOCATORIAS"),

        actions: <Widget>[

           Switch(
              value: cu,
              onChanged: (bool as) {
                setState(() {
                  cu = as;
                });
              }),


        ],
      ),
      body:  ListView(
        children: <Widget>[
           Padding(
            padding: const EdgeInsets.all(10.0),

            child:  TextField(
              maxLines: 2,
              decoration: const InputDecoration(
                icon: const Icon(Icons.description),
                labelText: "Título",
                border: const OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 22.0),
              onChanged: (String str) {
                titulo = str;
              },
            ),
          ),

           Padding(
            padding:const EdgeInsets.all(5.0),
            child:  TextField(

              maxLines: 6,
              decoration: const InputDecoration(
                // hintText: "Descripcion",

                labelText: "Descripción",
                border: const OutlineInputBorder(),
              ),

              style: const TextStyle(fontSize: 22.0),
              onChanged: (String sa) {
                des = sa;
              },
            ),
          ),

           Wrap(
             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.only(right: 8.0),
                 child:  RaisedButton(

                   shape: const StadiumBorder(),

                   onPressed: () {

                      getImagesd();

                   },
                   child: _images != null
                       ? Text(_images.length.toString() +
                           " Imágenes Seleccionadas")
                       : const Text("Seleccionar Imágenes..."),
                 ),
               ),

                IconButton(icon:const Icon(Icons.camera), onPressed:(){

                    getImageCamara();



               }),
             ],
           ),

          _images != null
              ?  SingleChildScrollView(
                  child: GridView.count(
                    crossAxisCount: MediaQuery.of(context).size.shortestSide <600 ?3: 6,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    mainAxisSpacing: 2.0,
                    physics: const ClampingScrollPhysics(),
                    children: _images
                        .map((File f) => GestureDetector(
                              child: Image.file(
                                f,
                                fit: BoxFit.cover,
                              ),
                      onLongPress: () {


                        confirm(f);

                      },

                            ))
                        .toList(),
                  ),
                )
              : Container(),




          // new Padding(padding: const EdgeInsets.all(10.0)),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(
            backgroundColor: Theme.of(context).brightness==Brightness.dark? Colors.grey[900]:const Color(0xFF1B396A),
            onPressed: () {
              if (titulo.isNotEmpty) {
                if(!cu){
                  uploadImage();


                }else{
                  uploadImageConvocatoria();

                }
              } else {
                errorTitulo();
              }
            },
            child: const Icon(Icons.cloud_upload,color: Colors.white,),
          ),



    );
  }
}
