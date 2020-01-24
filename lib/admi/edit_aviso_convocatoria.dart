import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/providers/metodos.dart';
class Principal extends StatefulWidget {
  final a;
  final b;
  final c;
  final re;
final foto;
  Principal(this.a,this.b,this.c,this. re,this.foto);
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {

  TextEditingController titulo = new TextEditingController();
  TextEditingController des = new TextEditingController();

  @override
  void initState() {

   titulo.text=widget.b;
   des.text=widget.c;
    super.initState();
  }

  @override
  void dispose() {
   titulo.dispose();
   des.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Styles().estilo(context,"EDITAR "+widget.a.toString().toUpperCase()),
          backgroundColor: Styles().background(context),
          iconTheme: Styles().colorIcon(context),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(

            children: <Widget>[
              TextFormField(
                controller: titulo,
                maxLines: 2,
                decoration: InputDecoration(

                  border: const UnderlineInputBorder(),
                  hintText: widget.a=="aviso"?"Titulo del aviso":"Titulo de la convocatoria",
                ),

              ),
              TextFormField(
                controller: des,
                maxLines: 5,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),

                  hintText: widget.a=="aviso"?"Descripción del aviso":"Descripción de la convocatoria",
                ),
              ),

              /*ListView.builder

                (shrinkWrap: true,physics: const ClampingScrollPhysics(),itemCount: widget.foto.length,itemBuilder: (BuildContext context , int d){
                return FadeInImage.assetNetwork(placeholder:"assets/load2.gif", image:widget.foto[d]);
              })
*/
            ],

          ),
        ),
      ),
    ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).brightness==Brightness.dark? Colors.grey[900]:Color(0xFF1B396A),
          onPressed: (){
         final String links=Metodos().lins(des.text);
          Firestore.instance.runTransaction((transaction) async {
            DocumentSnapshot snapshot =
            await transaction.get(widget.re);
             transaction.update(widget.re, {
              "titulo": titulo.text,
              "descripcion":des.text,
             "link":links.length>=4 ? links.split("|"):"",
            });
             Navigator.of(context).pop();
          });
        },child: const Icon(Icons.edit,color: Colors.white,),),
    );
  }
}
