import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:itec/pages/instituto.dart';
import 'package:itec/pages/oferta_educativa.dart';
import 'package:itec/pages/sii.dart';
import 'package:itec/pages/configuracion.dart';
import 'publicos.dart';
class Mai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(

      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          title: const Text("Instituto Tecnológico de Comitán"),
          subtitle: const Text("Tecnológico Nacional de México"),
          leading: Image.asset(
            "assets/logotipo.png",
            scale: 40.0,
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.school),
          title: const Text('Sobre el Instituto'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => instituto()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Oferta Educativa'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => oferta()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.widgets),
          title: const Text('Docentes y Estudiantes'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => herra()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text("Configuración"),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => Config()),
            );
          },
        ),
        const Divider(),
        ListTile(
          isThreeLine: true,
          leading: const Icon(Icons.developer_mode),
          title: const Text("InformaTEC"),

          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Wrap(
                children: <Widget>[
                  const Text("Versión 1.3.3  © 2019 "),

                  GestureDetector(
                    onTap: (){
                      showDialog(context: context,builder: (context){
                        return AlertDialog(
                          actions: <Widget>[
                            FlatButton.icon(onPressed: (){

                              Publicos().sendMail("danycastle96@gmail.com");
                            }, icon: const Icon(Icons.mail), label:const Text("Negocios"))
                          ],
                          shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(15.0)),
                          content:
                          Column(
                          mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                  Publicos().openBrowserTab("https://www.linkedin.com/in/alexiscastillo12");
                                },
                                child: CircleAvatar(

                                  radius: 31.0,
                                  backgroundImage:
                                  NetworkImage("https://media.licdn.com/dms/image/C4E03AQHgQFPMYIXi1w/profile-displayphoto-shrink_200_200/0?e=1583366400&v=beta&t=lQDJzU9lBMsDk2m5UkTThttjMmHpeC04eb4OSKDX4T0"),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                          ListTile(
                            onTap: (){
                              Publicos().openBrowserTab("https://www.linkedin.com/in/alexiscastillo12");
                            },
                              leading: const Icon(FontAwesomeIcons.linkedin),
                        title: const Text("Alexis Castillo"),
                        subtitle: const Text("Desarrollador Móvil")),


                          Divider(),
                              GestureDetector(
                                onTap:(){
                                  Publicos().openBrowserTab("https://www.linkedin.com/in/estefany-itzel-velasco-tenorio-7638b3173");
                        },
                                child: CircleAvatar(

                                  radius: 31.0,
                                  backgroundImage:
                                  NetworkImage("https://media.licdn.com/dms/image/C4E03AQHe-iL1h0EVpg/profile-displayphoto-shrink_800_800/0?e=1583366400&v=beta&t=e35vmvZXhokdSfGih6CS4k5F1nsxjG5gn-utGtryEME"),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                          ListTile(
                            onTap: (){
                              Publicos().openBrowserTab("https://www.linkedin.com/in/estefany-itzel-velasco-tenorio-7638b3173");
                            },
                          leading:const Icon(FontAwesomeIcons.linkedin),
                        title: const Text("Estefany Velasco"),
                        subtitle: const Text("Ux Designer")),



                          ],),
                        );
                      });
                    },
                    child: const Text(
                      "Desarrolladores",
                      style: const TextStyle(decoration: TextDecoration.underline,fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              GestureDetector(
                child: const Text("Términos y condiciones",
                  style: const TextStyle(decoration: TextDecoration.underline),),
                onTap: (){
                  Publicos().openBrowserTab("https://bit.ly/2VckmZf");
                },
              ),


            ],
          ),
        ),
      ],
    );
  }
}

