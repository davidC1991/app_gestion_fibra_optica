import 'dart:ui';

import 'package:flutter/material.dart';

class Painter extends StatefulWidget {
  @override
  _PainterState createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  List<Offset> points=[];
  @override
  Widget build(BuildContext context) {
    double ancho= MediaQuery.of(context).size.width;
    double alto= MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
                    //color: Colors.brown,
                  //  width: ancho*0.55,
                  //  height: alto*0.55,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                       Container(
                      //itemExtent: 35.0,
                      //cacheExtent: 85.0,
                    width: ancho*0.80,
                    height: alto*0.80,
                      child:
                         //---INGRESANDO 'geo' se activa la opcion de toma de coordenadas por el celular---------------
                         
                         GestureDetector(
                           onPanDown: (details){
                             setState(() {
                               points.add(details.localPosition);
                             });
                           },
                           onPanUpdate: (details){
                              setState(() {
                                points.add(details.localPosition);
                             });
                           },
                           onPanEnd: (details){
                              setState(() {
                                points.add(null);
                             });
                           },
                           child: Container(
                            //color: Colors.brown,
                            width: ancho*0.70,
                            height: alto*0.70,
                           // child:Container()
                             child: CustomPaint(
                              painter: MyCustomPainter(points:points),
                            ) 
                          ),
                         )
                     
                    ), 
                    ] 
                  ),
      ),
      
    );
  }
}

class MyCustomPainter extends CustomPainter{
  
  List<Offset> points;
  MyCustomPainter({this.points});
  @override
  void paint(Canvas canvas, Size size) {
      Paint background = Paint()..color= Colors.white;
      Rect rect= Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawRect(rect,background);
      
      Paint paint = Paint();
      paint.color= Colors.black;
      paint.strokeWidth=2.0;
      paint.isAntiAlias=true;
      paint.strokeCap=StrokeCap.round;
     // if(points!=null&&points.isNotEmpty){
      for (var i = 0; i < points.length; i++) {
        if(points[i]!=null&&points[i+1]!=null){
          canvas.drawLine(points[i],points[i+1],paint);
        }else if(points[i]!=null&&points[i+1]==null){
          canvas.drawPoints(PointMode.points, [points[i]], paint);
        }
      }
     //}
    }
  
    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
  
}