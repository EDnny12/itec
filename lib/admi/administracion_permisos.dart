import 'package:itec/providers/metodos.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itec/providers/estilos.dart';
class Permisos extends StatefulWidget {
  final _inicioState;
  Permisos(this._inicioState);
  @override
  _PermisosState createState() => _PermisosState();
}

class _PermisosState extends State<Permisos> {
  final GlobalKey<ScaffoldState> scaffoldKeyss =  GlobalKey<ScaffoldState>();
  TextEditingController usu=TextEditingController();
  bool herra=false;
  bool oficial1=false;
  bool oficial2=false;
  bool oferta=false;
  bool avico=false;
  bool insti=false;
  bool admo=false;

  @override
  void dispose() {
    Metodos().pass.dispose();
    usu.dispose();
    super.dispose();
  }
  void Nueva(final edit,final lista,final corr,final re){

    if(edit && lista!=null){
      herra=lista[0]=="1"?true:false;
      oferta=lista[1]=="1"?true:false;
      insti=lista[2]=="1"?true:false;
      avico=lista[3]=="1"?true:false;
      oficial1=lista[4]=="1"?true:false;
      oficial2=lista[5]=="1"?true:false;
      admo=lista[6]=="1"?true:false;
    }
    showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)),
        title: edit ? const Text("EDITAR PERMISOS",textAlign: TextAlign.center):const Text("NUEVO USUARIO",textAlign: TextAlign.center,),
        content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
        Padding(
        padding: const EdgeInsets.all(5.0),
          child: edit ? Text(corr.toString(),textAlign: TextAlign.center,style:const TextStyle(decoration: TextDecoration.underline)): TextFormField(
            controller: usu,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              filled: true,
              hintText: "Correo del usuario",
            ),
            obscureText: false,
          ),
        ),
        CheckboxListTile(value: herra, onChanged:(value){
              setState(() {
                herra=value;
              });
              Navigator.of(context).pop();
              Nueva(edit,null,corr,re);
        },title: const Text("Docentes y Estudiantes"),),
            CheckboxListTile(value: oferta, onChanged:(value){
              setState(() {
                oferta=value;
              });
              Navigator.of(context).pop();
              Nueva(edit,null,corr,re);

            },title: const Text("Oferta Educativa"),),
            CheckboxListTile(value: insti, onChanged:(value){
              setState(() {
                insti=value;
              });
              Navigator.of(context).pop();
              Nueva(edit,null,corr,re);
            },title: const Text("Sobre el Instituto"),),

            CheckboxListTile(value: avico, onChanged:(value){
              setState(() {
                avico=value;

              });
              Navigator.of(context).pop();
              Nueva(edit,null,corr,re);
            },title: const Text("Avisos y Convocatorias"),),
            CheckboxListTile(value: oficial1, onChanged:(value){
              setState(() {
                oficial1=value;
              });
              Navigator.of(context).pop();
              Nueva(edit,null,corr,re);
            },title: const Text("Oficiales"),),
            CheckboxListTile(value: oficial2, onChanged:(value){
              setState(() {
                oficial2=value;
              });
              Navigator.of(context).pop();
              Nueva(edit,null,corr,re);
            },title: const Text("Oficiales Versión 2"),),

        !edit ? const Text("Nota: Sera logueado al ultimo usuario que añada",style: TextStyle(fontSize: 10,color: Colors.red),):const SizedBox(),

        
        GestureDetector(
          onTap: (){
            if(usu.text=="" && !edit){
              msj();
            }else{
               if(edit){

                 Firestore.instance.runTransaction((transaction) async {
                   DocumentSnapshot snapshot =
                    await transaction.get(re);
                    transaction.update(re, {
                     "permisos":[herra?"1":"0",oferta?"1":"0",insti?"1":"0",avico?"1":"0",oficial1?"1":"0",oficial2?"1":"0",admo?"1":"0"],
                   });
                 });

               }else{


                   FirebaseAuth.instance.createUserWithEmailAndPassword(email: usu.text, password: "123456").then((user){
                     Firestore.instance.runTransaction((Transaction transaccion) async {
                       CollectionReference referencesx = Firestore.instance.collection('usuarios');
                       await referencesx.add({
                         "correo":usu.text,
                         "permisos":[herra?"1":"0",oferta?"1":"0",insti?"1":"0",avico?"1":"0",oficial1?"1":"0",oficial2?"1":"0","0"],
                       });

                     });
                     widget._inicioState.veri();
                   }).catchError((error){

                     msj();
                   });




               }




                 Navigator.of(context).pop();


            }
          },
          child: Container(
          margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            padding: const EdgeInsets.all(8.0),
            alignment: FractionalOffset.center,
            decoration:  BoxDecoration(
              border: Border.all(color:  Theme.of(context).brightness == Brightness.dark ? Colors.white :const Color(0xFF28324E)),
              borderRadius: const BorderRadius.all(const Radius.circular(6.0)),
            ),
            child: Text(
              "ACEPTAR",
              style: const TextStyle(

                fontSize: 20.0,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
          ],

        ),
        ),
      );
    });
  }
  void msj() {
    scaffoldKeyss.currentState.showSnackBar(const SnackBar(
      content: const Text("Ingrese un correo valido"),
    ));
  }
  void msja() {
    scaffoldKeyss.currentState.showSnackBar(const SnackBar(
      content: const Text("Error, verifique datos"),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:  scaffoldKeyss ,

      appBar: AppBar(
        elevation: 0.0,
        title: Styles().estilo(context,"PERMISOS"),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),
        actions: <Widget>[
          IconButton(
            tooltip: "Agregar Usuario",
              icon:const Icon(Icons.add_circle), onPressed: (){
             herra=false;
            oficial1=false;
           oficial2=false;
            oferta=false;
            avico=false;
            insti=false;
            Nueva(false,null,null,null);
          },),
        ],
      ),
    body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("usuarios")

          .snapshots(),

      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return const Text('ERROR AL CARGAR LOS USUARIOS');
        switch(snapshot.connectionState){
          case ConnectionState.waiting: return const Center(child: const CircularProgressIndicator());

          default: return lista(snapshot.data.documents,context);
        }
      },
    ),
    );
  }
  Widget lista(List<DocumentSnapshot> document,BuildContext context){
      return ListView.builder( padding: const EdgeInsets.only(top: 10.0),itemCount: document.length,itemBuilder: (BuildContext context , int index){

             final permisos = document[index].data["permisos"];
        return Padding(
          padding: const EdgeInsets.only(bottom:15.0),
          child: Card(
            elevation: 1.6,
            shape:  RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(12.0)),
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
                               ListTile(leading: const Icon(Icons.person),title: Text(document[index].data["correo"].toString()),),
                                permisos[0]=="1"? const Text("Docentes y Estudiantes"):Container(),
                                permisos[1]=="1"?const Text("Oferta Educativa"):Container(),
                                permisos[2]=="1"?const Text("Sobre el Instituto"):Container(),
                                permisos[3]=="1"?const Text("Avisos y Convocatorias"):Container(),
                                permisos[4]=="1"?const Text("Oficiales"):Container(),
                                permisos[5]=="1"?const Text("Oficiales Versión 2"):Container(),

                              ],
                            )
                        ),
                      ),

                          IconButton(

                              icon: const Icon(

                                Icons.edit,
                                color: const Color(0xFF167F67)),
                            onPressed: () {

                                Nueva(true,permisos,document[index].data["correo"].toString(),document[index].reference);


                            }

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
