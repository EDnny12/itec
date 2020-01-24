import 'package:flutter/material.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/providers/metodos.dart';
import 'dart:io';
import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
class Noti extends StatefulWidget {
  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {

  TextEditingController titulo=new TextEditingController();
  TextEditingController des=new TextEditingController();

  List<File> _images;
  String dow="";
  final GlobalKey<ScaffoldState> scaffoldKeyss =  GlobalKey<ScaffoldState>();
  void subir(){
    if(titulo.text=="" || des.text=="" || _images==null){
      scaffoldKeyss.currentState.showSnackBar(const SnackBar(
        content: const Text("Campos vacios, por favor verifique"),
      ));
    }else{
       uploadImage();

    }
  }


  @override
  void dispose() {
    titulo.dispose();
    des.dispose();
    super.dispose();
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
  Future<void> uploadImage() async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            Metodos().animacionCargando(context, "Noticia",1)
    );

    if (_images != null) {
      for (int x = 0; x < _images.length; x++) {
        StorageReference reference =
        FirebaseStorage.instance.ref().child(titulo.text + x.toString());

        StorageUploadTask uploadTask = reference.putFile(_images[x]);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        if (x == 0) {
          dow = await reference.getDownloadURL();
        } else {
          dow = dow + "," + await reference.getDownloadURL();
        }
      }
    }

    Metodos().subir(titulo.text, des.text, dow);
     Navigator.of(context).pop();
    _snackBarCargaCompleta();
  }

  void _snackBarCargaCompleta() {
    scaffoldKeyss.currentState
        .showSnackBar(const  SnackBar(content: const Text("Carga Completa")));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     key: scaffoldKeyss,

      appBar: AppBar(
        elevation: 0.0,
        title: Styles().estilo(context,"ALTA DE NOTICIAS"),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),

      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(10.0),child: Column(
  
        children: <Widget>[
          TextFormField(
            maxLines: 2,
            controller: titulo,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Título de la noticia",
            ),
          ),

          const SizedBox(height: 20.0,),
          TextFormField(
            maxLines: 18,
            controller: des,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: "Descripción de la noticia",
            ),
          ),
          const Padding(padding: const EdgeInsets.only(top: 20.0)),
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

        ],
      ),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness==Brightness.dark? Colors.grey[900]:Color(0xFF1B396A),
        onPressed: (){subir();},child: const Icon(Icons.cloud_upload,color: Colors.white,),),



    );
  }
}
