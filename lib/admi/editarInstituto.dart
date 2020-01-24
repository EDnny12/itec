import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/providers/metodos.dart';
class editar extends StatefulWidget {
  @override
  _editarState createState() => _editarState();
}

class _editarState extends State<editar> {


  final GlobalKey<ScaffoldState> scaffoldKeyss =  GlobalKey<ScaffoldState>();
  camposVacios(){
    scaffoldKeyss.currentState.showSnackBar(const SnackBar(
      content: const Text("No deje campos vacios"),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKeyss,

      appBar: AppBar(
        elevation: 0.0,
        title: Styles().estilo(context,"DIRECTORIO"),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) => Metodos().directorio(false,"", "", "",
                "",null,context,this)

              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("directorio")
            .orderBy("value", descending: false)
            .snapshots(),

        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return const Text('ERROR AL CARGAR LOS DATOS');
          switch(snapshot.connectionState){
            case ConnectionState.waiting: return const CircularProgressIndicator();

            default: return listas(snapshot.data.documents,context);
          }
        },
      )
    );
  }
  Widget listas(List<DocumentSnapshot> document,BuildContext context){
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10.0),
    itemCount: document.length
    ,itemBuilder: (context, int index){

      final String nombre = document[index].data["nombre"].toString();
      final String correo = document[index].data["correo"].toString();
      final String ext = document[index].data["ext"].toString();
      final String puesto = document[index].data["puesto"].toString();

      return Padding(
        padding: const EdgeInsets.only(bottom:15.0),
        child: Card(
          elevation: 1.6,
          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.only(left: 13.0, right: 13.0),
          child:  Container(
              child:  Center(
                child:  Row(
                  children: <Widget>[

                     Expanded(
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            ListTile(title: Text(nombre),subtitle: Text(puesto),),
                            ListTile(title: Text(correo),subtitle: Text(ext),),


                          ],
                        )
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                         IconButton(
                          icon: const Icon(Icons.edit,
                              color: const Color(0xFF167F67)),
                          onPressed: () {

                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Metodos()
                                  .directorio(true, nombre, correo, puesto, ext,document[index].reference,context,this)
                            );
                          }
                          ,
                        ),
                         IconButton(
                          icon: const Icon(Icons.delete_forever,
                              color: const Color(0xFF167F67)),
                          onPressed: () {

                            showDialog(
                                context: context,
                                builder: (BuildContext context) => Metodos()
                                    .eliminarAvisoConvocatoria(context,
                                    document[index].reference, nombre, "directorio",null));
                          }
                            ,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
        ),
      );












    });
  }
}

