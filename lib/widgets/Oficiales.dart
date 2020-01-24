import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/busquedas/detalles_items.dart';
import 'package:itec/providers/inicion.dart';
import 'package:itec/providers/network.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/publicos.dart';
import 'fotos.dart';

class PageOne extends StatelessWidget {


  @override
  Widget build(context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("oficiales")
          .orderBy("fecha", descending: true).limit(55)
          .snapshots(),

      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return const Text('ERROR AL CARGAR LAS NOTICIAS');
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return Container(
           alignment:  Alignment.center,
           padding :EdgeInsets.only(top: MediaQuery.of(context).size.height/2-50),
           child: const CircularProgressIndicator(),
          );

          default: return lista(snapshot.data.documents,context);
        }
      },
    );
  }
  Widget lista(List<DocumentSnapshot> document,BuildContext contexta){

    return Consumer<Network>(
      builder: (contexta,va,_)=>
       ListView.separated(

          padding: const EdgeInsets.only(top: 10.0,bottom:10.0),
        physics:const ClampingScrollPhysics(),
        itemCount: va.conexion || document.length==0? document.length: 10 ,
        shrinkWrap: true,
        itemBuilder: (contexta, int d) {
            final String fotos=document[d].data["foto"][0].toString();
          return  Card(

              elevation: 1.6,
              shape:  RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(12.0)),
              margin: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: GestureDetector(
                onLongPress: () async {
                  if (Provider.of<Usuarios>(contexta,listen: false).email != null && va.conexion) {

                    await Firestore.instance
                        .collection('usuarios')
                        .where('correo',
                        isEqualTo: Provider.of<Usuarios>(contexta,listen: false).email)
                        .getDocuments()
                        .then((result) {
                      if (result.documents[0].data["permisos"][3] == "1") {
                        showDialog(
                            context: contexta,
                            builder: (BuildContext context) => Inicio().opciones(
                                "oficial",
                                document[d].reference,
                                context,
                              null,
                               null,
                                document[d].data["titulo"].toString(),
                                null,
                                null,
                               null));

                      }
                    });
                  }
                },
                child: Column(
                  children: <Widget>[
                    GestureDetector(

                      child: Foto(d, fotos),
                      onTap: () {
                        if(document[d].data["url"]==null){
                          Navigator.push(
                              contexta,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      Hols(document[d].data["foto"],document[d].data["titulo"].toString(), document[d].data["descripcion"].toString(),null,d<10 ? true:false)));
                        }else{

                          Publicos().openBrowserTab(document[d].data["url"].toString());
                        }

                      },
                    ),

                    const SizedBox(height:  10.0,),
                     ListTile(
                      title:  Text(
                        document[d].data["titulo"].toString(),
                        textScaleFactor: 1.13,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                       subtitle: Text(DateTime.fromMillisecondsSinceEpoch(document[d].data["fecha"].millisecondsSinceEpoch).day.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(document[d].data["fecha"].millisecondsSinceEpoch).month.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(document[d].data["fecha"].millisecondsSinceEpoch).year.toString()
                           +" "+DateTime.fromMillisecondsSinceEpoch(document[d].data["fecha"].millisecondsSinceEpoch).hour.toString()+":"+DateTime.fromMillisecondsSinceEpoch(document[d].data["fecha"].millisecondsSinceEpoch).minute.toString()
                         ,textAlign: TextAlign.right,)
                    ),


                  ],
                ),
              ),
            );

        },separatorBuilder: (contexta,int i){
         return const SizedBox(height: 15.0,);
       },),
    );
  }
}

