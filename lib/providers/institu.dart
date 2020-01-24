import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'publicos.dart';
class Insti{


  List<CustomPopupMenu> choices = <CustomPopupMenu>[
    CustomPopupMenu(title: 'Llamar a CIITIC', icon: Icons.call),
    CustomPopupMenu(title: 'Llamar a CIDEC', icon: Icons.call),
    CustomPopupMenu(title: 'Enviar correo', icon: Icons.mail),
  ];
  List<CustomPopupMenu> choice2 = <CustomPopupMenu>[
    CustomPopupMenu(title: 'Enviar correo', icon: Icons.mail),
    CustomPopupMenu(title: 'Llamar', icon: Icons.call),

  ];

  Widget listdirec(List<DocumentSnapshot> document) {
    return Scrollbar(

      child: SizedBox(
        height: 270.0,
        child: ListView.builder(

          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: document.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              contentPadding: EdgeInsets.all(5.0),
              leading: Hero(tag: index,child: const Icon(Icons.person_pin)),

              title: Text(document[index].data["nombre"]),
              trailing: PopupMenuButton<CustomPopupMenu>(
             onSelected: (CustomPopupMenu menu){
               if(menu.title.toString()=="Llamar"){
                 final unico = document[index].data["ext"].toString();
                 Publicos().launchURL("6322517,,,$unico");

               }else{

                 if(menu.title.toString()=="Llamar a CIITIC"){
                   final citic = document[index]
                       .data["ext"]
                       .toString()
                       .split(",")
                       .elementAt(0);
                   final cidec = document[index]
                       .data["ext"]
                       .toString()
                       .split(",")
                       .elementAt(1);
                   Publicos().launchURL("6322517,,,$citic");
                 }else if(menu.title.toString()=="Llamar a CIDEC"){
                   final citic = document[index]
                       .data["ext"]
                       .toString()
                       .split(",")
                       .elementAt(0);
                   final cidec = document[index]
                       .data["ext"]
                       .toString()
                       .split(",")
                       .elementAt(1);
                   Publicos().launchURL("6322517,,,$cidec");
                 }else{
                        Publicos().sendMail(document[index].data["correo"].toString());
                 }
               }
             },
                itemBuilder: (BuildContext context) {
                  return

                    document[index].data["ext"].toString().split(",").length >
                        1 ?

                    choices.map((CustomPopupMenu choice) {
                      return PopupMenuItem<CustomPopupMenu>(
                        value: choice,
                        child: Text(choice.title),
                      );
                    }).toList() :
                    choice2.map((CustomPopupMenu choice) {
                      return PopupMenuItem<CustomPopupMenu>(
                        value: choice,
                        child: Text(choice.title),
                      );
                    }).toList();
                },
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(document[index].data["puesto"]),
                  Text(document[index].data["correo"]),
                  Text(document[index].data["ext"])
                ],
              ),
              isThreeLine: true,
            );
          },
        ),
      ),
    );
  }
}

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});

  String title;
  IconData icon;
}