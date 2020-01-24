import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itec/providers/controller.dart';
import 'package:provider/provider.dart';
import 'publicos.dart';
import 'metodos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/admi/edit_aviso_convocatoria.dart';

class Inicio{

  Widget LinksAvisosyConvocatoriasDialog(BuildContext context, final b) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text(
        "HIPERVINCULOS",
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(b.elementAt(0).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(0));
              },
              leading: const Icon(Icons.web),
            ),
            ListTile(
              title: Text(b.elementAt(1).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(1));
              },
              leading: const Icon(Icons.web),
            ),
            b.length == 3
                ? ListTile(
              title: Text(b.elementAt(2).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(2));
              },
              leading: const Icon(Icons.web),
            )
                : Container(),
            b.length == 4
                ? ListTile(
              title: Text(b.elementAt(3).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(3));
              },
              leading: const Icon(Icons.web),
            )
                : Container(),
            b.length == 5
                ? ListTile(
              title: Text(b.elementAt(4).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(4));
              },
              leading: const Icon(Icons.web),
            )
                : Container(),
            b.length == 6
                ? ListTile(
              title: Text(b.elementAt(5).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(5));
              },
              leading: const Icon(Icons.web),
            )
                : Container(),
            b.length == 7
                ? ListTile(
              title: Text(b.elementAt(6).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(6));
              },
              leading: const Icon(Icons.web),
            )
                : Container(),
            b.length == 8
                ? ListTile(
              title: Text(b.elementAt(7).toString()),
              onTap: () {
                Publicos().openBrowserTab(b.elementAt(7));
              },
              leading: const Icon(Icons.web),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
  Widget opciones(final i, final re, final context, final fec, final fech,
      final titulo, final pass, final des, final foto) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            i !="oficial"?ListTile(
              title: fec == null
                  ? const Text("Marcar publicación")
                  : const Text("Desmarcar publicación"),
              leading: i == "aviso"
                  ? const Icon(Icons.notification_important)
                  : const Icon(Icons.announcement),
              onTap: () async {
                if (fec == null) {
                  Firestore.instance.runTransaction((transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(re);
                    await transaction.update(re, {
                      "marcar": fech,
                    });
                    await transaction.update(re, {
                      "fecha": DateTime.utc(2026),
                    });
                  });
                } else {
                  Firestore.instance.runTransaction((transaction) async {
                    DocumentSnapshot snapshot = await transaction.get(re);
                    await transaction.update(re, {
                      "marcar": null,
                    });
                    await transaction.update(re, {
                      "fecha": fec,
                    });
                  });
                }

                Navigator.of(context).pop();
                if(fec==null){
                  Provider.of<Controlador>(context).con.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 602),
                  );
                }

              },
            ):const SizedBox(),
           i != "oficial" ?ListTile(
              title: const Text("Editar publicación"),
              leading: i == "aviso"
                  ? const Icon(Icons.notification_important)
                  : const Icon(Icons.announcement),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) =>
                            Principal(i, titulo, des, re, foto)));
              },
            ):const SizedBox(),
            ListTile(
              title: const Text("Eliminar publicación"),
              leading: i == "aviso"
                  ? const Icon(Icons.notification_important)
                  : i=="oficial" ?const Icon(Icons.home): const Icon(Icons.announcement),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        Metodos().eliminarAvisoConvocatoria(
                            context, re, titulo, i, null));
              },
            ),

          ],
        ),
      ),
    );
  }


}