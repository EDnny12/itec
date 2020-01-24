import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/providers/metodos.dart';
import 'dart:math';
class edit_ofer extends StatefulWidget {
   final String carrera;
   final DocumentReference re;
   final String obje;
   final String egre;
   final String reti;
   final labo;

   edit_ofer(this.carrera,this.re,this.obje,this.egre,this.reti,this.labo);
  @override
  _edit_oferState createState() => _edit_oferState();
}

class _edit_oferState extends State<edit_ofer> {

  TextEditingController objetivo=new TextEditingController();
  TextEditingController egreso=new TextEditingController();
  TextEditingController reticula=new TextEditingController();
  TextEditingController  labos=new TextEditingController();
  int value(){
    return Random().nextInt(1000);
  }
  void dialog(final String imagen,final DocumentReference re,final String titu,File imag,List titufi, final q){

    showDialog(
        context: context,
        builder: (BuildContext context)
    {
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
            child: Column(
                children: <Widget>[

                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                    child: GestureDetector(
                        onTap: () async {
                          await ImagePicker.pickImage(
                              source: ImageSource.gallery,imageQuality: 80)
                              .then((file) {
                            Navigator.of(context).pop();
                            dialog(imagen, re, titu,file,titufi,q);
                          }).catchError((error) {});
                        },
                        child: imag == null
                            ? FadeInImage.assetNetwork(placeholder: "assets/cargando.png", image: imagen)
                            : Image.file(imag)),
                  ),
                  /*TextFormField(
                      controller: titus,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        filled: true,
                      ))
                      */
                ]

            ),

          ),actions: <Widget>[
            FlatButton(onPressed: ()async{
              showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      Metodos().animacionCargando(context, "", 0));
              if (imag == null) {
               /* titufi[1]=titufi[1].replaceAll(titu,titus.text);
                Firestore.instance.runTransaction((transaction) async {
                  final  DocumentSnapshot snapshot = await transaction.get(re);
                  await transaction.update(re,
                      {"opciones": titufi});
                });
                */
              } else {

            var a=new List();
            for(int x=0;x<titufi.length;x++){
              a.add(titufi[x]);
            }

                final StorageReference reference =
                FirebaseStorage.instance.ref().child("comidas"+value().toString());

                final StorageUploadTask uploadTask = reference.putFile(imag);
                final StorageTaskSnapshot taskSnapshot =
                    await uploadTask.onComplete;

                final as = await reference.getDownloadURL();
                a.removeAt(q);
                a.add(as);
                Firestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot snapshot = await transaction.get(re);
                  await transaction.update(re, {
                  "opciones":a
                  });

                });
              }
              Navigator.of(context).pop();
              Navigator.of(context).pop();

            }, child: const Text("Guardar")),
        FlatButton(onPressed: (){
          var a=new List();
          for(int x=0;x<titufi.length;x++){
              a.add(titufi[x]);
          }
             a.removeAt(q);
          Firestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot = await transaction.get(re);
            await transaction.update(re, {
              "opciones":a
            });

          });
          Navigator.of(context).pop();
        }, child: const Text("Eliminar")),
        FlatButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: const Text("Cancelar")),

      ],
      );
    });

  }



  @override
  void initState() {
    objetivo.text=widget.obje;
    egreso.text=widget.egre.replaceAll(".|", ".");
    reticula.text=widget.reti;
    labos.text="";
    super.initState();
  }
  @override
  void dispose() {
    objetivo.dispose();
    egreso.dispose();
    reticula.dispose();
    labos.dispose();
    super.dispose();
  }
  void Nueva(File as, context) {
    showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: Radius.circular(15.0)),
                    child: as == null
                        ?  RaisedButton(
                      shape: const StadiumBorder(),
                      onPressed: () async {
                        await ImagePicker.pickImage(
                            source: ImageSource.gallery,imageQuality: 80)
                            .then((fd) {
                          Navigator.of(context).pop();
                          Nueva(fd, context);
                        });
                      },
                      child: const Text("Seleccionar imagen..."),
                    )
                        : GestureDetector(
                      child: Image.file(as),
                      onTap: () async {
                        await ImagePicker.pickImage(
                            source: ImageSource.gallery)
                            .then((fd) {
                          Navigator.of(context).pop();
                          Nueva(fd, context);
                        });
                      },
                    ),
                  ),

                ],
              )),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  if (as != null ) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            Metodos().animacionCargando(context, "Laboratorio", 1));

                    StorageReference reference =
                    FirebaseStorage.instance.ref().child("labo"+value().toString());

                    StorageUploadTask uploadTask = reference.putFile(as);
                    StorageTaskSnapshot taskSnapshot =
                    await uploadTask.onComplete;

                    String ds = await reference.getDownloadURL();

                    var a=new List();
                  await  Firestore.instance
                        .collection("oferta")
                        .where("carrera",isEqualTo: widget.carrera)
                        .getDocuments().then((result){


                       for(int x=0;x<  result.documents[0].data["opciones"].length;x++){
                         a.add(  result.documents[0].data["opciones"][x]);
                       }
                       a.add(ds);
                       Firestore.instance.runTransaction((transaction) async {
                         DocumentSnapshot snapshot = await transaction.get(result.documents[0].reference);
                         await transaction.update(result.documents[0].reference, {
                           "opciones":a
                         });
                       });

                    });


                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Añadir")),
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar")),
          ],
        );
      },
    );
  }

  void agregar(){
      Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot =
        await transaction.get(widget.re);
        await transaction.update(widget.re, {
          "egreso": egreso.text.replaceAll("\n", "").replaceAll(".", ".|"),
          "objetivo": objetivo.text,
          "reticula":reticula.text,
          "laboratorio":labos.text
        });
      });
    scaffoldKeyss.currentState.showSnackBar(const SnackBar(
      content: const Text("Datos correctamente actualizados"),
    ));
  }
  final GlobalKey<ScaffoldState> scaffoldKeyss =  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKeyss,
      appBar: AppBar(
        elevation: 0.0,
        title: Styles().estilo(context,widget.carrera),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            tooltip: "Nuevo Laboratorio",
            onPressed: (){
Nueva(null, context);
            },
          ),
        ],

      ),
      body: SafeArea(child: SingleChildScrollView(child: Padding(padding: const EdgeInsets.all(8.0),child:
        Column(children: <Widget>[
          TextFormField(
            controller: objetivo,
            maxLines: 6,
            decoration: const InputDecoration(

              border: const UnderlineInputBorder(),
              hintText:"Objetivo",
            ),

          ),
          TextFormField(
            controller: egreso,
            maxLines: 22,
            decoration:const InputDecoration(
              border: const UnderlineInputBorder(),

              hintText:"Egreso",
            ),
          ),
         /* TextFormField(
            controller: labos,
            maxLines: 4,
            decoration: const InputDecoration(

              border: const UnderlineInputBorder(),
              hintText:"Laboratorios",
            ),

          ),

          */
          TextFormField(
            controller: reticula,
            maxLines: 2,
            decoration: const InputDecoration(

              border: const UnderlineInputBorder(),
              hintText:"Reticula",
            ),

          ),
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("oferta")
              .where("carrera",isEqualTo: widget.carrera)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return const Text('ERROR AL CARGAR LOS LABORATORIOS');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container(
                  alignment: Alignment.center,
                  padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 2-50),
                  child: const CircularProgressIndicator(),
                );

              default:
                return lista(snapshot.data.documents,context);
            }
          },
        ),

        ],)
        ,),)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness==Brightness.dark? Colors.grey[900]:Color(0xFF1B396A),

        onPressed: (){
              agregar();



      },child: const Icon(Icons.cloud_upload,color: Colors.white,),),
    );
  }
  Widget lista(final List<DocumentSnapshot> document,final BuildContext contexta){
    return ListView.builder(shrinkWrap: true,physics:ClampingScrollPhysics(),itemCount:  document[0].data["opciones"]!= null  ? document[0].data["opciones"].length:0,itemBuilder: (contexta,int d){


         return GestureDetector(
           onLongPress: (){
              dialog(document[0].data["opciones"][d], document[0].reference, document[0].data["opciones"][d], null, document[0].data["opciones"],d);
           },
           child: Column(
              children: <Widget>[
                FadeInImage.assetNetwork(
                  image: document[0].data["opciones"][d].toString(),
                  placeholder: "assets/cargando.png",

                ),




              ],

      ),
         );

    });
  }
}
