import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:itec/providers/estilos.dart';
import 'package:itec/providers/metodos.dart';
class Noticias extends StatefulWidget {
  @override
  _NoticiasState createState() => _NoticiasState();
}

class _NoticiasState extends State<Noticias> {
  final GlobalKey<ScaffoldState> llave =  GlobalKey<ScaffoldState>();
String titulo;
 void asd(String url) async{
   final response = await http.read(url).catchError((err){
     titulo=null;
     setState(() {

     });
   });
   titulo=response.substring(response.indexOf("<title>")+7,response.indexOf("</title>"));
   titulo=titulo.replaceAll("&quot;",'"');
setState(() {

});
 }
  String url;
 String imgUrl;
 File _image;

 Future getImage() async {
 await ImagePicker.pickImage(source: ImageSource.gallery,imageQuality: 80).then((image){
     setState(() {
       _image = image;
     });
   });


 }
 void addData(String to,final int o){
   if(url!=null && to!=null && url!="" && to!="") {
     Firestore.instance.runTransaction((Transaction transaccion) async {
       CollectionReference reference = Firestore.instance.collection(
           'oficiales');
       await reference.add({
         "titulo": titulo,
         "foto": [to],
         "url": url,
         "fecha": DateTime.now()
       });
       if(o==1){
         Navigator.of(context).pop();
       }
       subido();

     });
   }else{
      mesj();
   }

 }
 void mesj(){
   llave.currentState.showSnackBar(const SnackBar(content: const Text("No deje campos vacios")));
 }
 void subido(){
   llave.currentState.showSnackBar(const SnackBar(content: const Text("Noticia subida con exito")));
 }
 void subir() async{
   if(_image!=null){
     if(url!=null && url!=""){
       showDialog(context: context,builder: (context)=>Metodos().animacionCargando(context, "noticia", 1));
       final StorageReference reference =
       FirebaseStorage.instance.ref().child(_image.path);

       final StorageUploadTask uploadTask = reference.putFile(_image);
       final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
       final String sa= await reference.getDownloadURL();
       addData(sa,1);

     }else{
       mesj();
     }


   }else{
     addData(imgUrl,0);
   }
 }
 void eliminar(){
   showDialog(context: context,builder: (context){
     return AlertDialog(
       title: const Text("¿Desea eliminar esta foto?"),
       actions: <Widget>[
         FlatButton(
           child: const Text("Si"),
           onPressed: (){
             _image=null;
             Navigator.of(context).pop();
             setState(() {

             });
           },
         ),
         FlatButton(child: const Text("No"),
         onPressed: ()=>Navigator.of(context).pop(),
         ),

       ],
     );
   });
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: llave,
      appBar: AppBar(
        elevation: 0.0,
        title: Styles().estilo(context,"ALTA DE NOTICIAS"),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),
      ),
      body:
       SingleChildScrollView(
         child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:   TextField(
                    decoration: const InputDecoration(
                      icon:const Icon(Icons.description),
                      labelText: "Noticia Url",
                    ),
                    style: const TextStyle(fontSize: 22.0),
                    onChanged: (String str) {
                      url=str;
                      asd(str);
                    },
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:  TextField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      labelText: "Imagen Url",
                    ),
                    style: const TextStyle(fontSize: 22.0),
                    onChanged: (String str) {
                      imgUrl = str;
                      setState(() {

                      });
                    },
                  ),
                ),
                 Padding(
                  padding:const EdgeInsets.all(10.0),

                  child:  RaisedButton(shape: const StadiumBorder(),onPressed: (){

                      getImage();



                  },child: const Text("Seleccionar Imagen..."),),
                ),

                 const SizedBox(height: 20.0,),
                titulo!= null?Text(titulo,textAlign: TextAlign.justify,):const SizedBox(),
               _image==null && imgUrl!=null?  FadeInImage.assetNetwork(image: imgUrl,placeholder: "assets/cargando.png",) :const SizedBox(),

           GestureDetector(
           onLongPress: (){
            eliminar();
           }
           ,child: _image!=null && imgUrl==null? Image.file(_image):const SizedBox()),

                GestureDetector(
                    onLongPress: (){
                      eliminar();
                    },
                    child: _image!=null && imgUrl!=null ? Image.file(_image):const SizedBox()),

              ],
            ),

      ),
       )
      ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness==Brightness.dark? Colors.grey[900]:Color(0xFF1B396A),
        onPressed: (){
              subir();
      },child: const Icon(Icons.cloud_upload,color: Colors.white,),),

    );
  }
}
