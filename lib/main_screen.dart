import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itec/admi/Panel.dart';
import 'package:itec/busquedas/zoom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:itec/providers/controller.dart';
import 'providers/principales.dart';
import 'package:itec/providers/metodos.dart';
import 'package:provider/provider.dart';
import 'providers/usuarios.dart';
import 'providers/estilos.dart';
import 'package:connectivity/connectivity.dart';
import 'providers/network.dart';
import 'providers/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class inicio extends StatefulWidget {


  @override
  _inicioState createState() => _inicioState();
}

class _inicioState extends State<inicio> with TickerProviderStateMixin{

 AnimationController _animationController;
  final GlobalKey<ScaffoldState> scaffoldKeyss = GlobalKey<ScaffoldState>();

  bool pass = true;
  bool texto = true;
  bool texto2 = true;
  TextEditingController teFirstName = TextEditingController();
  TextEditingController teLastFirstName = TextEditingController();
  TextEditingController te = TextEditingController();
  TextEditingController ta = TextEditingController();


  void acceso() async {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        const Icon(Icons.person_pin,
                            size: 100.0, color: Colors.grey),
                        Positioned(
                            right: 0.0,
                            child: IconButton(
                                icon: const Icon(Icons.exit_to_app),
                                tooltip: Provider.of<Network>(context).conexion?"Cerrar Sesión":"No disponible en Modo Offline",
                                onPressed: () async {
                                  if(Provider.of<Network>(context).conexion){
                                    Navigator.of(context).pop();
                                    Provider.of<Usuarios>(context).email = null;
                                    msja();

                                    await _auth
                                        .signOut()
                                        .then((sa) {})
                                        .catchError((dss) {});
                                  }


                                },
                                color: Colors.grey)),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text(
                      Provider.of<Usuarios>(context).email.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(

                          icon: const Icon(Icons.vpn_key),
                          tooltip: Provider.of<Network>(context).conexion?"Cambiar Contraseña":"No disponible en Modo Offline",
                          onPressed: () {
                            if(Provider.of<Network>(context).conexion) {
                              Metodos().authorizeNow().then((valor) {
                                if (valor==true) {
                                  Navigator.of(context).pop();
                                  cambiarPass();
                                }else if(valor=="sin"){
                                  Navigator.of(context).pop();
                                  cambiarPass();
                                }
                              });
                            }

                          },
                          color: Colors.grey),
                      IconButton(
                          icon: const Icon(Icons.delete_forever),
                          tooltip: Provider.of<Network>(context).conexion?"Borrar Cuenta":"No disponible en Modo Offline",
                          onPressed: () {
                            if(Provider.of<Network>(context).conexion) {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Metodos()
                                      .eliminarUsuarios(
                                      context));
                            }

                          },
                          color: Colors.grey),
                      IconButton(
                          icon: const Icon(Icons.cancel),
                          tooltip: "Cancelar",
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget getTextField(
      String inputBoxName,
      TextEditingController inputBoxController,
      final a,
      final edit,
      final cambiar,
      final fd) {
    var loginBtn;
    if (a) {
      loginBtn = Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextFormField(
          controller: inputBoxController,
          obscureText: fd ? texto2 : texto,
          decoration: InputDecoration(
              hintText: inputBoxName,
              border: const UnderlineInputBorder(),
              filled: true,
              suffixIcon: GestureDetector(
                onTap: () {
                  if (fd) {
                    texto2 = !texto2;
                  } else {
                    texto = !texto;
                  }
                  Navigator.of(context).pop();
                  if (cambiar) {
                    cambiarPass();
                  } else {
                    aler();
                  }
                },
                child: Icon(
                  fd
                      ? texto2 ? Icons.visibility_off : Icons.visibility
                      : texto ? Icons.visibility_off : Icons.visibility,
                  semanticLabel:
                      texto ? 'Mostrar Password' : 'Ocultar password',
                ),
              )),
        ),
      );
    } else {
      loginBtn = Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextFormField(
          controller: inputBoxController,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            filled: true,
            hintText: inputBoxName,
          ),
          obscureText: a,
        ),
      );
    }
    return loginBtn;
  }



  void cambiarPass() {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Text(
              "CAMBIAR CONTRASEÑA",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  getTextField(
                      "Nueva contraseña", ta, true, false, true, false),
                  getTextField(
                      "Confirmar contraseña", te, true, false, true, true),
                ],
              ),
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      _auth.currentUser().then((use) async {
                        if (te.text.toString() == ta.text.toString()) {
                          if (te.text.toString().length >= 6) {
                            use.updatePassword(te.text);

                            Navigator.of(context).pop();
                            scaffoldKeyss.currentState
                                .showSnackBar(const SnackBar(
                              content: const Text("Contraseña actualizada"),
                            ));
                            te.text = "";
                            ta.text = "";
                          } else {
                            scaffoldKeyss.currentState
                                .showSnackBar(const SnackBar(
                              content: const Text("Contraseña demasiado corta"),
                            ));
                          }
                        } else {
                          scaffoldKeyss.currentState
                              .showSnackBar(const SnackBar(
                            content: const Text("Las contraseñas no coinciden"),
                          ));
                        }
                      });
                    },
                    child: const Text("Confirmar"),
                  ),
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar")),
                ],
              ),
            ],
          );
        });
  }

  void aler() {
    showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Text(
              "ADMINISTRADOR",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Padding(padding: const EdgeInsets.all(5.0)),
                  getTextField("Login del Usuario", teFirstName, false, false,
                      false, false),
                  const Padding(padding: const EdgeInsets.all(5.0)),
                  getTextField(
                      "Password", teLastFirstName, true, false, false, false),
                  const Padding(padding: const EdgeInsets.all(5.0)),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _testSignInAnonymously();
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Metodos().getAppBorderButton("ACEPTAR",
                          const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),context),
                    ),
                  ),
                  !pass
                      ? const ListTile(
                          leading: const Icon(Icons.warning),
                          title: const Text("¡Datos Incorrectos!"),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }


  void msj() {
    scaffoldKeyss.currentState.showSnackBar(const SnackBar(
      content: const Text("Acceso de Administrador Concedido"),
    ));
  }

  void msja() {
    scaffoldKeyss.currentState.showSnackBar(const SnackBar(
      content: const Text("Sesión Finalizada"),
    ));
  }
  void offline(){
    scaffoldKeyss.currentState.showSnackBar(

       SnackBar(content:  const Text("Conéctate para sincronizar las noticias"),
      action: SnackBarAction(
        textColor: Theme.of(context).brightness==Brightness.light?Colors.white:Colors.black,
        label: "Más",
        onPressed: (){
          showSearch(context: context, delegate: DataSearch());
        },
      ),
      )
    );
  }
  Future<void> _testSignInAnonymously() async {
    try {

      await _auth
          .signInWithEmailAndPassword(
              email: teFirstName.text, password: teLastFirstName.text)
          .then((user) async {
        assert(user.user.email != null);

        await _auth.currentUser().then((user) {
          Provider.of<Usuarios>(context,listen: false).email = user.email;

        });
      });

      pass = true;
      msj();
      teLastFirstName.text = "";
      teFirstName.text = "";
    } catch (Exception) {
      pass = false;
      aler();
    }

  }

  void navegar(final info){
    if((info["data"]["titl"]).toString().contains("AVISO")){
      Provider.of<Principal>(context,listen: false).current = 1;
    }else{
      Provider.of<Principal>(context,listen: false).current = 2;
    }
  }

  @override
  void initState() {

    super.initState();
        _animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 445));
           FirebaseMessaging().configure(
            onMessage: (info)async{

              scaffoldKeyss.currentState.showSnackBar(SnackBar(content:  Text(info["notification"]["title"]),action: SnackBarAction(
                textColor: Theme.of(context).brightness==Brightness.light?Colors.white:Colors.black,
                label: "Ver",onPressed: (){
                if((info["notification"]["title"]).toString().contains("AVISO")){
                  Provider.of<Principal>(context,listen: false).current = 1;
                }else{
                  Provider.of<Principal>(context,listen: false).current = 2;
                }

              },),));

            },

             onLaunch: (info) async {



                   navegar(info);

             },
             onResume: (info) async {

               navegar(info);

             },

           );

    veri();
   Metodos().notificaciones();

        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            Provider.of<Network>(context,listen: false).conexion=true;

          }else{
            Provider.of<Network>(context,listen: false).conexion=false;
            scaffoldKeyss.currentState.showSnackBar(const SnackBar(content: const Text("Modo Offline")));
          }
        });
  }


  @override
  void dispose() {
    Provider.of<Controlador>(context,listen: false).dispose();
   _animationController.dispose();
    teFirstName.dispose();
    teLastFirstName.dispose();
    te.dispose();
    ta.dispose();
    super.dispose();
  }

  void veri() async {
    await _auth.currentUser().then((user)async {
      if (user != null && !(user.isAnonymous)) {
        if (user.email != null) {

          pass = true;
          Provider.of<Usuarios>(context,listen: false).email = user.email;
        }
      }else{
     await  _auth.signInAnonymously();
      }
    }).catchError((sa) {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: scaffoldKeyss,
      body: SafeArea(
        child: CustomScrollView(
          controller: Provider.of<Controlador>(context,listen: false).con,
          slivers: <Widget>[
            SliverAppBar(

              expandedHeight: 0.0,
              floating: true,
              pinned: false,
              snap: true,

              title: Styles().estilo(context, "INFORMATEC"),
              backgroundColor: Styles().background(context),
              iconTheme: Styles().colorIcon(context),


              leading: IconButton(
                  icon: AnimatedIcon(icon:AnimatedIcons.menu_close,progress: _animationController,),
                  onPressed: () {

                      _animationController.forward();


                    showModalBottomSheet(

                      context: context, builder: (context)=>Mai(),
                    shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.only(topLeft: const Radius.circular(15.0),topRight: const Radius.circular(15.0))),
                    ).then((value){
                      _animationController.reverse();
                    });
                  }),
              actions: <Widget>[


                IconButton(
                    icon: const Icon(Icons.search),

                    tooltip: "Busqueda de Avisos/Convocatorias",
                    onPressed: () {

        showSearch(context: context, delegate: DataSearch());

                    }),
                IconButton(
                    icon: Icon(!(Provider.of<Usuarios>(context,listen: false).email != null)
                        ? Icons.person
                        : Icons.verified_user),
                    tooltip: !(Provider.of<Usuarios>(context,listen: false).email != null)
                        ? "Iniciar Sesión"
                        : "Acceso de Administrador",
                    onPressed: () {
                      if (!(Provider.of<Usuarios>(context,listen: false).email != null)) {
                        aler();
                      } else {
                        acceso();
                      }
                    }),
                Consumer<Usuarios>(builder: (context,user,_)=> user.email!=null ? IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: "Panel de Administración",
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Pane(this)));
                  },
                )
                    : const SizedBox(), ),


              ],
            ),
            SliverList(

                delegate: SliverChildListDelegate(<Widget>[
                     Consumer<Principal>(builder: (context,c,_)=>c.clase[c.current] ),
                  !Provider.of<Network>(context,listen: false).conexion? Center(
                    child: FlatButton(padding: const EdgeInsets.all(0.0),child: const Text("Modo Offline",style: const TextStyle(fontWeight: FontWeight.bold),),onPressed: (){
                      offline();
                    },),
                    
                  ):const SizedBox(),

            ])),
          ],
        ),
      ),


      bottomNavigationBar:  BottomNavigationBar(

          currentIndex: Provider.of<Principal>(context).current,

          onTap: (int index) {
            Provider.of<Principal>(context,listen: false).current = index;
            if(Provider.of<Principal>(context,listen: false).current == index){
              Provider.of<Controlador>(context,listen: false).con.animateTo(
                0.0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 602),
              );
            }
          },


          items:  const <BottomNavigationBarItem>[
             const BottomNavigationBarItem(

              icon: const Icon(Icons.home),
              title: const Text('Oficiales'),
            ),
            const BottomNavigationBarItem(
              icon: const Icon(Icons.notification_important),
              title: const Text("Avisos"),
            ),
            const BottomNavigationBarItem(
              icon: const Icon(Icons.announcement),
              title: const Text("Convocatorias"),
            ),
          ],
          fixedColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF1B396A),
          iconSize: 20.0,

        ),
      );
  }
}
