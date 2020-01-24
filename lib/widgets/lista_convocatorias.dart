import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:provider/provider.dart';
import 'package:itec/busquedas/detalles_items.dart';
import 'package:itec/providers/publicos.dart';
import 'package:itec/providers/inicion.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'fotos.dart';
import 'package:itec/providers/network.dart';

class PageThree extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("convocatorias")
          .orderBy("fecha", descending: true).limit(55)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return const Text('ERROR AL CARGAR LAS CONVOCATORIAS');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              alignment: Alignment.center,
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
              child: const CircularProgressIndicator(),
            );

          default:
            return lista(snapshot.data.documents,context);
        }
      },
    );
  }
  Widget lista(List<DocumentSnapshot> document,BuildContext context){
    return
      Consumer<Network>(
          builder: (context,va,_)=>
         ListView.separated(

            padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),
            physics: const ClampingScrollPhysics(),
            itemCount:va.conexion || document.length==0? document.length:10  ,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int i) {


              return Card(
                elevation: 1.6,
                shape:  RoundedRectangleBorder(
                    borderRadius:  BorderRadius.circular(12.0)),
                margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: GestureDetector(
                  onLongPress: ()async {

                        if (Provider.of<Usuarios>(context,listen: false).email != null && va.conexion) {
        await Firestore.instance
            .collection('usuarios')
            .where('correo', isEqualTo: Provider.of<Usuarios>(context,listen: false).email)
            .getDocuments().then((result){
          if(result.documents[0].data["permisos"][3]=="1") {
            showDialog(context: context,builder: (BuildContext context )=>Inicio().opciones("convocatoria",document[i].reference, context, document[i].data["marcar"], document[i].data["fecha"],document[i].data["titulo"].toString(),null,document[i].data["descripcion"].toString(),document[i].data["foto"]));

          }
        });


                        }

                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[


                      document[i].data["foto"].length == 0

                          ? const SizedBox()

                          :

                             Foto(i, document[i].data["foto"][0]),


                      const SizedBox(height:  5.0,),
                      ListTile(

                        title:  Text(
                          document[i].data["titulo"].toString(),
                          textScaleFactor: 1.15,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: document[i].data["marcar"]!=null ? const Icon(Icons.bookmark) : null,
                        subtitle: GestureDetector(
                          onTap: () {
                            if (document[i].data["link"].length == 1) {
                               Publicos().openBrowserTab(document[i].data["link"][0].toString());
                            } else if (document[i].data["link"].length > 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Inicio()
                                    .LinksAvisosyConvocatoriasDialog(context, document[i].data["link"]),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.9),
                            child:  Text(
                              document[i].data["descripcion"].toString(),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(document[i].data["marcar"] == null ?DateTime.fromMillisecondsSinceEpoch(document[i].data["fecha"].millisecondsSinceEpoch).day.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(document[i].data["fecha"].millisecondsSinceEpoch).month.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(document[i].data["fecha"].millisecondsSinceEpoch).year.toString():DateTime.fromMillisecondsSinceEpoch(document[i].data["marcar"].millisecondsSinceEpoch).day.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(document[i].data["marcar"].millisecondsSinceEpoch).month.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(document[i].data["marcar"].millisecondsSinceEpoch).year.toString(),style: const  TextStyle(fontSize: 13.0,color: Colors.grey),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            document[i].data["foto"].length !=1 && document[i].data["foto"].length !=0 ?
                            IconButton(
                              iconSize: 20.0,
                              icon: const Icon(Icons.photo_library),
                              tooltip: "Ver todas las fotos",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            Hols(document[i].data["foto"],document[i].data["titulo"].toString(), document[i].data["descripcion"].toString(), document[i].data["link"],i<10 ? true:false)));
                              },

                            ):const SizedBox(),
                            document[i].data["link"] != ""?  IconButton(

                              padding:const  EdgeInsets.all(0.0),
                              iconSize: 20.0,
                              tooltip: "Visitar enlace",
                              icon: const Icon(Icons.web),
                              onPressed: () {
                                if (document[i].data["link"].length == 1) {
                                  Publicos().openBrowserTab(
                                      document[i].data["link"][0].toString());
                                } else if (document[i].data["link"].length > 1) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Inicio()
                                        .LinksAvisosyConvocatoriasDialog(
                                        context, document[i].data["link"]),
                                  );
                                }

                              },
                            ):const SizedBox(),

                            IconButton(
                              iconSize: 20.0,
                              tooltip: "Compartir",
                              icon: const Icon(Icons.share),padding: const EdgeInsets.all(0.0),onPressed: (){
                              WcFlutterShare.share(
                                  sharePopupTitle: 'Compartir convocatoria',
                                  subject: "Convocatoria",
                                  text: "¡Que no se te pase esta convocatoria!"+"\n"+document[i].data["titulo"].toString()+"\n Consultala ya 👉 https://itcomitan.page.link/informatec",
                                  mimeType: 'text/plain');
                            },)
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              );
            },separatorBuilder: (context,int a){
          return  const SizedBox(
            height: 15.0,
          );
        },),
      );
  }
}
