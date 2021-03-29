import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_share/social_share.dart';

class ARScreen extends StatefulWidget {
  ARScreen({Key key}) : super(key: key);

  @override
  _ARScreenState createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  UnityWidgetController _unityWidgetController;
  Completer isImageSaved;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _unityWidgetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cerealis'),
        leading: IconButton(
          icon: Image.asset('cerealis_logo.png'),
          tooltip: 'App logo',
          onPressed: () => {},
        ),
        brightness: Brightness.dark,
      ),
      body: Stack(
        children: <Widget>[
          UnityWidget(
            onUnityCreated: _onUnityCreated,
            onUnityMessage: onUnityMessage,
            fullscreen: false,
          ),
          Positioned(
              bottom: 20,
              left: 20,
              child: FloatingActionButton(
                child: Icon(Icons.share),
                onPressed: () => share(),
              )),
        ],
      ),
    );
  }

  void share() async {
    waitingDialog();
    var permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      captureScreenshot("AR_camera");
      SocialShare.shareOptions("#cerealis #coloring #AR",
          imagePath: "/storage/emulated/0/DCIM/Camera/Cerealis/AR_camera.png");
    }
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
    if (message == "Fin appel du screenshot") {
      isImageSaved.complete();
    }
  }

  void captureScreenshot(String name) {
    _unityWidgetController.postMessage(
      'ARCamera',
      'Shot',
      name,
    );
  }

  void waitingDialog() {
    isImageSaved = Completer();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          isImageSaved.future.then((_) => Navigator.of(context).pop(true));
          return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                  content: Container(
                height: 80,
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Chargement",
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              )));
        });
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    this._unityWidgetController = controller;
  }
}
