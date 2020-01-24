import 'package:flutter/material.dart';
import 'preferencias.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detalles_items.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/network.dart';

class DataSearch extends SearchDelegate<String>{
 String a="noticias";
 var db=DatabaseHelper();


  @override
  // TODO: implement searchFieldLabel
  String get searchFieldLabel => "Buscar";
 @override
 ThemeData appBarTheme(BuildContext context) {
   // TODO: implement appBarTheme

   assert(context != null);
   final ThemeData theme = Theme.of(context).brightness == Brightness.dark ? Theme.of(context) : ThemeData(primaryColor: const Color(0xFFFFFFFF));
   assert(theme != null);
   return theme;
 }
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
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
                        const Text("Cuando no tengas acceso a internet, todas tus busquedas recientes estarán disponibles para consulta.",textAlign: TextAlign.justify,),
                        const SizedBox(height: 15.0,),
                        const Text("TIP: Si necesitas tener acceso inmediato o poder consultar más adelante sin conexion algun Aviso/Convocatoria utiliza esta sección para que esta sea guardado en tu dispositivo.",textAlign: TextAlign.justify,),
                      ],
                    )
                ),
              );
            });
          },):const SizedBox(),
        ),
      ),
            IconButton(icon: const Icon(Icons.clear),onPressed: (){
              query="";
            },),

];
  }


  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading

    return IconButton
      (
      icon:  AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),onPressed: (){
        close(context, null);
    },

    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return  query.isNotEmpty ?  StreamBuilder(

      stream: Firestore.instance.collection(a).where("titulo",isEqualTo: query).snapshots(),

      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return const Center(
            child: const CircularProgressIndicator(),
          );



          if(snapshot.data.documents.length!=0)
            return Holst(snapshot.data.documents[0].data["foto"],snapshot.data.documents[0].data["titulo"].toString(),snapshot.data.documents[0].data["descripcion"].toString(),snapshot.data.documents[0].data["link"]);
            return const Center(child: const Text("Elemento no Existente"));



      },
    ): Container();



  }


  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    return  query.isEmpty ? FutureBuilder<List>(

      future: db.getUser(),

     
      builder: (context, snapshot) {
        if (snapshot.hasData){
          
          return ListView.builder(

              itemCount: snapshot.data.length,itemBuilder: (context,index){
            return  ListTile(
              leading: snapshot.data.elementAt(index).toString().split("de:")[1].contains("noticias")?       const Icon(Icons.notification_important): const Icon(Icons.announcement),
              title:  Text(snapshot.data.elementAt(index).toString().replaceAll("{titulo: ","").replaceAll("}","").split(", de")[0],style:const TextStyle(fontWeight: FontWeight.bold),),
              onTap: (){
                query=snapshot.data.elementAt(index).toString().replaceAll("{titulo: ","").replaceAll("}","").toString().split(", de")[0];
                if(snapshot.data.elementAt(index).toString().split("de:")[1].contains("noticias")){
                  a="noticias";
                }else{
                  a="convocatorias";
                }
                showResults(context);
              },
              trailing:  IconButton(icon: const Icon(Icons.delete), onPressed: (){
                db.deleteUser(snapshot.data.elementAt(index).toString().replaceAll("{titulo: ","").replaceAll("}","").toString().split(", de")[0]);
                close(context,null);

                showSearch(context: context, delegate: DataSearch());
              }),
            );

          });
        }else if(snapshot.hasError){

        }
        return const SizedBox();

      },
    )
    :  Provider.of<Network>(context,listen: false).conexion? StreamBuilder(
      stream: Firestore.instance.collection("lista").snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return const Center(child: const CircularProgressIndicator());

        return ListView.builder(itemBuilder: (context,index){
          String name;
          if(snapshot.data.documents[index].data["titulo"].toString().toLowerCase().startsWith(query.toLowerCase())){
             name=snapshot.data.documents[index].data["titulo"].toString();
          }

          return name!= null ? ListTile(
            onTap: (){
              db.verificar(name).then((list){
                if(list.length==0){
                  db.saveUser(name,snapshot.data.documents[index].data["de"].toString());
                }
              });

              a=snapshot.data.documents[index].data["de"].toString();
              query=name;
              showResults(context);
            },
            leading: snapshot.data.documents[index].data["de"].toString()=="noticias" ? const Icon(Icons.notification_important) :const Icon(Icons.announcement),
            title:RichText(text: TextSpan(
              text: name.substring(0,query.length),
              style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              children:[
                TextSpan(
                  text: name.substring(query.length),
                  style:const TextStyle(color: Colors.grey),
                ),
              ]
            )),
          ):Container();},itemCount: snapshot.data.documents.length,);
      },
    ): const Center(child: const Text("Error de red",style: const TextStyle(fontWeight: FontWeight.bold),));

  }

}