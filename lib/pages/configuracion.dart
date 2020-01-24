import 'package:itec/providers/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:itec/providers/estilos.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/network.dart';
class Config extends StatelessWidget {

  final GlobalKey<ScaffoldState> scaffoldKeyss =  GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    void changeBrightness() {
      DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
    }
    return Scaffold(
      key: scaffoldKeyss,
      appBar: AppBar(
        elevation: 0.0,
        title: Styles().estilo(context,"CONFIGURACIÓN"),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),

    ),
     body: SafeArea(child: SingleChildScrollView(
        child:Column(
          children: <Widget>[
            Container(
                color: Colors.black12,
                child: const ListTile(title: const Text("GENERALES",style:const TextStyle(color: Colors.grey),),)),
            Card(
              margin:const EdgeInsets.all(0.0),
              child: SwitchListTile(subtitle: const Text("Experiencia de la interfaz ideal para la noche"),secondary: const Icon(Icons.dashboard,color: Colors.lightBlue,) ,title: const Text("Modo Oscuro"),value: Theme.of(context).brightness==Brightness.dark?true:false,onChanged: (as){
                changeBrightness();
              },),
            ),
            Card(
              margin:const EdgeInsets.all(0.0),
              child: SwitchListTile(subtitle: const Text("Solo algunos contenidos estarán disponibles sin internet"),secondary: const Icon(Icons.offline_pin,color: Colors.redAccent,) ,title: const Text("Modo Offline (Automático)"),value: !Provider.of<Network>(context).conexion,),
            ),

            Card(
              margin:const EdgeInsets.all(0.0),
              child: ListTile(subtitle: const Text("Optimiza el almacenamiento"),leading: const Icon(Icons.image),title: const Text("Limpiar caché"),onTap: ()async {
                await DefaultCacheManager().emptyCache();
                scaffoldKeyss.currentState.showSnackBar(const SnackBar(
                  content: const Text("Cache borrado correctamente"),
                ));
              },)
            ),



          ],
        ) ,
    )),
    );
  }
}
