import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/admi/edit_oferta.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/widgets/detalles_carrera_2.dart';
import 'package:itec/providers/publicos.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/network.dart';

class carreras extends StatelessWidget {
  final carrera;
  final imagen;
  final obje;
  final egre;
  final user;
  final reti;
  final DocumentReference re;


  carreras(this.carrera,this.imagen,this.obje,this.egre,this.user,this.reti,this.re);
  Widget metodo(List<DocumentSnapshot> document, context) {
    if (document[0].data["permisos"][1] == "1")
      return IconButton(tooltip:Provider.of<Network>(context,listen: false).conexion?"Editar Carrera":"No disponible en Modo Offline",icon: const Icon(Icons.edit), onPressed: (){
      if(Provider.of<Network>(context,listen: false).conexion){
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => edit_ofer(carrera, re, obje, egre, reti, user)));
      }

      });
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SlidingUpPanel(
        color: Theme.of(context).brightness == Brightness.dark
            ? ThemeData.dark().canvasColor
            : Theme.of(context).scaffoldBackgroundColor,
        parallaxEnabled: true,
        parallaxOffset: .5,
        maxHeight: 365.0,
        minHeight: 70.0,
        borderRadius: const BorderRadius.only(topLeft: const Radius.circular(15.0), topRight: const Radius.circular(15.0)),
        panel: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 12.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration:BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:const BorderRadius.all(Radius.circular(12.0))
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Conoce más",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 23.0,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36.0,),
            Container(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[


                      const Text("Laboratorios:", style: const TextStyle(fontWeight: FontWeight.w600,)),


                 const SizedBox(height: 12.0,),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 138.0,
                    child: ListView.separated(

                      scrollDirection: Axis.horizontal,itemCount: user!=null ? user.length:0,itemBuilder: (context,int d){
                      return

                             GestureDetector(
                               onTap: (){

                                 Navigator.push(context, CupertinoPageRoute(builder: (context) =>
                                    Detail(user,d)
                                 ));
                               },
                               child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                                    child:
                                        CachedNetworkImage(
                                        height: 120,
                                        imageUrl: user[d].toString(),

                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),

                                      ),

                                  ),
                             );



                    },separatorBuilder: (context,int d){
                      return const SizedBox(width: 13.0,);
                    },),
                  ),


                  const SizedBox(height: 30.0,),
                  SizedBox(

                width: double.infinity,
        child: RaisedButton(onPressed: (){
          if(reti!=""){ Publicos().openBrowserTab(reti);}
        },child: const Text("Reticula"),shape: const StadiumBorder()),
      ),
                ],
              ),
            ),


          ],
        ),
        body: CustomScrollView(

          slivers: <Widget>[

             SliverAppBar(


              expandedHeight:  MediaQuery.of(context).size.shortestSide <600 ?250.0: 360.0,
                  elevation: 0.0,
            actions: <Widget>[
              Provider.of<Usuarios>(context).email!=null ? StreamBuilder(
                stream: Firestore.instance
                    .collection('usuarios')
                    .where('correo', isEqualTo: Provider.of<Usuarios>(context).email)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) return Container();
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container();

                    default:
                      return metodo(snapshot.data.documents, context);
                  }
                },
              )
                  : Container(),








            ],



               backgroundColor: Styles().background(context),
               iconTheme: Styles().colorIcon(context),

              pinned:true,


              floating: false,
              flexibleSpace: FlexibleSpaceBar(


                title:

                Text(carrera,style: TextStyle(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFFFFF):const Color(0xFF000000),
                  fontSize: 17.5,
                ),textAlign: TextAlign.left,) ,
                background:
                  CachedNetworkImage(

                    fit:  BoxFit.cover,

                    imageUrl: imagen,
                    placeholder: (context,url) =>  const CircularProgressIndicator(strokeWidth: 0.0,),


                    errorWidget: (context, url, error) =>  const Icon(Icons.error),
                  ),

                ),

    ),




            SliverList(delegate:  SliverChildListDelegate(<Widget>[
                Container(

                  margin: const EdgeInsets.only(left:15.0,right: 15.0,top: 15.0,bottom: 100.0),
                  child: Column(
                    children: <Widget>[

                       Row(children: <Widget>[
                         Container(
                          height: 10.0,
                          width: 10.0,
                          decoration:  const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.only(left: 15.0,),
                          child: const Text("Objetivo General:",style: const TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0,bottom: 15.0),
                        child: obje!="" ?  Text(obje,textAlign: TextAlign.justify,) : const Divider()
                      ),
                       Row(children: <Widget>[
                         Container(
                          height: 10.0,
                          width: 10.0,
                          decoration:  const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                       const  Padding(
                          padding: const EdgeInsets.only(left: 15.0,),
                          child:  const Text("Perfil de egreso:",style:  const TextStyle(fontWeight: FontWeight.bold),),
                        ),
                      ],),
                   egre!=""?
                     ListView.builder(shrinkWrap: true ,physics: const ClampingScrollPhysics(),itemCount: egre.split("|").length ,itemBuilder: (context,index){
                      return  Padding(padding:  const EdgeInsets.only(top: 10.0),child:
                       Text(egre.split("|")[index],textAlign: TextAlign.justify,));
                    }) : const Divider(),



                    ],
                  ),
              ),


            ]))

          ],

        ),
      ),

    );
  }
}
