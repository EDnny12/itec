import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/providers/publicos.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:itec/providers/metodos.dart';
import 'package:itec/providers/network.dart';
class herra extends StatelessWidget {

  TextEditingController ab = TextEditingController();
  TextEditingController ad = TextEditingController();
  TextEditingController a = TextEditingController();
  TextEditingController b=TextEditingController();
  void dialog(String carreca,DocumentReference re,String link,context){
    if(carreca!=null) {
      a.text = carreca;
    }
    if(link!=null) {
      b.text = link;
    }
    showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        contentPadding:const EdgeInsets.all(0.0),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[


              TextFormField(

                  controller: a,
                  obscureText: false,
                  decoration: const InputDecoration(

                    border: const UnderlineInputBorder(),
                    filled: true,

                  )),
               TextFormField(

                  controller: b,
                  obscureText: false,
                  decoration: const InputDecoration(

                    border: const UnderlineInputBorder(),
                    filled: true,

                  )),

            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(child: const Text("Editar"),onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    Metodos().animacionCargando(context, "",0)
            );

              Firestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot =
                await transaction.get(re);
                await transaction.update(re, {
                  "titulo": a.text,
                  "link":b.text

                });
              });

            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }),
          FlatButton(child: const Text("Eliminar"),onPressed: (){

            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    Metodos().eliminarAvisoConvocatoria(context, re, a.text, "herramienta",null)
            );

          },),
          FlatButton(child:const Text("Cancelar"),onPressed: (){
            Navigator.of(context).pop();
          },)
        ],
      );
    });
  }
  void Nueva(context) {

    showDialog(

      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          contentPadding: const EdgeInsets.all(0.0),
          content: SingleChildScrollView(
              child: Column(
                children: <Widget>[

                   TextFormField(

                      controller: ab,

                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: "Titulo",
                        border: const UnderlineInputBorder(),
                        filled: true,

                      )),


                  TextFormField(

                      controller: ad,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: "Link",
                        border: const UnderlineInputBorder(),
                        filled: true,

                      )),


                ],
              )
          ),
          actions: <Widget>[
            FlatButton(onPressed: ()async{
              if(ab.text!="" && ad.text!=""){
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        Metodos().animacionCargando(context, "Herramienta",1)
                );



                Firestore.instance.runTransaction((Transaction transaccion) async {
                  CollectionReference reference = Firestore.instance.collection('herramientas');

                  await reference.add({

                    "titulo": ab.text,
                    "link": ad.text,
                    "popu":0,


                  });

                });
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }

            }, child:const Text("Añadir")),
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: const Text("Cancelar")),
          ],
        );
      },
    );
  }

  Widget metodo(List<DocumentSnapshot> document, context) {
    if (document[0].data["permisos"][0] == "1")
      return  Consumer<Network>(
          builder: (context,va,_)=>
         IconButton(
          tooltip: va.conexion?"Agregar Herramienta":"No disponible en modo Offline",
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              if(va.conexion){
                Nueva(context);
              }

            }),
      );
    return const SizedBox();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(

        appBar:  AppBar(
          title: Styles().estilo(context,"DOCENTES Y ESTUDIANTES"),
          backgroundColor: Styles().background(context),
          iconTheme: Styles().colorIcon(context),
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
            ) :const SizedBox(),
          ],
        ),

      body: SafeArea(child: StreamBuilder(
          stream: Firestore.instance.collection("herramientas").orderBy("popu",descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

            if (!snapshot.hasData)
              return const Center(
                child: const CircularProgressIndicator(),
              );
            return  lista(snapshot.data.documents,context);

          })),
    );
  }
  Widget lista(List<DocumentSnapshot> document,BuildContext context){



        return ListView.separated(padding: const EdgeInsets.only(top: 10.0,bottom: 10.0),itemCount: document.length,itemBuilder: (context, int d){

          return
             Card(
               margin:  const EdgeInsets.only(left:15.0,right: 15.0),
              shape: RoundedRectangleBorder(
                  borderRadius:  BorderRadius.circular(12.0)),
              elevation: 1.6,
             // color: Theme.of(context).brightness==Brightness.light?Colors.grey:Colors.black,
              child: ListTile(

                    leading: Icon(Icons.widgets),
                    title: Text(document[d].data["titulo"].toString(),textAlign: TextAlign.center,style:const TextStyle(fontWeight: FontWeight.bold),),
                    onTap: (){

                      Publicos().openBrowserTab(document[d].data["link"].toString());
                      Firestore.instance.runTransaction((transaction) async {

                        await transaction.update(document[d].reference, {
                          "popu": document[d].data["popu"]+1,


                        });
                      });

                    },
                    onLongPress: ()async{
                      if(Provider.of<Usuarios>(context,listen: false).email!=null && Provider.of<Network>(context,listen: false).conexion){

                        await Firestore.instance
                            .collection('usuarios')
                            .where('correo', isEqualTo: Provider.of<Usuarios>(context,listen: false).email)
                            .getDocuments()
                            .then((result) {
                          if (result.documents[0].data["permisos"][0] == "1") {
                            dialog(document[d].data["titulo"].toString(),document[d].reference,document[d].data["link"].toString(),context);
                          }
                        });

                      }
                    },
                  ),
            );


        },separatorBuilder: (context, int s){
          return const SizedBox(height: 12.5,);
        },);
  }
}


