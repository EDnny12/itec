import 'package:flutter/cupertino.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/providers/metodos.dart';
import 'package:flutter/material.dart';
import 'package:itec/admi/alta_noticias_version2.dart';
import 'package:itec/admi/alta_noticias.dart';
import 'package:itec/admi/avisos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/admi/administracion_permisos.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/network.dart';
class Pane extends StatelessWidget {

  final _inicioState;

  Pane(this._inicioState);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:Styles().estilo(context,"PANEL"),

    backgroundColor: Styles().background(context),
    iconTheme: Styles().colorIcon(context),
        elevation: 0.0,
        actions: <Widget>[

          Consumer<Network>(
            builder: (context,va,_)=>
             Padding(
              padding: const EdgeInsets.all(7.3),
              child: !va.conexion? RaisedButton(shape: const StadiumBorder(),child: const Text("Modo Offline"),onPressed: (){
                showDialog(barrierDismissible: true,context: context,builder: (context){
                  return AlertDialog(

                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15.0)),
                    title: const ListTile(leading:const Icon(Icons.help,size: 60.0,),title: const Text("MODO OFFLINE",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 21.5),)),
                    content: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            const Text("Las opciones de administrador no están disponibles sin conexión a internet",textAlign: TextAlign.justify,),

                          ],
                        )
                    ),
                  );
                });
              },):const SizedBox(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(stream: Firestore.instance
            .collection('usuarios')
            .where('correo', isEqualTo: Provider.of<Usuarios>(context).email).snapshots(), builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if (snapshot.hasError) return const Text('ERROR AL CARGAR LOS PERMISOS');
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
        })

      ),
    );
  }

  Widget lista(List<DocumentSnapshot> document,BuildContext context){
    final per = document[0].data["permisos"];
     return Consumer<Network>(
       builder: (context,va,_)=>
        SingleChildScrollView(child:
         Column(children: <Widget>[
           const SizedBox(height: 10.0,),

            Wrap(direction: Axis.horizontal,
              spacing: 20.0,
              runSpacing: 20.0,
              alignment: WrapAlignment.spaceBetween,
              children: <Widget>[
                per[6]=="1" ?  SizedBox(width: MediaQuery.of(context).size.width/2-60,height: 300.0,child: RaisedButton(onPressed: ()async{
                  if(va.conexion){
                    Metodos().authorizeNow().then((value){
                      if(value==true){
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => Permisos(_inicioState)));

                      }else if(value=="sin"){
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => Permisos(_inicioState)));
                      }
                    });
                  }


                },child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  const Icon(Icons.person,size: 120.0,color: Colors.grey,),
                    const ListTile(title: const  Text("USUARIOS",textAlign: TextAlign.center,),subtitle: const Text("Administración de usuarios y permisos",textAlign: TextAlign.center,style: const TextStyle(fontSize: 13.0),),),
                  ],
                ),shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0))),elevation: 4.0)):const SizedBox(width: 0.0,height: 0.0,),
                per[3]=="1" ?

                SizedBox(width: MediaQuery.of(context).size.width/2-60,height: 300.0,child: RaisedButton(onPressed: (){

                  if(va.conexion){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Homa()));
                  }

                },child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                      const Icon(Icons.notification_important,size: 120.0,color: Colors.grey,),


                   const ListTile(title:const  Text("AVISOS Y CONVOCATORIAS",textAlign: TextAlign.center,style: TextStyle(fontSize: 15.0),),subtitle: const Text("Subida de avisos y convocatorias",textAlign: TextAlign.center,),),
                  ],
                ),shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0))),elevation: 4.0,)):const SizedBox(width: 0.0,height: 0.0,),






                per[4]=="1" ?
                SizedBox(width: MediaQuery.of(context).size.width/2-60,height: 300.0,child: RaisedButton(onPressed: (){
                  if(va.conexion){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Noticias()));

                  }


                },child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.home,size: 120.0,color: Colors.grey,),
                    const ListTile(title: const Text("OFICIALES",textAlign: TextAlign.center,),subtitle: const Text("Subida de noticias oficiales",textAlign: TextAlign.center,),),
                  ],
                ),shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(15.0))),elevation: 4.0,))
                   :const SizedBox(width: 0.0,height: 0.0,),

                per[5]=="1" ? SizedBox(width: MediaQuery.of(context).size.width/2-60,height: 300.0,child: RaisedButton(onPressed: (){
                  if(va.conexion){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Noti()));

                  }

                },child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.home,size: 120.0,color: Colors.grey,),
                    const ListTile(title:const Text("OFICIALES 2",textAlign: TextAlign.center,),subtitle: const Text("Subida de noticias oficiales",textAlign: TextAlign.center,),),
                  ],
                ),shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(15.0))),elevation: 4.0,)):const SizedBox(width: 0.0,height: 0.0,),

              ],
            ),
           per[6]=="0" && per[5]=="0" &&  per[4]=="0"  &&  per[3]=="0" &&  per[2]=="0" &&  per[1]=="0" && per[0]=="0" ?
            Padding(padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/2-15 ),child:const Center(child: const Text("No cuenta con ningun permiso"),)) : Container(),




           per[0]=="1" ? const ExpansionTile(leading: const Icon(Icons.apps),title: const Text("Permiso de Docentes y Estudiantes"),children: <Widget>[
            const ListTile(subtitle:  const Text("Puedes añadir, modificar y eliminar Docentes y Estudiantes en la sección correspondiente",),)
           ],):const SizedBox(),
           per[1]=="1"? const ExpansionTile(leading: const Icon(Icons.people),title: const Text("Permiso de Oferta Educativa"),
             children: <Widget>[
   const ListTile(subtitle:  const Text("Puedes añadir, modificar y eliminar carreras en la Oferta Educativa Institucional"),)
    ],
           ):const SizedBox(),
           per[2]=="1"? const ExpansionTile(leading: const Icon(Icons.school),title: const Text("Permiso de Sobre el Instituto"),
             children: <Widget>[
               const ListTile(subtitle: const Text("Puedes añadir, modificar y eliminar elementos del Directorio Institucional"),)
             ],
           ):Container(),
         ],),),
     );

  }
}
