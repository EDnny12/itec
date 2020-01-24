import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:itec/providers/publicos.dart';
import 'package:itec/providers/inicion.dart';
import 'package:itec/widgets/zoom.dart';
class Hols extends StatelessWidget {
  Hols(this.a,this.title,this.descripcion,this.link,this.cache);
  final a;
  final title;
  final descripcion;
  final link;
  final cache;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 2.0,

      child:  ListView.builder(itemCount: a.length,itemBuilder: (BuildContext context,int v){


       return Column(
         children: <Widget>[
           v==0 ?  ListTile(title: Padding(
         padding: const EdgeInsets.only(top:20.0),
         child:  Text(title,textAlign: TextAlign.justify,style: const TextStyle(fontWeight: FontWeight.w600),),
       ),subtitle:
           GestureDetector(
             onTap: (){
               if(link!=null){
                 if(link.length==1){
                   Publicos().openBrowserTab(link[0].toString());
                 }else if(link.length>1){
                   showDialog(
                     context: context,
                     builder: (BuildContext context) =>
                         Inicio().LinksAvisosyConvocatoriasDialog(context, link),
                   );
                 }
               }
             },
             child: Padding(
         padding: const EdgeInsets.only(top: 13.0,bottom: 10.0),
         child:  Text(descripcion,textAlign: TextAlign.justify,),
       ),
           ),):const SizedBox(height: 0.0,),


           PinchZoomImage(
             zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
             hideStatusBarWhileZooming: true,
             image: cache ? CachedNetworkImage(

               imageUrl: a[v],
               placeholder: (context,url) => const Padding(padding: const EdgeInsets.all(50.0),child: const CircularProgressIndicator(),),

               errorWidget: (context, url, error) => const Icon(Icons.error),
             ) :FadeInImage(
                 placeholder:
                 const AssetImage("assets/cargando.png"),
                 image: NetworkImage(a[v])),
           ),
           const SizedBox(height: 5.0,),


         ],

       );

      },),
    );

  }
}
class Holst extends StatelessWidget {
  Holst(this.a,this.title,this.descripcion,this.link);
  final a;
  final title;
  final descripcion;
  final link;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(itemCount: a=="" ? 1 : a.length,itemBuilder: (BuildContext context,int v){


      return  Column(
        children: <Widget>[
          v==0 ? ListTile(title: Padding(
            padding: const EdgeInsets.only(top:20.0),
            child:  Text(title,textAlign: TextAlign.justify,style: const TextStyle(fontWeight: FontWeight.w600),),
          ),subtitle:GestureDetector(
            onTap: (){
              if(link.length==1){
                 Publicos().openBrowserTab(link[0].toString());
              }else if(link.length>1){
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      Inicio().LinksAvisosyConvocatoriasDialog(context, link),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 13.0,bottom: 10.0),
              child:  Text(descripcion,textAlign: TextAlign.justify,),
            ),
          ),):const SizedBox(height: 0.0,),

          a!="" ?PinchZoomImage(
            zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
            hideStatusBarWhileZooming: true,
            image: CachedNetworkImage(

              imageUrl: a[v],
              placeholder: (context,url) => const Padding(padding:const EdgeInsets.all(50.0),child:const CircularProgressIndicator(),),

              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ):const SizedBox(height: 0.0),

        ],
      );
    },);

  }
}
