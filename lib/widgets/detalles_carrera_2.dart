import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:itec/widgets/zoom.dart';

class Detail extends StatefulWidget {


  final user;
  final num;
  Detail(this.user,this.num);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  PageController controller;
   @override
  void initState() {
    controller=new PageController(initialPage: widget.num);
    super.initState();
  }
  @override
  void dispose() {
     controller.dispose();
     super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return   Container(
      color: Colors.black,
      child: PageView.builder(
              controller: controller,
              itemCount: this.widget.user.length,

              itemBuilder: (context,d){
               return  Center(
                 child: PinchZoomImage(
                   zoomedBackgroundColor: Color.fromRGBO(0, 0, 0, 1.0),
                   hideStatusBarWhileZooming: true,
                   image: CachedNetworkImage(
                      // width: MediaQuery.of(context).size.width,

                       imageUrl: this.widget.user[d],
                       placeholder: (context, url) => const CircularProgressIndicator(),
                       errorWidget: (context, url, error) => const Icon(Icons.error),
                     ),
                 ),
               );
          }),
    );

  }
}
