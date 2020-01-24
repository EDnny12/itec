import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:local_auth/local_auth.dart';


class Metodos {
  TextEditingController pruena = TextEditingController();
  TextEditingController nombre = TextEditingController();
  TextEditingController puesto =  TextEditingController();
  TextEditingController correo =  TextEditingController();
  TextEditingController ext =  TextEditingController();
  TextEditingController pass =  TextEditingController();

  String lins(final String des) {
    List<String> a = des.replaceAll("\n", " ").replaceAll(" +", " ").split(" ");
    String links = "";

    for (int g = 0; g < a.length; g++) {
      if (a[g].startsWith("https://") ||
          a[g].startsWith("http://") ||
          a[g].startsWith("www")) {
        if(a[g].startsWith("www") ||a[g].startsWith("bit.ly") ){a[g]="https://"+a[g];}
        if (links.isEmpty) {

          links = a[g];
        } else {
          links = links + "|" + a[g];
        }
      }
    }
    return links;
  }

  Future<Object> authorizeNow() async {

    const strings=AndroidAuthMessages(
      cancelButton: "Cancelar",
      goToSettingsButton: "Configuración",
      goToSettingsDescription: "",
      signInTitle: "ADMINISTRADOR",


    );
    Object isAuthorized = false;
    try {
      isAuthorized = await LocalAuthentication().authenticateWithBiometrics(
        localizedReason: "Auntenticación requerida",
       androidAuthStrings: strings,

        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      isAuthorized="sin";
    }

    return isAuthorized;
  }

  Future<File> getVideo() async {
    return await ImagePicker.pickVideo(source: ImageSource.gallery);
  }

  Future<File> getImagen() async {
    return await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);

  }

  void subir(final String tit, final String des, final String img) {
    Firestore.instance.runTransaction((Transaction transaccion) async {
      CollectionReference referencesx =
          Firestore.instance.collection('oficiales');
      await referencesx.add({
        "fecha": DateTime.now(),
        "foto": img.length >= 4 ? img.split(",") : "",
        "titulo": tit.toUpperCase(),
        "descripcion": des,
      });
    });
  }

  void notificaciones() async {

        FirebaseMessaging().getToken().then((token) {
          if(token!=null){
            doesNameAlreadyExist(token);
          }
        }).catchError((err){});

  }

  Future<void> doesNameAlreadyExist(String name) async {

    await Firestore.instance
        .collection('pushtokens')
        .where('devtoken', isEqualTo: name)
        .limit(1)
        .getDocuments()
        .then((result) {
      if (result.documents.length == 1) {
      } else {
        Firestore.instance.runTransaction((Transaction transaccion) async {
          CollectionReference reference =
              Firestore.instance.collection('pushtokens');

          await reference.add({
            "devtoken": name,
          }).catchError((sa) => {});
        }).catchError((errr){});
      }
    });
  }





  Widget directorio(
      final bool edit,
      final String nombre,
      final String correo,
      final String puesto,
      final String ext,
      final DocumentReference re,
      final context,
      _editarState) {
    if (edit) {
      this.nombre.text = nombre;
      this.correo.text = correo;
      this.puesto.text = puesto;
      this.ext.text = ext;
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: !edit
          ? const Text(
              "NUEVO DIRECTORIO",
              textAlign: TextAlign.center,
            )
          : const Text(
              "EDITAR DIRECTORIO",
              textAlign: TextAlign.center,
            ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(padding: const EdgeInsets.all(5.0)),
            getTextField(
              "Nombre",
              this.nombre,
            ),
            const Padding(padding: const EdgeInsets.all(5.0)),
            getTextField("Puesto", this.puesto),
            const Padding(padding: const EdgeInsets.all(5.0)),
            getTextField("Correo", this.correo),
            const Padding(padding: const EdgeInsets.all(5.0)),
            getTextField("Ext", this.ext),

            GestureDetector(
              onTap: () {
                if (edit) {
                  Firestore.instance.runTransaction((transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(re);
                    await transaction.update(re, {
                      "nombre": this.nombre.text,
                      "puesto": this.puesto.text,
                      "correo": this.correo.text,
                      "ext": this.ext.text
                    });
                  });
                  Navigator.of(context).pop();
                } else {
                  if (this.nombre.text.isEmpty ||
                      this.puesto.text.isEmpty ||
                      this.correo.text.isEmpty ||
                      this.ext.text.isEmpty) {
                    _editarState.camposVacios();
                  } else {
                    Firestore.instance
                        .runTransaction((Transaction transaccion) async {
                      CollectionReference reference =
                          Firestore.instance.collection('directorio');

                      await reference.add({
                        "nombre": this.nombre.text,
                        "puesto": this.puesto.text,
                        "correo": this.correo.text,
                        "ext": this.ext.text,
                        "value": 100
                      });
                    });
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton("ACEPTAR",
                    const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0), context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(
      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn;

    loginBtn = Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: inputBoxController,
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          filled: true,
          hintText: inputBoxName,
        ),
        obscureText: false,
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin, context) {
    var loginBtn = Container(
      margin: margin,
      padding: const EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF28324E)),
        borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: Text(
        buttonLabel,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }



  Widget eliminarUsuarios(
      BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(
        "¿Desea eliminar su cuenta?",
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text("Si"),
          onPressed: () async {
            authorizeNow().then((value)async {
              if (value) {
             await   FirebaseAuth.instance.currentUser().then((user){
                  if(user!=null){
                    if(user.email!=null){
                      user.delete();
                    }
                  }
                });
                await Firestore.instance
                    .collection('usuarios')
                    .where('correo', isEqualTo: Provider.of<Usuarios>(context).email)
                    .getDocuments().then((result){
                  Firestore.instance.runTransaction((transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(result.documents[0].reference);
                    await transaction.delete(snapshot.reference);

                  });
                });

                Provider.of<Usuarios>(context,listen: false).email
                = null;
                Navigator.of(context).pop();
              }
            });
          },
        ),
        FlatButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }


  Widget eliminarAvisoConvocatoria(
      BuildContext context, final re, final titulo, final i, _PermisosState) {
    return AlertDialog(

      title: i == "aviso" || i == "directorio" || i == "usuario" || i =="oficial"
          ? Text("¿Desea eliminar el $i?")
          : Text("¿Desea eliminar la $i?"),
      content: Text(titulo),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (i != "herramienta" &&
                i != "carrera" &&
                i != "directorio" &&
                i != "usuario" &&
                  i!="oficial"

            ) {
              Firestore.instance
                  .collection("lista")
                  .where("titulo", isEqualTo: titulo)
                  .snapshots()
                  .first
                  .then((ds) {
                Firestore.instance.runTransaction((transaction) async {
                  DocumentSnapshot snapshots =
                      await transaction.get(ds.documents[0].reference);
                  await transaction.delete(snapshots.reference);
                });
              });
            }
            if (i != "usuario") {
              Firestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot = await transaction.get(re);
                await transaction.delete(snapshot.reference);
              });
              Navigator.of(context).pop();
            }
          },
          child: const Text("Si"),
        ),
        FlatButton(
          child: const Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }


  Widget animacionCargando(BuildContext context, final d, final i) {
    return AlertDialog(

      shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(15.0)),
      title: i == 1
          ? Text(
              "Subiendo " + d,
              textAlign: TextAlign.center,
            )
          : const Text(
              "Actualizando...",
              textAlign: TextAlign.center,
            ),
      content: SingleChildScrollView(
        child:
            const LinearProgressIndicator(backgroundColor: Colors.white,),

      ),
    );
  }
}
