import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/providers/estilos.dart';
import 'detalles_carreras.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:itec/providers/metodos.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/network.dart';
class oferta extends StatelessWidget {

  var ab = TextEditingController();
  var a = TextEditingController();
  String modal="Escolarizado";

  void dialog(String imagen, String carreca, File imag, DocumentReference re,
      context, String moda) {
    if (carreca != null) {
      a.text = carreca;
    }
    if (moda != null) {
     modal = moda;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                            dialog(imagen, null, file, re, context, null);
                          }).catchError((error) {});
                        },
                        child: imag == null
                            ? CachedNetworkImage(
                                imageUrl: imagen,
                                placeholder: (context, url) => const Padding(
                                      padding: const EdgeInsets.all(50.0),
                                      child: const CircularProgressIndicator(),
                                    ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.file(imag)),
                  ),
                  TextFormField(
                      controller: a,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: const UnderlineInputBorder(),
                        filled: true,
                      )),

                  ExpansionPanelList.radio(

                  children: <ExpansionPanelRadio>[
                        ExpansionPanelRadio(value: 0, headerBuilder:(BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Text(modal),
                          );
                        }, body: Column(
                          children: <Widget>[
                            ListTile(title: const Text("Modalidad Escolarizado"),
                            subtitle: const Text("Clases de manera presencial"),
                              leading: const Icon(Icons.school),
                              onTap: (){
                              modal="Escolarizado";
                              moda="Escolarizado";
                              Navigator.of(context).pop();
                              dialog(imagen, carreca, imag, re, context, moda);
                              },
                            ),
                            ListTile(title: const Text("Modalidad Mixto"),
                              subtitle: const Text("Clases de manera en línea"),
                              leading: const Icon(Icons.web_asset),
                              onTap: (){
                                modal="Modalidad Mixto";
                                moda="Modalidad Mixto";
                                Navigator.of(context).pop();
                                dialog(imagen, carreca, imag, re, context, moda);
                              },
                            ),
                            ListTile(title: const Text("Ambas Modalidades"),
                              subtitle: const Text("Clases de manera presencial y en línea"),
                              leading: const Icon(Icons.looks_two),
                              onTap: (){
                                modal="Escolarizado y Mixto";
                                moda="Escolarizado y Mixto";
                                Navigator.of(context).pop();
                                dialog(imagen, carreca, imag, re, context, moda);
                              },
                            ),
                          ],
                        )),

                  ],
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  child: const Text("Guardar"),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            Metodos().animacionCargando(context, "", 0));
                    if (imag == null) {
                      Firestore.instance.runTransaction((transaction) async {
                     final  DocumentSnapshot snapshot = await transaction.get(re);
                        await transaction.update(re,
                            {"carrera": a.text, "modalidad": modal});
                      });
                    } else {
                      final StorageReference reference =
                          FirebaseStorage.instance.ref().child(a.text);

                     final StorageUploadTask uploadTask = reference.putFile(imag);
                      final StorageTaskSnapshot taskSnapshot =
                          await uploadTask.onComplete;

                      final as = await reference.getDownloadURL();
                      Firestore.instance.runTransaction((transaction) async {
                        DocumentSnapshot snapshot = await transaction.get(re);
                        await transaction.update(re, {
                          "carrera": a.text,
                          "imagen": as,
                          "modalidad": modal,
                        });
                      });
                    }
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
              FlatButton(
                child: const Text("Eliminar"),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Metodos()
                          .eliminarAvisoConvocatoria(
                              context, re, a.text, "carrera",null));
                },
              ),

              FlatButton(
                child: const Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
              TextFormField(
                  controller: ab,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: "Titulo",
                    border: const UnderlineInputBorder(),
                    filled: true,
                  )),

              ExpansionPanelList.radio(

                children: <ExpansionPanelRadio>[
                  ExpansionPanelRadio(value: 0, headerBuilder:(BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(modal),
                    );
                  }, body: Column(
                    children: <Widget>[
                      ListTile(title: const Text("Modalidad Escolarizado"),
                        subtitle: const Text("Clases de manera presencial"),
                        leading: const Icon(Icons.school),
                        onTap: (){
                          modal="Escolarizado";
                          Navigator.of(context).pop();
                         Nueva(as, context);
                        },
                      ),
                      ListTile(title: const Text("Modalidad Mixto"),
                        subtitle: const Text("Clases de manera en línea"),
                        leading: const Icon(Icons.web_asset),
                        onTap: (){
                          modal="Modalidad Mixto";
                          Navigator.of(context).pop();
                          Nueva(as, context);

                        },
                      ),
                      ListTile(title: const Text("Ambas Modalidades"),
                        subtitle: const Text("Clases de manera presencial y en línea"),
                        leading: const Icon(Icons.looks_two),
                        onTap: (){
                          modal="Escolarizado y Mixto";
                          Navigator.of(context).pop();
                          Nueva(as, context);

                        },
                      ),
                    ],
                  )),

                ],
              )
            ],
          )),
          actions: <Widget>[
            FlatButton(
                onPressed: () async {
                  if (as != null && ab.text != "") {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            Metodos().animacionCargando(context, "Carrera", 1));
                    StorageReference reference =
                        FirebaseStorage.instance.ref().child(ab.text);

                    StorageUploadTask uploadTask = reference.putFile(as);
                    StorageTaskSnapshot taskSnapshot =
                        await uploadTask.onComplete;

                    String ds = await reference.getDownloadURL();
                    Firestore.instance
                        .runTransaction((Transaction transaccion) async {
                      CollectionReference reference =
                          Firestore.instance.collection('oferta');

                      await reference.add({
                        "imagen": ds,
                        "carrera": ab.text,
                        "egreso": "",
                        "objetivo": "",
                        "modalidad": modal,
                        "opciones":[],
                        "laboratorio":""
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

  Widget metodo(List<DocumentSnapshot> document, context) {
    if (document[0].data["permisos"][1] == "1")
      return Consumer<Network>(
          builder: (context,va,_)=>
         IconButton(
          tooltip: va.conexion?"Agregar Carrera":"No disponible en Modo Offline",
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              if(va.conexion){
                Nueva(null, context);
              }

            }),
      );
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
        title: Styles().estilo(context,"OFERTA EDUCATIVA"),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),
        actions: <Widget>[

          Provider.of<Usuarios>(context).email!=null
              ? StreamBuilder(
                  stream: Firestore.instance
                      .collection('usuarios')
                      .where('correo', isEqualTo: Provider.of<Usuarios>(context).email)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) return Container();
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox();

                      default:
                        return metodo(snapshot.data.documents, context);
                    }
                  },
                )
              : Container(),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: Firestore.instance.collection("oferta").snapshots(),

            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              return lista(snapshot.data.documents, context);
            }),
      ),
    );
  }

  Widget lista(List<DocumentSnapshot> document, BuildContext contexta) {
    return ListView.separated(
          cacheExtent: 100.0,
        padding: const EdgeInsets.only(top: 10.0,bottom:10.0),
        itemCount: document.length,
        itemBuilder: (BuildContext context, int index) {
          return
            Card(
              elevation: 1.6,
              shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(12.0)),
              margin: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: GestureDetector(
                onTap: () {

                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => carreras(
                              document[index].data["carrera"].toString(),
                              document[index].data["imagen"].toString(),
                              document[index].data["objetivo"].toString(),
                              document[index].data["egreso"].toString(),

                              document[index].data["opciones"],
                              document[index].data["reticula"],
                            document[index].reference,


                          )));
                },
                onLongPress: () async {

                  if (Provider.of<Usuarios>(context,listen: false).email!=null &&Provider.of<Network>(context,listen: false).conexion ) {
                    await Firestore.instance
                        .collection('usuarios')
                        .where('correo', isEqualTo: Provider.of<Usuarios>(context,listen: false).email)
                        .getDocuments()
                        .then((result) {
                      if (result.documents[0].data["permisos"][1] == "1") {
                        dialog(
                            document[index].data["imagen"].toString(),
                            document[index].data["carrera"].toString(),
                            null,
                            document[index].reference,
                            contexta,
                            document[index].data["modalidad"].toString());
                      }
                    });

                  }
                },
                child: Column(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: const Radius.circular(12.0),
                          topLeft: const Radius.circular(12.0)),
                      child: FadeInImage(placeholder: const AssetImage("assets/cargando.png"),
                          fit: BoxFit.cover,
                         fadeInDuration: const Duration(milliseconds: 100),
                          image: CachedNetworkImageProvider(document[index].data["imagen"].toString())),

                    ),
                    ListTile(
                      title: Text(
                        document[index].data["carrera"].toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        document[index].data["modalidad"].toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 11.0),
                      ),
                    )
                  ],
                ),
              ),
            );
        },separatorBuilder: (context,int a){
      return  const SizedBox(
        height: 12.0,
      );
    },);
  }
}
