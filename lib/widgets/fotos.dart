import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:itec/widgets/zoom.dart';
class Foto extends StatelessWidget {
  final int a;
  final String foto;
  Foto(this.a,this.foto);
  @override
  Widget build(BuildContext context) {
    return PinchZoomImage(
      zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
      image: ClipRRect(
        borderRadius:const BorderRadius.only(
            topRight: const Radius.circular(12.0),
            topLeft: const Radius.circular(12.0)),
        child: a<10? FadeInImage(
          fit: BoxFit.cover,
          image: CachedNetworkImageProvider(
              foto),placeholder: const AssetImage("assets/cargando.png"),):
        FadeInImage.assetNetwork(placeholder:"assets/cargando.png", image: foto),
      ),
    );
  }
}
