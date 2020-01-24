import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itec/providers/estilos.dart';
import 'package:itec/admi/editarInstituto.dart';
import 'package:itec/providers/institu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:itec/providers/network.dart';
import 'package:itec/providers/usuarios.dart';
import 'package:provider/provider.dart';
import 'package:itec/providers/publicos.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class instituto extends StatelessWidget{
    Widget metodo(List<DocumentSnapshot> document,context){
      if(document[0].data["permisos"][2]=="1")
        return  Consumer<Network>(
          builder: (context,va,_)=>
           IconButton(
              tooltip: va.conexion?"Agregar/Editar directorio":"No disponible en Modo Offline",
              icon: const Icon(Icons.edit),onPressed: (){
            if(va.conexion){
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => editar()),
              );
            }


      }),
        );
        return const SizedBox();

      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Provider.of<Usuarios>(context).email!=null ?Styles().estilo(context,"INSTITUTO"):Styles().estilo(context,"SOBRE EL INSTITUTO"),
        backgroundColor: Styles().background(context),
        iconTheme: Styles().colorIcon(context),
        actions: <Widget>[

          IconButton(tooltip: "Facebook Oficial",icon: const Icon(FontAwesomeIcons.facebookF,color: const Color(0xFF3b5998),), onPressed: (){
            Publicos().openBrowserTab("https://es-la.facebook.com/itcomitan");
          }),
          IconButton(tooltip: "Twitter Oficial",icon: const Icon(FontAwesomeIcons.twitter,color: const Color(0xFF00acee),), onPressed: (){
            Publicos().openBrowserTab("https://twitter.com/itcomitan");
          }),



      Provider.of<Usuarios>(context).email!=null ? StreamBuilder(stream: Firestore.instance
              .collection('usuarios')
              .where('correo', isEqualTo: Provider.of<Usuarios>(context).email)
              .snapshots(), builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) return const SizedBox();
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return const SizedBox(
          );

        default:
          return metodo(snapshot.data.documents,context);
      }
    },):const SizedBox(),
        ],
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool ins) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  child:  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: MediaQuery.of(context).size.shortestSide <600 ?220.0: 361.0,
                    floating:false,
                    pinned: false,
                    snap: false,
                    flexibleSpace: FlexibleSpaceBar(

                        background: CarouselSlider(items: [
                           Image.asset(
                            "assets/instituo.jpg",
                            fit: BoxFit.cover,

                             width: MediaQuery.of(context).size.width,
                            filterQuality: FilterQuality.medium ,
                          ),
                          Image.asset(
                            "assets/tecnm.png",
                            fit: BoxFit.contain,
                           color: Colors.white,
                            width: double.infinity,


                          ),
                          Image.asset(
                            "assets/platico.png",
                            fit: BoxFit.cover,

                            width: double.infinity,
                            filterQuality: FilterQuality.high,


                          ),
                          Image.asset(
                            "assets/tec5.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            filterQuality:FilterQuality.medium,
                          ),

                          Image.asset(
                            "assets/tec4.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            filterQuality: FilterQuality.medium ,
                          ),
                          Image.asset(
                            "assets/tec1.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            filterQuality: FilterQuality.medium ,
                          ),
                          Image.asset(
                            "assets/cidec.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            filterQuality:FilterQuality.medium,
                          ),
                          Image.asset(
                            "assets/tec2.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            filterQuality:FilterQuality.medium ,

                          ),
                          Image.asset(
                            "assets/tec3.jpg",
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            filterQuality:  FilterQuality.medium ,
                          ),
                        ],
                        initialPage: 0,
                          autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3,milliseconds: 600),
                          viewportFraction: 1.0,

                        )

                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(

                      labelColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFFFFFFFF):const Color(0xFF000000),
                      indicatorColor: Theme.of(context).brightness == Brightness.dark ? Colors.tealAccent
                  : const Color(0xFF28324E),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      tabs: [
                        const Tab(

                          text: "Historia",
                        ),
                        const Tab(text: "Generales"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(children: <Widget>[
              SafeArea(
                top: false,
                bottom: false,
                minimum: const EdgeInsets.all(15.0),
                child: Builder(builder: (context) {
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                        const SizedBox(height: 20.0,),
                        const Text(
                          "En el año de 1983, siendo Gobernador del Estado de Chiapas, el General Absalón Castellanos Domínguez determinó la fundación en el Estado de un Instituto Tecnológico Agropecuario (I.T.A.), dependiente de la Dirección General de Educación Tecnológica Agropecuaria.",
                          textAlign: TextAlign.justify,


                        ),
                            const SizedBox(height: 20.0,),
                         const Text(
                         "A finales del mes de Agosto de ese mismo año, se recibió la noticia de que la Secretaría de Educación Pública había autorizado la creación del Instituto Tecnológico Agropecuario de Comitán y había sido aceptado el proyecto de construcción de las primeras instalaciones.",
                          textAlign: TextAlign.justify,

                        ),
                            const SizedBox(height: 20.0,),
                        const Text("INICIO DE LABORES",
                            style: const TextStyle(fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center),
                            const SizedBox(height: 20.0,),
                        const  Text(
                          "En septiembre de 1984, inicia sus actividades el instituto Tecnológico Agropecuario de Chiapas no. 31, bajo la dirección del Ingeniero Gildardo Quezada.",
                          textAlign: TextAlign.justify,

                        ),
                            const SizedBox(height: 20.0,),
                        const  Text(
                          "Esta Institución surge como una respuesta a la demanda de Educación Tecnológica superior de la Región III Fronteriza (principalmente), pero también los estudiantes de educación media superior de las regiones Selva, Altos, Norte y Sierra se ven beneficiados, pues cuentan ya con una opción mas para realizar sus estudios profesionales y evitar emigrar a la capital del estado o el centro del país.",
                          textAlign: TextAlign.justify,

                        ),
                            const SizedBox(height: 20.0,),
                        const Text(
                          "Las carreras con que se arranco el tecnólogico fueron:",
                          textAlign: TextAlign.left,

                        ),
                            const SizedBox(height: 20.0,),
                        Wrap(
                          children: <Widget>[
                            Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                           const  Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0),
                              child:  const Text(
                                  "Ingeniero Agrónomo Especialista en Fitotecnia",

                              ),

                            ),
                          ],
                        ),
                         const SizedBox(height:15.0),
                         Wrap(
                          children: <Widget>[
                            Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                             Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0),
                              child:  const Text(
                                  "Ingeniero Agrónomo Especialista en Bosques",),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0,),
                        const Text(
                          "CAMBIO DE SISTEMA",
                          style: const TextStyle(fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                            const SizedBox(height: 20.0,),
                       const  Text(
                          "En septiembre de 1992 por instrucciones del entonces Secretario de Educación Pública Dr. Ernesto Zedillo Ponce de León, el I. T A. pasa ha ser Instituto Tecnológico de Comitán, dependiente de la Dirección General de Institutos Tecnológicos (D.G.I.T.) ampliando el número de opciones de carreras profesionales y ofreciéndose:",
                          textAlign: TextAlign.justify,
                           ),
                            const SizedBox(height: 20.0,),
                        Wrap(
                          children: <Widget>[
                            Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0),
                              child:  const Text("Ingeniería Industrial",),
                            ),
                          ],
                        ),
                            const SizedBox(height: 15.0,),
                        Wrap(
                          children: <Widget>[
                            Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                           const  Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child:  const Text("Licenciatura en Informática",),
                            ),
                          ],
                        ),
                            const SizedBox(height: 15.0,),
                        Row(
                          children: <Widget>[
                             Container(
                              height: 10.0,
                              width: 10.0,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                             const Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0),
                              child: const Text("Ingeniería en Agronomía",),
                            ),
                          ],
                        ),
                            const SizedBox(height: 15.0,),
                         const Text(
                          "A partir de esa fecha el Estado de Chiapas cuenta con tres Institutos Tecnológicos, ubicados en Tuxtla Gutiérrez, Tapachula y Comitán.",
                          textAlign: TextAlign.justify,
                          ),
                            const SizedBox(height: 20.0,),
                         const Text(
                          "Para determinar que carreras se abrirían se hizo un análisis, a través del cual se pretendía conocer, cuales eran los intereses de la comunidad del nivel medio superior, además de que hubieran fuentes de trabajo u aplicación en la región para estas carreras.",
                          textAlign: TextAlign.justify,
                           ),
                            const SizedBox(height: 20.0,),
                         const Text(
                          "Carreras de Ingeniero Agrónomo en producción forestal e Ingeniero Agrónomo en producción agrícola, se incorporan en Septiembre de 1993 al plan de estudios de la D.G.I.T. por lo cual sufren un cambio de estructura, redefiniéndose como Ingeniero en Agronomía.",
                          textAlign: TextAlign.justify,
                           ),
                            const SizedBox(height: 20.0,),
                         const Text(
                          "Apartir de 1994, el Instituto Tecnológico de Comitán, abre la carrera de Licenciado en Administración, ofreciendo de esta manera a la comunidad estudiantil cuatro carreras, lo que significaba un logro más de esta joven Institución.",
                          textAlign: TextAlign.justify,
                            ),
                       const SizedBox(height: 15.0,),
                        const Text(
                          "BENEFICIOS QUE TRAJO PERTENECER A LA D.G.I.T.",
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                            const SizedBox(height: 20.0,),
                        const  Text(
                          "Muchos han sido los beneficios que ha traído pertenecer a la Dirección General de Institutos Tecnológicos, tanto a nivel de infraestructura, equipamiento, apoyo a docentes y administrativos como a alumnos.",
                          textAlign: TextAlign.justify,
                        ),
                      ])),
                    ],
                  );
                }),
              ),
              SafeArea(
                top: false,
                bottom: false,
                minimum: const EdgeInsets.all(15.0),
                child: Builder(builder: (context) {
                  return  CustomScrollView(
                    slivers: <Widget>[
                       SliverList(
                          delegate: SliverChildListDelegate([
                        const ListTile(
                          title: const Text(
                            "DIRECTORIO",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        )
                        ,


                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("directorio")
                              .orderBy("value", descending: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return Center(

                                    child: const CircularProgressIndicator()
                              );

                            return Insti().listdirec(snapshot.data.documents);

                          },
                        ),

                        const ListTile(
                          title: const Text(
                            "MISIÓN",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                            const SizedBox(height: 8.0,),
                        const Text(
                          "Coadyuvar a la formación integral del ser humano para el desarrollo de una sociedad justa y equitativa.",
                          textAlign: TextAlign.justify,
                        ),
                            const SizedBox(height: 20.0,),
                       const ListTile(
                          title: const Text(
                            "VISIÓN",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                            const SizedBox(height: 20.0,),
                        const Text(
                          "Ser la Institución líder en innovación, desarrollo y transferencia de tecnología; mediante la consolidación del talento académico y profesional con excelencia humana y alto sentido del deber social.",
                          textAlign: TextAlign.justify,
                        ),
                            const SizedBox(height: 20.0,),
                            const ListTile(
                              title: const Text(
                                "VALORES",
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("Espíritu de servicio",),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("Liderazgo",),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("Trabajo en equipo",),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("Calidad",),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("Equidad",),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("Identidad",),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("Sustentabilidad",),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15.0,),
                        const ListTile(
                          title: const Text(
                            "DIRECCIÓN",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                            const SizedBox(height: 8.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("CIITIC",),
                                ),
                              ],
                            ),
                        const SizedBox(height: 8.0,),
                        GestureDetector(
                          onTap: () {
                            Publicos().openBrowserTab(
                                "https://goo.gl/maps/hnDfj575ZRXEEHwG9");
                          },
                          child:  ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15.0),
                                topRight: const Radius.circular(15.0)),
                            child:  Image.asset("assets/mapa.png"),
                          ),
                        ),
                            const SizedBox(height: 8.0,),
                        const Text("Instituto Tecnológico de Comitán"),
                            const SizedBox(height: 5.0,),
                        const Text("Carretera antigua a la Trinitaria. Acceso Periférico Ote. S/N Col. Chichimá Acapetahua, Comitán de Domínguez, Chiapas, C.P. 30000."),

                            const SizedBox(height: 15.0,),
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 10.0,
                                  width: 10.0,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const  Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child:  const Text("CIDEC",),
                                ),

                              ],
                            ),
                            const SizedBox(height: 8.0,),
                            GestureDetector(
                              onTap: () {
                                Publicos().openBrowserTab(
                                    "https://goo.gl/maps/FyRqLmnVtPL7TaADA");
                              },
                              child:  ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(15.0),
                                    topRight: const Radius.circular(15.0)),
                                child:  Image.asset("assets/mapa2.png"),
                              ),
                            ),
                            const SizedBox(height: 8.0,),
                            const Text("Instituto Tecnológico de Comitán"),
                            const SizedBox(height: 5.0,),
                            const Text("Avenida Instituto Tecnológico km 3.5 Col. Yocnajab el Rosario, Comitán de Domínguez, Chiapas, C.P. 30000."),

                          ])),
                    ],
                  );
                }),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}


//                            "Avenida Instituto Tecnologico km 3.5 Col. Yocnajab el Rosario, Comitán de Dominguez Chiapas, México. C.P. 30000."),
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(

      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
