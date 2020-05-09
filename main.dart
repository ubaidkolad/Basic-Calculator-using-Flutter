import 'dart:io';
import 'dart:convert';

import 'package:chest_xray/class/report.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Radiologist',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _file;
  Reports report;

  _selectImageCamera() async {
    var file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() {
        report = null;
        _file = file;
      });
    }
  }

  Future _selectImageGallery() async {
    var file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        report = null;
        _file = file;
      });
    }
  }

  _uploadImage() async {
    final String endPoint = 'http://192.168.0.109:5000/api';
    Map<String, String> headers = {"Content-type": "application/json"};
    if (_file == null) return;
    String base64Image = base64Encode(_file.readAsBytesSync());
    String fileName = _file.path.split("/").last;
    String json =
        '{"title": "Hello", "image": "$base64Image","filename":"$fileName"}';
    // make POST request
    await post(endPoint, headers: headers, body: json)
        .catchError((err) => print(err))
        .then((res) {
      setState(() {
        Map<String, dynamic> data = jsonDecode(res.body);
        report = Reports(data['filename'], data['image'], data['prob'].round());
      });
      // print(bsr);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.account_circle,
          size: 32,
        ),
        title: Text('Mini-Radiologist'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Upload your scans',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton.icon(
                color: Colors.blue,
                icon: Icon(
                  Icons.camera,
                  color: Colors.white,
                ),
                label: Text(
                  "Camera",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _selectImageCamera,
              ),
              RaisedButton.icon(
                color: Colors.blue,
                icon: Icon(Icons.photo_album, color: Colors.white),
                label: Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _selectImageGallery,
              ),
              RaisedButton.icon(
                color: Colors.blue,
                icon: Icon(
                  Icons.arrow_drop_up,
                  color: Colors.white,
                ),
                label: Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _file == null ? null : _uploadImage,
              )
            ],
          ),
          Container(
              padding: EdgeInsets.all(20),
              child: report == null
                  ? _file == null ? Text("Select Image") : Image.file(_file)
                  : Report(
                      report: report,
                    )),
        ],
      ),
    );
  }
}

class EdgeInsets {}

class Report extends StatefulWidget {
  final Reports report;
  Report({Key key, this.report}) : super(key: key);
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // List<charts.Series<Classesof, String>> series = pp;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.black),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              children: <Widget>[
                Container(
                  width: 180.4,
                  child: Image.memory(
                    base64Decode(widget.report.base64Image),
                  ),
                ),
                Container(
                  width: 181,
                  height: 180,
                  // padding: EdgeInsets.all(20),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Probablity in %",
                        ),
                        Expanded(
                          child: BarChart(chartMaker(widget.report.penoProb),
                              animate: true),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
        Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  "Probablity " + widget.report.penoProb.toString() + "%",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text("Result is " + widget.report.result,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                    "Filename: " +
                        widget.report.filename.replaceAll('.jpg', ''),
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            )),
      ],
    ));
  }
}
