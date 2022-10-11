// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:motion_sensors/motion_sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Vector3 _gyroscope = Vector3.zero();
  Vector3 _userAaccelerometer = Vector3.zero();

  final double center = 200;
  final double maxRad = 100;

  double x = 200;
  double y = 200;
  double rad = 50;

  @override
  void initState() {
    super.initState();
    //add a listener to the sensors. when there are changes set the state of the app

    motionSensors.gyroscope.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscope.setValues(event.x, event.y, event.z);
      });
    });

    motionSensors.userAccelerometer.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAaccelerometer.setValues(event.x, event.y, event.z);
        x = center - (event.x / 7) * center;
        y = center - (event.y / 4) * center;
        rad = maxRad - (event.z / 4) * maxRad;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Motion Sensors'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Gyroscope'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('${_gyroscope.x.toStringAsFixed(4)}'),
                  Text('${_gyroscope.y.toStringAsFixed(4)}'),
                  Text('${_gyroscope.z.toStringAsFixed(4)}'),
                ],
              ),
              Text('User Accelerometer'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('${_userAaccelerometer.x.toStringAsFixed(4)}'),
                  Text('${_userAaccelerometer.y.toStringAsFixed(4)}'),
                  Text('${_userAaccelerometer.z.toStringAsFixed(4)}'),
                ],
              ),
              SizedBox(
                width: 400,
                height: 400,
                child: CustomPaint(
                  painter: OpenPainter(x, y, rad),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OpenPainter extends CustomPainter {
  double x;
  double y;
  double rad;

  OpenPainter(this.x, this.y, this.rad);
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color.fromARGB(255, x.toInt(), y.toInt(), rad.toInt())
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), rad, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
