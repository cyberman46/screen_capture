import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _globalKey = new GlobalKey();

  File _image;
  Future<File> _imageFile;

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      print(pngBytes);

      var filePath =
          await ImagePickerSaver.saveFile(fileData: pngBytes); //_imageFile.

      var savedFile = File.fromUri(Uri.file(filePath));
      setState(() {
        _imageFile = Future<File>.sync(() => savedFile);
        print("Saved");
      });

      print(bs64);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Widget To Image demo'),
        ),
        body: Column(
          children: <Widget>[
            RepaintBoundary(
              key: _globalKey,
              child: new Center(
                child: Container(
                  color: Colors.redAccent,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        'click below given button to capture iamge',
                      ),
                      new RaisedButton(
                        child: Text('capture Image'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton(
              onPressed: _capturePng,
              child: Text("Save"),
            )
          ],
        ));
  }
}
